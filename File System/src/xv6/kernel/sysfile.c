//
// File-system system calls.
// Mostly argument checking, since we don't trust
// user code, and calls into file.c and fs.c.
//

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

uint64
sys_dup(void)
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}

uint64
sys_read(void)
{
  struct file *f;
  int n;
  uint64 p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    return -1;
  return fileread(f, p, n);
}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    return -1;

  return filewrite(f, p, n);
}

uint64
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

uint64
sys_fstat(void)
{
  struct file *f;
  uint64 st; // user pointer to struct stat

  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    return -1;
  return filestat(f, st);
}

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;

bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}

uint64
sys_unlink(void)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  ilock(dp);

  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}

uint64
sys_open(void)
{
  // TODO: Symbolic links to Files
  // open() should handle symbolic link
  // If the file is a symbolic link, and O_NOFOLLOW is not specified,
  // then you should read the path in the symbolic link,
  // and return the corresponding file.

  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    return -1;

  begin_op();
  
  int follow_links = !(omode & O_NOFOLLOW);
  int count_links  = 0;

  while(count_links<20){  
    count_links++;
    //printf("Attempting to open: %s\n", path);
    if(omode & O_CREATE){
      //printf("Creating file: %s\n", path);
      ip = create(path, T_FILE, 0, 0);
      if(ip == 0){
        end_op();
        return -1;
      }
      break;
    } else {
      if (count_links >= 20) {
        end_op();
        return -1;
      }
      //printf("Looking up: %s\n", path);
      if((ip = namei(path)) == 0){
        //printf("File not found: %s\n", path);
        end_op();
        return -1;
      }
      ilock(ip);
      /*(ip->type == T_DIR && omode != O_RDONLY){
        printf("Attempt to open directory with write access: %s\n", path);
        iunlockput(ip);
        end_op();
        return -1;
      }*/
      if (ip->type == T_SYMLINK && follow_links) {
        //printf("Symbolic link found: %s\n", path);
        char symlink_path[MAXPATH];
        
        int len = readi(ip, 0, (uint64)symlink_path, 0, sizeof(symlink_path));
        
        if (len < 0 || len >= sizeof(symlink_path)) {
            end_op();
            return -1;
        }
        symlink_path[len] = '\0';
        //printf("Resolved symbolic link to: %s\n", symlink_path);
        strncpy(path, symlink_path, sizeof(path));
        iunlockput(ip);
      }else{
        break;
      }
    }  
  }// while loop break when: count_links>=20 or create() or not a Symbolic link


  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
        iunlockput(ip);
        end_op();
        return -1;
      } 
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
  }

  iunlock(ip);
  end_op();

  return fd;
}

uint64
sys_mkdir(void)
{
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_mknod(void)
{
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
  if((argstr(0, path, MAXPATH)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}

uint64
sys_chdir(void)
{
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
  
  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
  iput(p->cwd);
  end_op();
  p->cwd = ip;
  return 0;
}

uint64
sys_exec(void)
{
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv)){
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
      goto bad;
    }
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);
  return -1;
}

