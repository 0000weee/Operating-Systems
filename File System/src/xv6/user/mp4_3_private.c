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
#define MAXBUFSIZE 512

static int failed = 0;

static void private1(void);
static void private2(void);
static void cleanup(void);


int
main(int argc, char *argv[])
{
    cleanup();
    private1();
    cleanup();
    private2();
    cleanup();
    exit(failed);
}

static void
cleanup(void){
  // private 1
  unlink("/test1");
  unlink("/test2");
  unlink("/test3");
  unlink("/test4");

  // private 2
  unlink("/testa/test1/target");
  unlink("/testa/test1/link");
  unlink("/testa/test1");
  unlink("/testa/test2");
  unlink("/testa");
  unlink("/testb");
}

static void
private1(void)
{
    int r, fd1 = -1;
    char buf[MAXBUFSIZE] = {0};

    printf("private testcase 1:\n");

    // 1. Create a symlink chain 1 -> 2 -> 3 -> 4
    r = symlink("/test2", "/test1");
    if(r) fail("Failed to link 1->2");
    r = symlink("/test3", "/test2");
    if(r) fail("Failed to link 2->3");
    r = symlink("/test4", "/test3");
    if(r) fail("Failed to link 3->4");
    r = symlink("/test1", "/test4");
    if(r) fail("Failed to link 4->1");

    r = revreadlink("/test1", buf, sizeof(buf));
    if (r < 0) fail("revreadlink call failed\n");

    buf[r] = '\0';
    printf("%s\n", buf);

done:
    close(fd1);
}

static void
private2(void)
{
    int r, fd1 = -1;
    char buf[MAXBUFSIZE] = {0};

    printf("private testcase 2:\n");

    mkdir("/testa");
    mkdir("/testa/test1");
    
    fd1 = open("/testa/test1/target", O_CREATE | O_RDWR);
    if(fd1 < 0) fail("create target failed\n");

    r = symlink("/testa/test1/target", "/testb");
    if(r < 0) fail("symlink testb -> target failed");
    r = symlink("/testa/test1/target", "/testa/test2");
    if(r < 0) fail("symlink test1 -> testa failed");
    r = symlink("/testa/test1/target", "/testa/test1/link");
    if(r < 0) fail("symlink link -> testa failed");

    r = revreadlink("/testa/test1/target", buf, sizeof(buf));
    if (r < 0) fail("revreadlink call failed\n");

    buf[r] = '\0';
    printf("%s\n", buf);

done:
    close(fd1);
}
