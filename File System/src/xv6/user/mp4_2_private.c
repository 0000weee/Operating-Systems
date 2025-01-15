// simple signature (sha512): af2fc23597d454063d5e102d3b80105071fdb365dd55a0a15e4b15a21eca89265ffe707bcbd9f92de9c38a1d6b14b5d13f96c42a9366c8560296aaf0ba43a291
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "kernel/fcntl.h"
#include "kernel/spinlock.h"
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"

#define fail(msg) do {printf("FAILURE: " msg "\n"); failed = 1; goto done;} while (0);
static int failed = 0;

static void private1(void);
static void private2(void);
static void private3(void);
static void cleanup(void);

int main() {
  cleanup();
  private1();
  cleanup();
  private2();
  cleanup();
  private3();
  cleanup();
  exit(failed);
}

static void
cleanup(void)
{
  // private 1
  char long_target[128] = "/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/target";
  char *p;
  unlink(long_target);
  long_target[120] = '\0';
  for (p = long_target; p < long_target + 120; p += 15) {
    unlink(p);
  }
  unlink("/testsymlink/a");
  unlink("/testsymlink/b");

  // private 2
  unlink("/testsymlink/1");
  unlink("/testsymlink/2");
  unlink("/testsymlink/3");
  unlink("/testsymlink/4");
  unlink("/testsymlink/5");
  unlink("/testsymlink/6");

  // private 3
  unlink("/testsymlink/dirA/dir1/3");
  unlink("/testsymlink/dirA/2");
  unlink("/testsymlink/dirA/5");
  unlink("/testsymlink/dirB/4");
  unlink("/testsymlink/dirA/dir1");
  unlink("/testsymlink/dirA");
  unlink("/testsymlink/dirB");
  unlink("/testsymlink");
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);

  if(fd < 0)
    return -1;
  if(fstat(fd, st) != 0)
    return -1;
  return 0;
}

static void
private1(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  char c = 0;
  struct stat st;
  char long_target[128] = "/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/test_directory/target";
  char *p;
    
  printf("private testcase 1:\n");

  mkdir("/testsymlink");
  long_target[120] = '\0';
  for (p = long_target + 105; p >= long_target; p -= 15)
    mkdir(p);
  long_target[120] = '/';

  // 1. Create file long_target
  fd1 = open(long_target, O_CREATE | O_RDWR);
  if(fd1 < 0) fail("failed to open a");

  // 2. Create symlink b -> long_target
  r = symlink(long_target, "/testsymlink/b");
  if(r < 0)
    fail("symlink b -> long_target failed");

  // 3. check b file type
  if (stat_slink("/testsymlink/b", &st) != 0)
    fail("failed to stat b");
  if(st.type != T_SYMLINK)
    fail("b isn't a symlink");

  // 4. Write a
  if(write(fd1, buf, sizeof(buf)) != 4)
    fail("failed to write to long_target");

  // 5. Read b and check if it is identical to a.
  fd2 = open("/testsymlink/b", O_RDWR);
  if(fd2 < 0)
    fail("failed to open b");
  read(fd2, &c, 1);
  if (c != 'a')
    fail("b and long_target are not the same");

  printf("private testcase 1: ok\n");

done:
  close(fd1);
  close(fd2);
}

static void
private2(void)
{
  int r, fd1 = -1, fd2 = -1, fd3 = -1;
  char c = 0, c2 = 0;
    
  printf("private testcase 2:\n");

  mkdir("/testsymlink");

  // 1. Create a symlink chain 1 -> 2 -> 3 -> 4
  r = symlink("/testsymlink/2", "/testsymlink/1");
  if(r) fail("Failed to link 1->2");
  r = symlink("/testsymlink/3", "/testsymlink/2");
  if(r) fail("Failed to link 2->3");
  r = symlink("/testsymlink/4", "/testsymlink/3");
  if(r) fail("Failed to link 3->4");
  r = symlink("/testsymlink/1", "/testsymlink/4");
  if(r) fail("Failed to link 4->1");

  // 2. Open 1 with O_NOFOLLOW and without.
  fd1 = open("/testsymlink/1", O_NOFOLLOW | O_RDWR);
  if(fd1<0) fail("Failed to open 1 with O_NOFOLLOW\n");
  fd2 = open("/testsymlink/1", O_RDWR);
  if(fd2!=-1) fail("W0w! Y0u f1nd 7h3 3nd 0f 7h3 5yml1nk cycl3!\n");

  // 3. Create file 5
  fd3 = open("/testsymlink/5", O_CREATE | O_RDWR);
  if(fd3 < 0) fail("failed to open /testsymlink/5");

  // Write 1 to symlink to 5 and write to 5
  close(fd1);
  fd1 = -1;
  unlink("/testsymlink/1");
  r = symlink("/testsymlink/5", "/testsymlink/1");
  if(r) fail("Failed to link 1->5");
  c = '!';
  r = write(fd3, &c, 1);
  if(r!=1) fail("Failed to write to 5\n");

  // Open 5 from 4 and check content
  fd2 = open("/testsymlink/4", O_RDWR);
  if(fd2<0) fail("Failed to open 4\n");
  r = read(fd2, &c2, 1);
  if(r!=1) fail("Failed to read from 4\n");
  if(c!=c2)
    fail("Value read from 4 differed from value written to 5\n");

  printf("private testcase 2: ok\n");

done:
  if (fd1 != -1) close(fd1);
  close(fd2);
  close(fd3);
}

static void
private3(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
    
  printf("private testcase 3:\n");

  mkdir("/testsymlink");
  mkdir("/testsymlink/dirA");
  mkdir("/testsymlink/dirA/dir1");
  mkdir("/testsymlink/dirB");

  // 1. Create a symlink chain 1 -> 2 -> 3 -> 4 -> 5 -> 6
  r = symlink("/testsymlink/dirA/2", "/testsymlink/1");
  if(r) fail("Failed to link 1->dirA/2");
  r = symlink("/testsymlink/dirA/dir1/3", "/testsymlink/dirA/2");
  if(r) fail("Failed to link dirA/2->dirA/dir1/3");
  r = symlink("/testsymlink/dirB/4", "/testsymlink/dirA/dir1/3");
  if(r) fail("Failed to link dirA/dir1/3->dirB/4");
  r = symlink("/testsymlink/dirA/5", "/testsymlink/dirB/4");
  if(r) fail("Failed to link dirB/4->dirA/5");
  r = symlink("/testsymlink/6", "/testsymlink/dirA/5");
  if(r) fail("Failed to link dirA/5->6");

  // 2. Open 1 and 4.
  fd1 = open("/testsymlink/6", O_CREATE | O_RDWR);
  if(fd1<0) fail("Failed to create 6\n");
  fd2 = open("/testsymlink/1", O_RDWR);
  if(fd2<0) fail("Failed to open 1\n");

  // Write 1 and read 4 to check they are the same file.
  c = '#';
  r = write(fd2, &c, 1);
  if(r!=1) fail("Failed to write to 1\n");
  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from 6\n");
  if(c!=c2)
    fail("Value read from 6 differed from value written to 1\n");

  printf("private testcase 3: ok\n");

done:
  close(fd1);
  close(fd2);
}