uint64
sys_pipe(void)
{
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();

  if(argaddr(0, &fdarray) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    p->ofile[fd0] = 0;
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
}

uint64
sys_symlink(void)
{
  // TODO: symbolic link
  // You should implement this symlink system call.
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;

  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    return -1;
  begin_op();
  if((ip = namei(path)) != 0){
    end_op();
    return -1;
  }  
	if((ip = create(path,T_SYMLINK,0,0)) == 0){
    end_op();
    return -1;
  }
  iunlock(ip);
  ilock(ip);
  if(writei(ip,0, (uint64)(target), 0, strlen(target)) < strlen(target)){
    printf("write error");
    iunlock(ip);
    end_op();
    return -1;
  }

  iunlock(ip);  
  end_op();
  // panic("You should implement symlink system call.");

  return 0;
}


// // 遞歸遍歷目錄並處理符號鏈接
// int  traverse_directory(struct inode *dp, char* target, char* userbuf, char* now_path) {
//   struct dirent de;
//   struct inode *ip;
  
  
  

//   for (int off = 0; off < dp->size; off += sizeof(de)) {
//     if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) {
//       panic("traverse_directory: readi");
//     }

//     if (de.inum == 0)
//       return -1;


//     ip = iget(dp->dev, de.inum);
//     if(strncmp(de.name, ".", strlen(de.name))==0 || strncmp(de.name, "..", strlen(de.name))==0)
//       continue;
//     ilock(ip);
//     //TODO
//     char new_path[256];
//     char symbolic_path[256];
//     memset(new_path, 0, 256);
//     memset(symbolic_path, 0, 256);
//     readi(dp, 0, (uint64)(symbolic_path), 0, ip->size);
//     if(ip->type==T_SYMLINK){
//         if(strncmp(target, symbolic_path, strlen(target))){
//           strncpy(new_path, now_path, sizeof(now_path));
//           strcat(new_path, "/");
//           strcat(new_path, de.name);
//           strcat(userbuf, " ");
//           strcat(userbuf, new_path);
//         }
//     }
//     if(ip->type== T_DIR){
//         strncpy(new_path, now_path, sizeof(now_path));
//         strcat(new_path, "/");
//         strcat(new_path, de.name);
//         traverse_directory(ip, target, userbuf,new_path);
//     }

//     iunlock(ip);
//   }

//   return 0;
// }

// // 系統調用接口
// uint64 sys_revreadlink(void) {
//   char target[MAXPATH];
//   uint64 bufaddr;
//   int bufsize;
  

//   if (argstr(0, target, MAXPATH) < 0 || argaddr(1, &bufaddr) < 0 || argint(2, &bufsize) < 0) {
//     return -1;
//   }
//   char userbuf[bufsize];
//   char now_path[256] = "";
//   memset(userbuf, 0, sizeof(userbuf));
//   begin_op();
//   struct inode *dp;
//   dp = namei("/");
//   //TODO
//   ilock(dp);
//   traverse_directory(dp,target,userbuf,now_path);
//   iunlockput(dp);
//   end_op();
//   if (copyout(myproc()->pagetable, bufaddr, userbuf+1, strlen(userbuf)) < 0) {
//     return -1;
//   }

//   return strlen(userbuf);
// }
int
find_symlinks(struct inode *dp, char *target, char* userbuf, char* now_path)
{
    struct dirent de;
    struct inode *ip;

    for (int i = 0; i < dp->size; i += sizeof(de)) { //go through the directory
      if(readi(dp,0,(uint64)(&de),i,sizeof(de)) != sizeof(de)){  //write entry into dirent de
        //printf("can't read from directory.\n");
        //end_op();
        return -1;
      }
      //printf("entry %d of dir %d, inum = %d, name = %s\n",i,dp->inum ,de.inum, de.name);
      if (de.inum == 0){
        //printf("get inode with inum = 0\n ");
        //end_op();
        return -1;
      }
      ip = iget(dp->dev,de.inum);
      //printf("get inode with inum = %d,type = %d\n ",ip->inum,ip->type);
      if(strncmp(de.name,".",strlen(de.name)) == 0 || strncmp(de.name,"..",strlen(de.name)) == 0){// skip . and ..
        continue;
      }
      ilock(ip);
      char new_path[256];
      char path_in_symbolic[256];
      memset(new_path, 0, sizeof(new_path));
      memset(path_in_symbolic, 0, sizeof(path_in_symbolic));

      if (ip->type == T_SYMLINK) {
        //printf("find a symfile: %s\n",de.name);
        readi(ip, 0, (uint64)path_in_symbolic, 0, ip->size); //read path from symlink file
        if(strncmp(path_in_symbolic,target,strlen(target)) == 0){//symlink point to target
          //printf("%s point to %s\n",de.name,target);
          strncpy(new_path,now_path,strlen(now_path));
          //printf("new_path = %s\n",new_path);
          strcat(new_path,"/");
          //printf("new_path = %s\n",new_path);
          strcat(new_path,de.name);
          //printf("new_path = %s\n",new_path);
          if(strlen(userbuf)>1){
            strcat(userbuf," ");
          }
          //printf("userbuf = %s\n",userbuf);
          strcat(userbuf,new_path);
          //printf("userbuf = %s\n",userbuf);
        }
      }
      if(ip->type == T_DIR){
        //printf("find a dir: %s\n",de.name);
        strncpy(new_path,now_path,strlen(now_path));
        strcat(new_path,"/");
        strcat(new_path,de.name);
        find_symlinks(ip, target, userbuf, new_path);
      }
      iunlock(ip);
      //end_op();
    }
    //printf("end of find symlink\n");
    return 0;
}

uint64
sys_revreadlink(void) 
{
  // TODO: Find all symbolic links that point to 'target'
  char target[MAXPATH];
  uint64 bufaddr;
  int bufsize;

  if(argstr(0, target, MAXPATH) < 0 || argaddr(1, &bufaddr) < 0 || argint(2, &bufsize) < 0)
    return -1;

  char userbuf[bufsize];
  memset(userbuf, 0, sizeof(userbuf));

  // implement the code
  begin_op();
  struct inode *ip = namei("/");
  char now_path[256] = "";

  ilock(ip);
  //printf("get inode of root\n");
  find_symlinks(ip, target, userbuf, now_path);
  //printf("after findsym\n");
  
  iunlockput(ip);
  //printf("%s\n",userbuf);
  end_op();
  int total = strlen(userbuf);
  //printf("%d\n",total);

  // Copy the result from kernel to user space, userbuf should store all symbolic links that point to 'target'
  if(copyout(myproc()->pagetable, bufaddr, userbuf, strlen(userbuf)) < 0)
    return -1;

  // Return the number of bytes written to user buffer
    
  //panic("sys_revreadlink is not implemented yet");

  //return -1;
  return total;
}