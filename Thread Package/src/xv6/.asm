
user/_mp1-part2-2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <f1>:

static struct thread *t;
static int cnt = 0;

void f1(void *arg)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("%s 1: %d\n", (cnt == 0)? "thread" : "task", cnt);
   8:	00001617          	auipc	a2,0x1
   c:	cb862603          	lw	a2,-840(a2) # cc0 <cnt>
  10:	00001597          	auipc	a1,0x1
  14:	c4858593          	addi	a1,a1,-952 # c58 <thread_assign_task+0x62>
  18:	c609                	beqz	a2,22 <f1+0x22>
  1a:	00001597          	auipc	a1,0x1
  1e:	c4658593          	addi	a1,a1,-954 # c60 <thread_assign_task+0x6a>
  22:	00001517          	auipc	a0,0x1
  26:	c4650513          	addi	a0,a0,-954 # c68 <thread_assign_task+0x72>
  2a:	00000097          	auipc	ra,0x0
  2e:	68e080e7          	jalr	1678(ra) # 6b8 <printf>
    cnt++;
  32:	00001717          	auipc	a4,0x1
  36:	c8e70713          	addi	a4,a4,-882 # cc0 <cnt>
  3a:	431c                	lw	a5,0(a4)
  3c:	2785                	addiw	a5,a5,1
  3e:	0007869b          	sext.w	a3,a5
  42:	c31c                	sw	a5,0(a4)

    if (cnt < 10){
  44:	47a5                	li	a5,9
  46:	00d7da63          	bge	a5,a3,5a <f1+0x5a>
        thread_assign_task(t, f1, NULL);
    }

    thread_yield();
  4a:	00001097          	auipc	ra,0x1
  4e:	b1c080e7          	jalr	-1252(ra) # b66 <thread_yield>
}
  52:	60a2                	ld	ra,8(sp)
  54:	6402                	ld	s0,0(sp)
  56:	0141                	addi	sp,sp,16
  58:	8082                	ret
        thread_assign_task(t, f1, NULL);
  5a:	4601                	li	a2,0
  5c:	00000597          	auipc	a1,0x0
  60:	fa458593          	addi	a1,a1,-92 # 0 <f1>
  64:	00001517          	auipc	a0,0x1
  68:	c6453503          	ld	a0,-924(a0) # cc8 <t>
  6c:	00001097          	auipc	ra,0x1
  70:	b8a080e7          	jalr	-1142(ra) # bf6 <thread_assign_task>
  74:	bfd9                	j	4a <f1+0x4a>

0000000000000076 <main>:

int main(int argc, char **argv)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
    printf("mp1-part2-2\n");
  7e:	00001517          	auipc	a0,0x1
  82:	bfa50513          	addi	a0,a0,-1030 # c78 <thread_assign_task+0x82>
  86:	00000097          	auipc	ra,0x0
  8a:	632080e7          	jalr	1586(ra) # 6b8 <printf>
    t = thread_create(f1, NULL);
  8e:	4581                	li	a1,0
  90:	00000517          	auipc	a0,0x0
  94:	f7050513          	addi	a0,a0,-144 # 0 <f1>
  98:	00001097          	auipc	ra,0x1
  9c:	838080e7          	jalr	-1992(ra) # 8d0 <thread_create>
  a0:	00001797          	auipc	a5,0x1
  a4:	c2a7b423          	sd	a0,-984(a5) # cc8 <t>
    thread_add_runqueue(t);
  a8:	00001097          	auipc	ra,0x1
  ac:	890080e7          	jalr	-1904(ra) # 938 <thread_add_runqueue>
    thread_start_threading();
  b0:	00001097          	auipc	ra,0x1
  b4:	b1a080e7          	jalr	-1254(ra) # bca <thread_start_threading>
    printf("\nexited\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	bd050513          	addi	a0,a0,-1072 # c88 <thread_assign_task+0x92>
  c0:	00000097          	auipc	ra,0x0
  c4:	5f8080e7          	jalr	1528(ra) # 6b8 <printf>
    exit(0);
  c8:	4501                	li	a0,0
  ca:	00000097          	auipc	ra,0x0
  ce:	276080e7          	jalr	630(ra) # 340 <exit>

00000000000000d2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d8:	87aa                	mv	a5,a0
  da:	0585                	addi	a1,a1,1
  dc:	0785                	addi	a5,a5,1
  de:	fff5c703          	lbu	a4,-1(a1)
  e2:	fee78fa3          	sb	a4,-1(a5)
  e6:	fb75                	bnez	a4,da <strcpy+0x8>
    ;
  return os;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x1e>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x1e>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strlen>:

uint
strlen(const char *s)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf91                	beqz	a5,140 <strlen+0x26>
 126:	0505                	addi	a0,a0,1
 128:	87aa                	mv	a5,a0
 12a:	4685                	li	a3,1
 12c:	9e89                	subw	a3,a3,a0
 12e:	00f6853b          	addw	a0,a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	fb7d                	bnez	a4,12e <strlen+0x14>
    ;
  return n;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  for(n = 0; s[n]; n++)
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strlen+0x20>

0000000000000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14a:	ca19                	beqz	a2,160 <memset+0x1c>
 14c:	87aa                	mv	a5,a0
 14e:	1602                	slli	a2,a2,0x20
 150:	9201                	srli	a2,a2,0x20
 152:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 156:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15a:	0785                	addi	a5,a5,1
 15c:	fee79de3          	bne	a5,a4,156 <memset+0x12>
  }
  return dst;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cb99                	beqz	a5,186 <strchr+0x20>
    if(*s == c)
 172:	00f58763          	beq	a1,a5,180 <strchr+0x1a>
  for(; *s; s++)
 176:	0505                	addi	a0,a0,1
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbfd                	bnez	a5,172 <strchr+0xc>
      return (char*)s;
  return 0;
 17e:	4501                	li	a0,0
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret
  return 0;
 186:	4501                	li	a0,0
 188:	bfe5                	j	180 <strchr+0x1a>

000000000000018a <gets>:

char*
gets(char *buf, int max)
{
 18a:	711d                	addi	sp,sp,-96
 18c:	ec86                	sd	ra,88(sp)
 18e:	e8a2                	sd	s0,80(sp)
 190:	e4a6                	sd	s1,72(sp)
 192:	e0ca                	sd	s2,64(sp)
 194:	fc4e                	sd	s3,56(sp)
 196:	f852                	sd	s4,48(sp)
 198:	f456                	sd	s5,40(sp)
 19a:	f05a                	sd	s6,32(sp)
 19c:	ec5e                	sd	s7,24(sp)
 19e:	1080                	addi	s0,sp,96
 1a0:	8baa                	mv	s7,a0
 1a2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	892a                	mv	s2,a0
 1a6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a8:	4aa9                	li	s5,10
 1aa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ac:	89a6                	mv	s3,s1
 1ae:	2485                	addiw	s1,s1,1
 1b0:	0344d863          	bge	s1,s4,1e0 <gets+0x56>
    cc = read(0, &c, 1);
 1b4:	4605                	li	a2,1
 1b6:	faf40593          	addi	a1,s0,-81
 1ba:	4501                	li	a0,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	19c080e7          	jalr	412(ra) # 358 <read>
    if(cc < 1)
 1c4:	00a05e63          	blez	a0,1e0 <gets+0x56>
    buf[i++] = c;
 1c8:	faf44783          	lbu	a5,-81(s0)
 1cc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d0:	01578763          	beq	a5,s5,1de <gets+0x54>
 1d4:	0905                	addi	s2,s2,1
 1d6:	fd679be3          	bne	a5,s6,1ac <gets+0x22>
  for(i=0; i+1 < max; ){
 1da:	89a6                	mv	s3,s1
 1dc:	a011                	j	1e0 <gets+0x56>
 1de:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e0:	99de                	add	s3,s3,s7
 1e2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e6:	855e                	mv	a0,s7
 1e8:	60e6                	ld	ra,88(sp)
 1ea:	6446                	ld	s0,80(sp)
 1ec:	64a6                	ld	s1,72(sp)
 1ee:	6906                	ld	s2,64(sp)
 1f0:	79e2                	ld	s3,56(sp)
 1f2:	7a42                	ld	s4,48(sp)
 1f4:	7aa2                	ld	s5,40(sp)
 1f6:	7b02                	ld	s6,32(sp)
 1f8:	6be2                	ld	s7,24(sp)
 1fa:	6125                	addi	sp,sp,96
 1fc:	8082                	ret

00000000000001fe <stat>:

int
stat(const char *n, struct stat *st)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e426                	sd	s1,8(sp)
 206:	e04a                	sd	s2,0(sp)
 208:	1000                	addi	s0,sp,32
 20a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	4581                	li	a1,0
 20e:	00000097          	auipc	ra,0x0
 212:	172080e7          	jalr	370(ra) # 380 <open>
  if(fd < 0)
 216:	02054563          	bltz	a0,240 <stat+0x42>
 21a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21c:	85ca                	mv	a1,s2
 21e:	00000097          	auipc	ra,0x0
 222:	17a080e7          	jalr	378(ra) # 398 <fstat>
 226:	892a                	mv	s2,a0
  close(fd);
 228:	8526                	mv	a0,s1
 22a:	00000097          	auipc	ra,0x0
 22e:	13e080e7          	jalr	318(ra) # 368 <close>
  return r;
}
 232:	854a                	mv	a0,s2
 234:	60e2                	ld	ra,24(sp)
 236:	6442                	ld	s0,16(sp)
 238:	64a2                	ld	s1,8(sp)
 23a:	6902                	ld	s2,0(sp)
 23c:	6105                	addi	sp,sp,32
 23e:	8082                	ret
    return -1;
 240:	597d                	li	s2,-1
 242:	bfc5                	j	232 <stat+0x34>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24a:	00054603          	lbu	a2,0(a0)
 24e:	fd06079b          	addiw	a5,a2,-48
 252:	0ff7f793          	andi	a5,a5,255
 256:	4725                	li	a4,9
 258:	02f76963          	bltu	a4,a5,28a <atoi+0x46>
 25c:	86aa                	mv	a3,a0
  n = 0;
 25e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 260:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 262:	0685                	addi	a3,a3,1
 264:	0025179b          	slliw	a5,a0,0x2
 268:	9fa9                	addw	a5,a5,a0
 26a:	0017979b          	slliw	a5,a5,0x1
 26e:	9fb1                	addw	a5,a5,a2
 270:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 274:	0006c603          	lbu	a2,0(a3)
 278:	fd06071b          	addiw	a4,a2,-48
 27c:	0ff77713          	andi	a4,a4,255
 280:	fee5f1e3          	bgeu	a1,a4,262 <atoi+0x1e>
  return n;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  n = 0;
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <atoi+0x40>

000000000000028e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 294:	02b57463          	bgeu	a0,a1,2bc <memmove+0x2e>
    while(n-- > 0)
 298:	00c05f63          	blez	a2,2b6 <memmove+0x28>
 29c:	1602                	slli	a2,a2,0x20
 29e:	9201                	srli	a2,a2,0x20
 2a0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a6:	0585                	addi	a1,a1,1
 2a8:	0705                	addi	a4,a4,1
 2aa:	fff5c683          	lbu	a3,-1(a1)
 2ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b2:	fee79ae3          	bne	a5,a4,2a6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
    dst += n;
 2bc:	00c50733          	add	a4,a0,a2
    src += n;
 2c0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c2:	fec05ae3          	blez	a2,2b6 <memmove+0x28>
 2c6:	fff6079b          	addiw	a5,a2,-1
 2ca:	1782                	slli	a5,a5,0x20
 2cc:	9381                	srli	a5,a5,0x20
 2ce:	fff7c793          	not	a5,a5
 2d2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d4:	15fd                	addi	a1,a1,-1
 2d6:	177d                	addi	a4,a4,-1
 2d8:	0005c683          	lbu	a3,0(a1)
 2dc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x46>
 2e4:	bfc9                	j	2b6 <memmove+0x28>

00000000000002e6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ec:	ca05                	beqz	a2,31c <memcmp+0x36>
 2ee:	fff6069b          	addiw	a3,a2,-1
 2f2:	1682                	slli	a3,a3,0x20
 2f4:	9281                	srli	a3,a3,0x20
 2f6:	0685                	addi	a3,a3,1
 2f8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	0005c703          	lbu	a4,0(a1)
 302:	00e79863          	bne	a5,a4,312 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 306:	0505                	addi	a0,a0,1
    p2++;
 308:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30a:	fed518e3          	bne	a0,a3,2fa <memcmp+0x14>
  }
  return 0;
 30e:	4501                	li	a0,0
 310:	a019                	j	316 <memcmp+0x30>
      return *p1 - *p2;
 312:	40e7853b          	subw	a0,a5,a4
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  return 0;
 31c:	4501                	li	a0,0
 31e:	bfe5                	j	316 <memcmp+0x30>

0000000000000320 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 328:	00000097          	auipc	ra,0x0
 32c:	f66080e7          	jalr	-154(ra) # 28e <memmove>
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 338:	4885                	li	a7,1
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <exit>:
.global exit
exit:
 li a7, SYS_exit
 340:	4889                	li	a7,2
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <wait>:
.global wait
wait:
 li a7, SYS_wait
 348:	488d                	li	a7,3
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 350:	4891                	li	a7,4
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <read>:
.global read
read:
 li a7, SYS_read
 358:	4895                	li	a7,5
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <write>:
.global write
write:
 li a7, SYS_write
 360:	48c1                	li	a7,16
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <close>:
.global close
close:
 li a7, SYS_close
 368:	48d5                	li	a7,21
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <kill>:
.global kill
kill:
 li a7, SYS_kill
 370:	4899                	li	a7,6
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exec>:
.global exec
exec:
 li a7, SYS_exec
 378:	489d                	li	a7,7
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <open>:
.global open
open:
 li a7, SYS_open
 380:	48bd                	li	a7,15
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 388:	48c5                	li	a7,17
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 390:	48c9                	li	a7,18
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 398:	48a1                	li	a7,8
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <link>:
.global link
link:
 li a7, SYS_link
 3a0:	48cd                	li	a7,19
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a8:	48d1                	li	a7,20
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b0:	48a5                	li	a7,9
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b8:	48a9                	li	a7,10
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c0:	48ad                	li	a7,11
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c8:	48b1                	li	a7,12
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d0:	48b5                	li	a7,13
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d8:	48b9                	li	a7,14
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	00000097          	auipc	ra,0x0
 3f6:	f6e080e7          	jalr	-146(ra) # 360 <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 402:	7139                	addi	sp,sp,-64
 404:	fc06                	sd	ra,56(sp)
 406:	f822                	sd	s0,48(sp)
 408:	f426                	sd	s1,40(sp)
 40a:	f04a                	sd	s2,32(sp)
 40c:	ec4e                	sd	s3,24(sp)
 40e:	0080                	addi	s0,sp,64
 410:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 412:	c299                	beqz	a3,418 <printint+0x16>
 414:	0805c863          	bltz	a1,4a4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 418:	2581                	sext.w	a1,a1
  neg = 0;
 41a:	4881                	li	a7,0
 41c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 420:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 422:	2601                	sext.w	a2,a2
 424:	00001517          	auipc	a0,0x1
 428:	87c50513          	addi	a0,a0,-1924 # ca0 <digits>
 42c:	883a                	mv	a6,a4
 42e:	2705                	addiw	a4,a4,1
 430:	02c5f7bb          	remuw	a5,a1,a2
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	97aa                	add	a5,a5,a0
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 442:	0005879b          	sext.w	a5,a1
 446:	02c5d5bb          	divuw	a1,a1,a2
 44a:	0685                	addi	a3,a3,1
 44c:	fec7f0e3          	bgeu	a5,a2,42c <printint+0x2a>
  if(neg)
 450:	00088b63          	beqz	a7,466 <printint+0x64>
    buf[i++] = '-';
 454:	fd040793          	addi	a5,s0,-48
 458:	973e                	add	a4,a4,a5
 45a:	02d00793          	li	a5,45
 45e:	fef70823          	sb	a5,-16(a4)
 462:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 466:	02e05863          	blez	a4,496 <printint+0x94>
 46a:	fc040793          	addi	a5,s0,-64
 46e:	00e78933          	add	s2,a5,a4
 472:	fff78993          	addi	s3,a5,-1
 476:	99ba                	add	s3,s3,a4
 478:	377d                	addiw	a4,a4,-1
 47a:	1702                	slli	a4,a4,0x20
 47c:	9301                	srli	a4,a4,0x20
 47e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 482:	fff94583          	lbu	a1,-1(s2)
 486:	8526                	mv	a0,s1
 488:	00000097          	auipc	ra,0x0
 48c:	f58080e7          	jalr	-168(ra) # 3e0 <putc>
  while(--i >= 0)
 490:	197d                	addi	s2,s2,-1
 492:	ff3918e3          	bne	s2,s3,482 <printint+0x80>
}
 496:	70e2                	ld	ra,56(sp)
 498:	7442                	ld	s0,48(sp)
 49a:	74a2                	ld	s1,40(sp)
 49c:	7902                	ld	s2,32(sp)
 49e:	69e2                	ld	s3,24(sp)
 4a0:	6121                	addi	sp,sp,64
 4a2:	8082                	ret
    x = -xx;
 4a4:	40b005bb          	negw	a1,a1
    neg = 1;
 4a8:	4885                	li	a7,1
    x = -xx;
 4aa:	bf8d                	j	41c <printint+0x1a>

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	7119                	addi	sp,sp,-128
 4ae:	fc86                	sd	ra,120(sp)
 4b0:	f8a2                	sd	s0,112(sp)
 4b2:	f4a6                	sd	s1,104(sp)
 4b4:	f0ca                	sd	s2,96(sp)
 4b6:	ecce                	sd	s3,88(sp)
 4b8:	e8d2                	sd	s4,80(sp)
 4ba:	e4d6                	sd	s5,72(sp)
 4bc:	e0da                	sd	s6,64(sp)
 4be:	fc5e                	sd	s7,56(sp)
 4c0:	f862                	sd	s8,48(sp)
 4c2:	f466                	sd	s9,40(sp)
 4c4:	f06a                	sd	s10,32(sp)
 4c6:	ec6e                	sd	s11,24(sp)
 4c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c903          	lbu	s2,0(a1)
 4ce:	18090f63          	beqz	s2,66c <vprintf+0x1c0>
 4d2:	8aaa                	mv	s5,a0
 4d4:	8b32                	mv	s6,a2
 4d6:	00158493          	addi	s1,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
      if(c == 'd'){
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4e4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4e8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ec:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f0:	00000b97          	auipc	s7,0x0
 4f4:	7b0b8b93          	addi	s7,s7,1968 # ca0 <digits>
 4f8:	a839                	j	516 <vprintf+0x6a>
        putc(fd, c);
 4fa:	85ca                	mv	a1,s2
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ee2080e7          	jalr	-286(ra) # 3e0 <putc>
 506:	a019                	j	50c <vprintf+0x60>
    } else if(state == '%'){
 508:	01498f63          	beq	s3,s4,526 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 50c:	0485                	addi	s1,s1,1
 50e:	fff4c903          	lbu	s2,-1(s1)
 512:	14090d63          	beqz	s2,66c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 516:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51a:	fe0997e3          	bnez	s3,508 <vprintf+0x5c>
      if(c == '%'){
 51e:	fd479ee3          	bne	a5,s4,4fa <vprintf+0x4e>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7e5                	j	50c <vprintf+0x60>
      if(c == 'd'){
 526:	05878063          	beq	a5,s8,566 <vprintf+0xba>
      } else if(c == 'l') {
 52a:	05978c63          	beq	a5,s9,582 <vprintf+0xd6>
      } else if(c == 'x') {
 52e:	07a78863          	beq	a5,s10,59e <vprintf+0xf2>
      } else if(c == 'p') {
 532:	09b78463          	beq	a5,s11,5ba <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 536:	07300713          	li	a4,115
 53a:	0ce78663          	beq	a5,a4,606 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53e:	06300713          	li	a4,99
 542:	0ee78e63          	beq	a5,a4,63e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 546:	11478863          	beq	a5,s4,656 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54a:	85d2                	mv	a1,s4
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e92080e7          	jalr	-366(ra) # 3e0 <putc>
        putc(fd, c);
 556:	85ca                	mv	a1,s2
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e86080e7          	jalr	-378(ra) # 3e0 <putc>
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b765                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 566:	008b0913          	addi	s2,s6,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000b2583          	lw	a1,0(s6)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e8e080e7          	jalr	-370(ra) # 402 <printint>
 57c:	8b4a                	mv	s6,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b771                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	008b0913          	addi	s2,s6,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000b2583          	lw	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e72080e7          	jalr	-398(ra) # 402 <printint>
 598:	8b4a                	mv	s6,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bf85                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 59e:	008b0913          	addi	s2,s6,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000b2583          	lw	a1,0(s6)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e56080e7          	jalr	-426(ra) # 402 <printint>
 5b4:	8b4a                	mv	s6,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bf91                	j	50c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ba:	008b0793          	addi	a5,s6,8
 5be:	f8f43423          	sd	a5,-120(s0)
 5c2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5c6:	03000593          	li	a1,48
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e14080e7          	jalr	-492(ra) # 3e0 <putc>
  putc(fd, 'x');
 5d4:	85ea                	mv	a1,s10
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e08080e7          	jalr	-504(ra) # 3e0 <putc>
 5e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	df2080e7          	jalr	-526(ra) # 3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	397d                	addiw	s2,s2,-1
 5fa:	fe0914e3          	bnez	s2,5e2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5fe:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 602:	4981                	li	s3,0
 604:	b721                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 606:	008b0993          	addi	s3,s6,8
 60a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 60e:	02090163          	beqz	s2,630 <vprintf+0x184>
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	c9a1                	beqz	a1,666 <vprintf+0x1ba>
          putc(fd, *s);
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dc6080e7          	jalr	-570(ra) # 3e0 <putc>
          s++;
 622:	0905                	addi	s2,s2,1
        while(*s != 0){
 624:	00094583          	lbu	a1,0(s2)
 628:	f9e5                	bnez	a1,618 <vprintf+0x16c>
        s = va_arg(ap, char*);
 62a:	8b4e                	mv	s6,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bdf9                	j	50c <vprintf+0x60>
          s = "(null)";
 630:	00000917          	auipc	s2,0x0
 634:	66890913          	addi	s2,s2,1640 # c98 <thread_assign_task+0xa2>
        while(*s != 0){
 638:	02800593          	li	a1,40
 63c:	bff1                	j	618 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 63e:	008b0913          	addi	s2,s6,8
 642:	000b4583          	lbu	a1,0(s6)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	d98080e7          	jalr	-616(ra) # 3e0 <putc>
 650:	8b4a                	mv	s6,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	bd65                	j	50c <vprintf+0x60>
        putc(fd, c);
 656:	85d2                	mv	a1,s4
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d86080e7          	jalr	-634(ra) # 3e0 <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	b565                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 666:	8b4e                	mv	s6,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	b54d                	j	50c <vprintf+0x60>
    }
  }
}
 66c:	70e6                	ld	ra,120(sp)
 66e:	7446                	ld	s0,112(sp)
 670:	74a6                	ld	s1,104(sp)
 672:	7906                	ld	s2,96(sp)
 674:	69e6                	ld	s3,88(sp)
 676:	6a46                	ld	s4,80(sp)
 678:	6aa6                	ld	s5,72(sp)
 67a:	6b06                	ld	s6,64(sp)
 67c:	7be2                	ld	s7,56(sp)
 67e:	7c42                	ld	s8,48(sp)
 680:	7ca2                	ld	s9,40(sp)
 682:	7d02                	ld	s10,32(sp)
 684:	6de2                	ld	s11,24(sp)
 686:	6109                	addi	sp,sp,128
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e04080e7          	jalr	-508(ra) # 4ac <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	00000097          	auipc	ra,0x0
 6e2:	dce080e7          	jalr	-562(ra) # 4ac <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	00000797          	auipc	a5,0x0
 6fc:	5d87b783          	ld	a5,1496(a5) # cd0 <freep>
 700:	a805                	j	730 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 702:	4618                	lw	a4,8(a2)
 704:	9db9                	addw	a1,a1,a4
 706:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	6398                	ld	a4,0(a5)
 70c:	6318                	ld	a4,0(a4)
 70e:	fee53823          	sd	a4,-16(a0)
 712:	a091                	j	756 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 714:	ff852703          	lw	a4,-8(a0)
 718:	9e39                	addw	a2,a2,a4
 71a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 71c:	ff053703          	ld	a4,-16(a0)
 720:	e398                	sd	a4,0(a5)
 722:	a099                	j	768 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x40>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x50>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x36>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059713          	slli	a4,a1,0x20
 748:	9301                	srli	a4,a4,0x20
 74a:	0712                	slli	a4,a4,0x4
 74c:	9736                	add	a4,a4,a3
 74e:	fae60ae3          	beq	a2,a4,702 <free+0x14>
    bp->s.ptr = p->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061713          	slli	a4,a2,0x20
 75c:	9301                	srli	a4,a4,0x20
 75e:	0712                	slli	a4,a4,0x4
 760:	973e                	add	a4,a4,a5
 762:	fae689e3          	beq	a3,a4,714 <free+0x26>
  } else
    p->s.ptr = bp;
 766:	e394                	sd	a3,0(a5)
  freep = p;
 768:	00000717          	auipc	a4,0x0
 76c:	56f73423          	sd	a5,1384(a4) # cd0 <freep>
}
 770:	6422                	ld	s0,8(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051493          	slli	s1,a0,0x20
 78e:	9081                	srli	s1,s1,0x20
 790:	04bd                	addi	s1,s1,15
 792:	8091                	srli	s1,s1,0x4
 794:	0014899b          	addiw	s3,s1,1
 798:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79a:	00000517          	auipc	a0,0x0
 79e:	53653503          	ld	a0,1334(a0) # cd0 <freep>
 7a2:	c515                	beqz	a0,7ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	02977f63          	bgeu	a4,s1,7e6 <malloc+0x70>
 7ac:	8a4e                	mv	s4,s3
 7ae:	0009871b          	sext.w	a4,s3
 7b2:	6685                	lui	a3,0x1
 7b4:	00d77363          	bgeu	a4,a3,7ba <malloc+0x44>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00000917          	auipc	s2,0x0
 7c6:	50e90913          	addi	s2,s2,1294 # cd0 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a88d                	j	83e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7ce:	00000797          	auipc	a5,0x0
 7d2:	51278793          	addi	a5,a5,1298 # ce0 <base>
 7d6:	00000717          	auipc	a4,0x0
 7da:	4ef73d23          	sd	a5,1274(a4) # cd0 <freep>
 7de:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e4:	b7e1                	j	7ac <malloc+0x36>
      if(p->s.size == nunits)
 7e6:	02e48b63          	beq	s1,a4,81c <malloc+0xa6>
        p->s.size -= nunits;
 7ea:	4137073b          	subw	a4,a4,s3
 7ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f0:	1702                	slli	a4,a4,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	0712                	slli	a4,a4,0x4
 7f6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fc:	00000717          	auipc	a4,0x0
 800:	4ca73a23          	sd	a0,1236(a4) # cd0 <freep>
      return (void*)(p + 1);
 804:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 808:	70e2                	ld	ra,56(sp)
 80a:	7442                	ld	s0,48(sp)
 80c:	74a2                	ld	s1,40(sp)
 80e:	7902                	ld	s2,32(sp)
 810:	69e2                	ld	s3,24(sp)
 812:	6a42                	ld	s4,16(sp)
 814:	6aa2                	ld	s5,8(sp)
 816:	6b02                	ld	s6,0(sp)
 818:	6121                	addi	sp,sp,64
 81a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	e118                	sd	a4,0(a0)
 820:	bff1                	j	7fc <malloc+0x86>
  hp->s.size = nu;
 822:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 826:	0541                	addi	a0,a0,16
 828:	00000097          	auipc	ra,0x0
 82c:	ec6080e7          	jalr	-314(ra) # 6ee <free>
  return freep;
 830:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 834:	d971                	beqz	a0,808 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	fa9776e3          	bgeu	a4,s1,7e6 <malloc+0x70>
    if(p == freep)
 83e:	00093703          	ld	a4,0(s2)
 842:	853e                	mv	a0,a5
 844:	fef719e3          	bne	a4,a5,836 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 848:	8552                	mv	a0,s4
 84a:	00000097          	auipc	ra,0x0
 84e:	b7e080e7          	jalr	-1154(ra) # 3c8 <sbrk>
  if(p == (char*)-1)
 852:	fd5518e3          	bne	a0,s5,822 <malloc+0xac>
        return 0;
 856:	4501                	li	a0,0
 858:	bf45                	j	808 <malloc+0x92>

000000000000085a <setjmp>:
 85a:	e100                	sd	s0,0(a0)
 85c:	e504                	sd	s1,8(a0)
 85e:	01253823          	sd	s2,16(a0)
 862:	01353c23          	sd	s3,24(a0)
 866:	03453023          	sd	s4,32(a0)
 86a:	03553423          	sd	s5,40(a0)
 86e:	03653823          	sd	s6,48(a0)
 872:	03753c23          	sd	s7,56(a0)
 876:	05853023          	sd	s8,64(a0)
 87a:	05953423          	sd	s9,72(a0)
 87e:	05a53823          	sd	s10,80(a0)
 882:	05b53c23          	sd	s11,88(a0)
 886:	06153023          	sd	ra,96(a0)
 88a:	06253423          	sd	sp,104(a0)
 88e:	4501                	li	a0,0
 890:	8082                	ret

0000000000000892 <longjmp>:
 892:	6100                	ld	s0,0(a0)
 894:	6504                	ld	s1,8(a0)
 896:	01053903          	ld	s2,16(a0)
 89a:	01853983          	ld	s3,24(a0)
 89e:	02053a03          	ld	s4,32(a0)
 8a2:	02853a83          	ld	s5,40(a0)
 8a6:	03053b03          	ld	s6,48(a0)
 8aa:	03853b83          	ld	s7,56(a0)
 8ae:	04053c03          	ld	s8,64(a0)
 8b2:	04853c83          	ld	s9,72(a0)
 8b6:	05053d03          	ld	s10,80(a0)
 8ba:	05853d83          	ld	s11,88(a0)
 8be:	06053083          	ld	ra,96(a0)
 8c2:	06853103          	ld	sp,104(a0)
 8c6:	c199                	beqz	a1,8cc <longjmp_1>
 8c8:	852e                	mv	a0,a1
 8ca:	8082                	ret

00000000000008cc <longjmp_1>:
 8cc:	4505                	li	a0,1
 8ce:	8082                	ret

00000000000008d0 <thread_create>:
static int id = 1;
static int tid = 1;
static jmp_buf env_st;
static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
 8d0:	7179                	addi	sp,sp,-48
 8d2:	f406                	sd	ra,40(sp)
 8d4:	f022                	sd	s0,32(sp)
 8d6:	ec26                	sd	s1,24(sp)
 8d8:	e84a                	sd	s2,16(sp)
 8da:	e44e                	sd	s3,8(sp)
 8dc:	1800                	addi	s0,sp,48
 8de:	89aa                	mv	s3,a0
 8e0:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
 8e2:	0b000513          	li	a0,176
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e90080e7          	jalr	-368(ra) # 776 <malloc>
 8ee:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
 8f0:	6505                	lui	a0,0x1
 8f2:	80050513          	addi	a0,a0,-2048 # 800 <malloc+0x8a>
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e80080e7          	jalr	-384(ra) # 776 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
 8fe:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
 902:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
 906:	00000717          	auipc	a4,0x0
 90a:	3b270713          	addi	a4,a4,946 # cb8 <id>
 90e:	431c                	lw	a5,0(a4)
 910:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
 914:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack;
 918:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
 91a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
 91e:	ec88                	sd	a0,24(s1)
    id++;
 920:	2785                	addiw	a5,a5,1
 922:	c31c                	sw	a5,0(a4)

    // part 2
    t->current_task = NULL;
 924:	0a04b423          	sd	zero,168(s1)
    return t;
}
 928:	8526                	mv	a0,s1
 92a:	70a2                	ld	ra,40(sp)
 92c:	7402                	ld	s0,32(sp)
 92e:	64e2                	ld	s1,24(sp)
 930:	6942                	ld	s2,16(sp)
 932:	69a2                	ld	s3,8(sp)
 934:	6145                	addi	sp,sp,48
 936:	8082                	ret

0000000000000938 <thread_add_runqueue>:

void thread_add_runqueue(struct thread *t){
 938:	1141                	addi	sp,sp,-16
 93a:	e422                	sd	s0,8(sp)
 93c:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
 93e:	00000797          	auipc	a5,0x0
 942:	39a7b783          	ld	a5,922(a5) # cd8 <current_thread>
 946:	cb91                	beqz	a5,95a <thread_add_runqueue+0x22>
        t->next = t;
        current_thread = t;
    }
    else{
        // TODO
        t->previous = current_thread->previous;
 948:	6fd8                	ld	a4,152(a5)
 94a:	ed58                	sd	a4,152(a0)
        t->next = current_thread;
 94c:	f15c                	sd	a5,160(a0)
        current_thread->previous->next = t;
 94e:	6fd8                	ld	a4,152(a5)
 950:	f348                	sd	a0,160(a4)
        current_thread->previous = t;
 952:	efc8                	sd	a0,152(a5)
    }
}
 954:	6422                	ld	s0,8(sp)
 956:	0141                	addi	sp,sp,16
 958:	8082                	ret
        t->previous = t;
 95a:	ed48                	sd	a0,152(a0)
        t->next = t;
 95c:	f148                	sd	a0,160(a0)
        current_thread = t;
 95e:	00000797          	auipc	a5,0x0
 962:	36a7bd23          	sd	a0,890(a5) # cd8 <current_thread>
 966:	b7fd                	j	954 <thread_add_runqueue+0x1c>

0000000000000968 <schedule>:
    }else{
        longjmp(current_thread->env, 1);
    }
}

void schedule(void){
 968:	1141                	addi	sp,sp,-16
 96a:	e422                	sd	s0,8(sp)
 96c:	0800                	addi	s0,sp,16
    // TODO
    current_thread = current_thread->next;
 96e:	00000797          	auipc	a5,0x0
 972:	36a78793          	addi	a5,a5,874 # cd8 <current_thread>
 976:	6398                	ld	a4,0(a5)
 978:	7358                	ld	a4,160(a4)
 97a:	e398                	sd	a4,0(a5)
}
 97c:	6422                	ld	s0,8(sp)
 97e:	0141                	addi	sp,sp,16
 980:	8082                	ret

0000000000000982 <free_thread_resource>:

void free_thread_resource(struct thread *t){
 982:	1101                	addi	sp,sp,-32
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	e426                	sd	s1,8(sp)
 98a:	1000                	addi	s0,sp,32
 98c:	84aa                	mv	s1,a0
    t->previous->next = t->next;
 98e:	6d58                	ld	a4,152(a0)
 990:	715c                	ld	a5,160(a0)
 992:	f35c                	sd	a5,160(a4)
    t->next->previous = t->previous;
 994:	6d58                	ld	a4,152(a0)
 996:	efd8                	sd	a4,152(a5)
    
    struct threadtask *task = t->current_task;
 998:	7548                	ld	a0,168(a0)
    while (task != NULL){
 99a:	c909                	beqz	a0,9ac <free_thread_resource+0x2a>
        t->current_task = task->next;
 99c:	695c                	ld	a5,144(a0)
 99e:	f4dc                	sd	a5,168(s1)
        free(task);
 9a0:	00000097          	auipc	ra,0x0
 9a4:	d4e080e7          	jalr	-690(ra) # 6ee <free>
        task = t->current_task;
 9a8:	74c8                	ld	a0,168(s1)
    while (task != NULL){
 9aa:	f96d                	bnez	a0,99c <free_thread_resource+0x1a>
    }

    free(t->stack);
 9ac:	6888                	ld	a0,16(s1)
 9ae:	00000097          	auipc	ra,0x0
 9b2:	d40080e7          	jalr	-704(ra) # 6ee <free>
    free(t);
 9b6:	8526                	mv	a0,s1
 9b8:	00000097          	auipc	ra,0x0
 9bc:	d36080e7          	jalr	-714(ra) # 6ee <free>
}
 9c0:	60e2                	ld	ra,24(sp)
 9c2:	6442                	ld	s0,16(sp)
 9c4:	64a2                	ld	s1,8(sp)
 9c6:	6105                	addi	sp,sp,32
 9c8:	8082                	ret

00000000000009ca <thread_exit>:

void thread_exit(void){
 9ca:	1101                	addi	sp,sp,-32
 9cc:	ec06                	sd	ra,24(sp)
 9ce:	e822                	sd	s0,16(sp)
 9d0:	e426                	sd	s1,8(sp)
 9d2:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
 9d4:	00000497          	auipc	s1,0x0
 9d8:	3044b483          	ld	s1,772(s1) # cd8 <current_thread>
 9dc:	70dc                	ld	a5,160(s1)
 9de:	02f48463          	beq	s1,a5,a06 <thread_exit+0x3c>
        // TODO
        struct thread *tmp = current_thread;
        schedule();
 9e2:	00000097          	auipc	ra,0x0
 9e6:	f86080e7          	jalr	-122(ra) # 968 <schedule>
        free_thread_resource(tmp);
 9ea:	8526                	mv	a0,s1
 9ec:	00000097          	auipc	ra,0x0
 9f0:	f96080e7          	jalr	-106(ra) # 982 <free_thread_resource>
        dispatch();
 9f4:	00000097          	auipc	ra,0x0
 9f8:	030080e7          	jalr	48(ra) # a24 <dispatch>
        // TODO
        // Hint: No more thread to execute
        free_thread_resource(current_thread);
        longjmp(env_st, 1);
    }
}
 9fc:	60e2                	ld	ra,24(sp)
 9fe:	6442                	ld	s0,16(sp)
 a00:	64a2                	ld	s1,8(sp)
 a02:	6105                	addi	sp,sp,32
 a04:	8082                	ret
        free_thread_resource(current_thread);
 a06:	8526                	mv	a0,s1
 a08:	00000097          	auipc	ra,0x0
 a0c:	f7a080e7          	jalr	-134(ra) # 982 <free_thread_resource>
        longjmp(env_st, 1);
 a10:	4585                	li	a1,1
 a12:	00000517          	auipc	a0,0x0
 a16:	2de50513          	addi	a0,a0,734 # cf0 <env_st>
 a1a:	00000097          	auipc	ra,0x0
 a1e:	e78080e7          	jalr	-392(ra) # 892 <longjmp>
}
 a22:	bfe9                	j	9fc <thread_exit+0x32>

0000000000000a24 <dispatch>:
void dispatch(void){
 a24:	1101                	addi	sp,sp,-32
 a26:	ec06                	sd	ra,24(sp)
 a28:	e822                	sd	s0,16(sp)
 a2a:	e426                	sd	s1,8(sp)
 a2c:	e04a                	sd	s2,0(sp)
 a2e:	1000                	addi	s0,sp,32
    while (current_thread->current_task != NULL){
 a30:	a82d                	j	a6a <dispatch+0x46>
                struct threadtask *task_prev = current_thread->current_task->next;
 a32:	00000797          	auipc	a5,0x0
 a36:	2a678793          	addi	a5,a5,678 # cd8 <current_thread>
 a3a:	6394                	ld	a3,0(a5)
 a3c:	76dc                	ld	a5,168(a3)
 a3e:	6bdc                	ld	a5,144(a5)
                while (task_prev != NULL && !task_prev->buf_set){
 a40:	c799                	beqz	a5,a4e <dispatch+0x2a>
 a42:	0807a703          	lw	a4,128(a5)
 a46:	10071063          	bnez	a4,b46 <dispatch+0x122>
                    task_prev = task_prev->next;
 a4a:	6bdc                	ld	a5,144(a5)
                while (task_prev != NULL && !task_prev->buf_set){
 a4c:	fbfd                	bnez	a5,a42 <dispatch+0x1e>
                env_tmp->sp = (task_prev != NULL)? task_prev->env->sp : (!current_thread->buf_set)? (unsigned long) current_thread->stack_p : current_thread->env->sp;
 a4e:	0906a783          	lw	a5,144(a3) # 1090 <__BSS_END__+0x2c0>
 a52:	c399                	beqz	a5,a58 <dispatch+0x34>
 a54:	66dc                	ld	a5,136(a3)
 a56:	a8cd                	j	b48 <dispatch+0x124>
 a58:	6e9c                	ld	a5,24(a3)
 a5a:	a0fd                	j	b48 <dispatch+0x124>
                current_thread->current_task = task->next;
 a5c:	68d8                	ld	a4,144(s1)
 a5e:	f7d8                	sd	a4,168(a5)
            free(task);
 a60:	8526                	mv	a0,s1
 a62:	00000097          	auipc	ra,0x0
 a66:	c8c080e7          	jalr	-884(ra) # 6ee <free>
    while (current_thread->current_task != NULL){
 a6a:	00000797          	auipc	a5,0x0
 a6e:	26e78793          	addi	a5,a5,622 # cd8 <current_thread>
 a72:	639c                	ld	a5,0(a5)
 a74:	77c8                	ld	a0,168(a5)
 a76:	cd29                	beqz	a0,ad0 <dispatch+0xac>
        if (!current_thread->current_task->buf_set){
 a78:	08052783          	lw	a5,128(a0)
 a7c:	e3b9                	bnez	a5,ac2 <dispatch+0x9e>
            if (!setjmp(env_tmp)){
 a7e:	00000517          	auipc	a0,0x0
 a82:	2e250513          	addi	a0,a0,738 # d60 <env_tmp>
 a86:	00000097          	auipc	ra,0x0
 a8a:	dd4080e7          	jalr	-556(ra) # 85a <setjmp>
 a8e:	d155                	beqz	a0,a32 <dispatch+0xe>
            struct threadtask *task = current_thread->current_task;
 a90:	00000917          	auipc	s2,0x0
 a94:	24890913          	addi	s2,s2,584 # cd8 <current_thread>
 a98:	00093783          	ld	a5,0(s2)
 a9c:	77c4                	ld	s1,168(a5)
            task->buf_set = 1;
 a9e:	4785                	li	a5,1
 aa0:	08f4a023          	sw	a5,128(s1)
            task->fp(task->arg);
 aa4:	609c                	ld	a5,0(s1)
 aa6:	6488                	ld	a0,8(s1)
 aa8:	9782                	jalr	a5
            if (current_thread->current_task == task){
 aaa:	00093783          	ld	a5,0(s2)
 aae:	77d8                	ld	a4,168(a5)
 ab0:	fa9706e3          	beq	a4,s1,a5c <dispatch+0x38>
                task->previous->next = task->next;
 ab4:	64d8                	ld	a4,136(s1)
 ab6:	68dc                	ld	a5,144(s1)
 ab8:	eb5c                	sd	a5,144(a4)
                if (task->next != NULL){
 aba:	d3dd                	beqz	a5,a60 <dispatch+0x3c>
                    task->next->previous = task->previous;
 abc:	64d8                	ld	a4,136(s1)
 abe:	e7d8                	sd	a4,136(a5)
 ac0:	b745                	j	a60 <dispatch+0x3c>
            longjmp(current_thread->current_task->env, 1);
 ac2:	4585                	li	a1,1
 ac4:	0541                	addi	a0,a0,16
 ac6:	00000097          	auipc	ra,0x0
 aca:	dcc080e7          	jalr	-564(ra) # 892 <longjmp>
 ace:	bf71                	j	a6a <dispatch+0x46>
    if (!current_thread->buf_set){
 ad0:	0907a703          	lw	a4,144(a5)
 ad4:	e32d                	bnez	a4,b36 <dispatch+0x112>
        if (!setjmp(env_tmp)){
 ad6:	00000517          	auipc	a0,0x0
 ada:	28a50513          	addi	a0,a0,650 # d60 <env_tmp>
 ade:	00000097          	auipc	ra,0x0
 ae2:	d7c080e7          	jalr	-644(ra) # 85a <setjmp>
 ae6:	c50d                	beqz	a0,b10 <dispatch+0xec>
        current_thread->buf_set = 1;
 ae8:	00000797          	auipc	a5,0x0
 aec:	1f07b783          	ld	a5,496(a5) # cd8 <current_thread>
 af0:	4705                	li	a4,1
 af2:	08e7a823          	sw	a4,144(a5)
        current_thread->fp(current_thread->arg);
 af6:	6398                	ld	a4,0(a5)
 af8:	6788                	ld	a0,8(a5)
 afa:	9702                	jalr	a4
        thread_exit();
 afc:	00000097          	auipc	ra,0x0
 b00:	ece080e7          	jalr	-306(ra) # 9ca <thread_exit>
}
 b04:	60e2                	ld	ra,24(sp)
 b06:	6442                	ld	s0,16(sp)
 b08:	64a2                	ld	s1,8(sp)
 b0a:	6902                	ld	s2,0(sp)
 b0c:	6105                	addi	sp,sp,32
 b0e:	8082                	ret
            env_tmp->sp = (unsigned long) current_thread->stack_p;
 b10:	00000797          	auipc	a5,0x0
 b14:	1c87b783          	ld	a5,456(a5) # cd8 <current_thread>
 b18:	6f9c                	ld	a5,24(a5)
 b1a:	00000717          	auipc	a4,0x0
 b1e:	2af73723          	sd	a5,686(a4) # dc8 <env_tmp+0x68>
            longjmp(env_tmp, 1);
 b22:	4585                	li	a1,1
 b24:	00000517          	auipc	a0,0x0
 b28:	23c50513          	addi	a0,a0,572 # d60 <env_tmp>
 b2c:	00000097          	auipc	ra,0x0
 b30:	d66080e7          	jalr	-666(ra) # 892 <longjmp>
 b34:	bf55                	j	ae8 <dispatch+0xc4>
        longjmp(current_thread->env, 1);
 b36:	4585                	li	a1,1
 b38:	02078513          	addi	a0,a5,32
 b3c:	00000097          	auipc	ra,0x0
 b40:	d56080e7          	jalr	-682(ra) # 892 <longjmp>
}
 b44:	b7c1                	j	b04 <dispatch+0xe0>
                env_tmp->sp = (task_prev != NULL)? task_prev->env->sp : (!current_thread->buf_set)? (unsigned long) current_thread->stack_p : current_thread->env->sp;
 b46:	7fbc                	ld	a5,120(a5)
 b48:	00000717          	auipc	a4,0x0
 b4c:	1a870713          	addi	a4,a4,424 # cf0 <env_st>
 b50:	ef7c                	sd	a5,216(a4)
                longjmp(env_tmp, 1);
 b52:	4585                	li	a1,1
 b54:	00000517          	auipc	a0,0x0
 b58:	20c50513          	addi	a0,a0,524 # d60 <env_tmp>
 b5c:	00000097          	auipc	ra,0x0
 b60:	d36080e7          	jalr	-714(ra) # 892 <longjmp>
 b64:	b735                	j	a90 <dispatch+0x6c>

0000000000000b66 <thread_yield>:
void thread_yield(void){
 b66:	1141                	addi	sp,sp,-16
 b68:	e406                	sd	ra,8(sp)
 b6a:	e022                	sd	s0,0(sp)
 b6c:	0800                	addi	s0,sp,16
    struct threadtask *task = current_thread->current_task;
 b6e:	00000717          	auipc	a4,0x0
 b72:	16a73703          	ld	a4,362(a4) # cd8 <current_thread>
 b76:	7748                	ld	a0,168(a4)
    while (task != NULL && !task->buf_set){
 b78:	c511                	beqz	a0,b84 <thread_yield+0x1e>
 b7a:	08052783          	lw	a5,128(a0)
 b7e:	ef85                	bnez	a5,bb6 <thread_yield+0x50>
        task = task->next;
 b80:	6948                	ld	a0,144(a0)
    while (task != NULL && !task->buf_set){
 b82:	fd65                	bnez	a0,b7a <thread_yield+0x14>
        if (!setjmp(current_thread->env)){
 b84:	02070513          	addi	a0,a4,32
 b88:	00000097          	auipc	ra,0x0
 b8c:	cd2080e7          	jalr	-814(ra) # 85a <setjmp>
 b90:	e90d                	bnez	a0,bc2 <thread_yield+0x5c>
            schedule();
 b92:	00000097          	auipc	ra,0x0
 b96:	dd6080e7          	jalr	-554(ra) # 968 <schedule>
            dispatch();
 b9a:	00000097          	auipc	ra,0x0
 b9e:	e8a080e7          	jalr	-374(ra) # a24 <dispatch>
}
 ba2:	a005                	j	bc2 <thread_yield+0x5c>
            schedule();
 ba4:	00000097          	auipc	ra,0x0
 ba8:	dc4080e7          	jalr	-572(ra) # 968 <schedule>
            dispatch();
 bac:	00000097          	auipc	ra,0x0
 bb0:	e78080e7          	jalr	-392(ra) # a24 <dispatch>
 bb4:	a039                	j	bc2 <thread_yield+0x5c>
        if (!setjmp(task->env)){
 bb6:	0541                	addi	a0,a0,16
 bb8:	00000097          	auipc	ra,0x0
 bbc:	ca2080e7          	jalr	-862(ra) # 85a <setjmp>
 bc0:	d175                	beqz	a0,ba4 <thread_yield+0x3e>
}
 bc2:	60a2                	ld	ra,8(sp)
 bc4:	6402                	ld	s0,0(sp)
 bc6:	0141                	addi	sp,sp,16
 bc8:	8082                	ret

0000000000000bca <thread_start_threading>:
void thread_start_threading(void){
 bca:	1141                	addi	sp,sp,-16
 bcc:	e406                	sd	ra,8(sp)
 bce:	e022                	sd	s0,0(sp)
 bd0:	0800                	addi	s0,sp,16
    // TODO
    if (!setjmp(env_st)){
 bd2:	00000517          	auipc	a0,0x0
 bd6:	11e50513          	addi	a0,a0,286 # cf0 <env_st>
 bda:	00000097          	auipc	ra,0x0
 bde:	c80080e7          	jalr	-896(ra) # 85a <setjmp>
 be2:	c509                	beqz	a0,bec <thread_start_threading+0x22>
        dispatch();
    }
    return;
}
 be4:	60a2                	ld	ra,8(sp)
 be6:	6402                	ld	s0,0(sp)
 be8:	0141                	addi	sp,sp,16
 bea:	8082                	ret
        dispatch();
 bec:	00000097          	auipc	ra,0x0
 bf0:	e38080e7          	jalr	-456(ra) # a24 <dispatch>
    return;
 bf4:	bfc5                	j	be4 <thread_start_threading+0x1a>

0000000000000bf6 <thread_assign_task>:
// part 2

void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 bf6:	7179                	addi	sp,sp,-48
 bf8:	f406                	sd	ra,40(sp)
 bfa:	f022                	sd	s0,32(sp)
 bfc:	ec26                	sd	s1,24(sp)
 bfe:	e84a                	sd	s2,16(sp)
 c00:	e44e                	sd	s3,8(sp)
 c02:	1800                	addi	s0,sp,48
 c04:	84aa                	mv	s1,a0
 c06:	89ae                	mv	s3,a1
 c08:	8932                	mv	s2,a2
    // TODO
    struct threadtask *task = (struct threadtask*) malloc(sizeof(struct threadtask));
 c0a:	09800513          	li	a0,152
 c0e:	00000097          	auipc	ra,0x0
 c12:	b68080e7          	jalr	-1176(ra) # 776 <malloc>
    task->fp = f;
 c16:	01353023          	sd	s3,0(a0)
    task->arg = arg;
 c1a:	01253423          	sd	s2,8(a0)
    task->buf_set = 0;
 c1e:	08052023          	sw	zero,128(a0)
    task->ID = tid;
 c22:	00000797          	auipc	a5,0x0
 c26:	0927a783          	lw	a5,146(a5) # cb4 <tid>
 c2a:	08f52223          	sw	a5,132(a0)
    task->next = t->current_task;
 c2e:	74d8                	ld	a4,168(s1)
 c30:	e958                	sd	a4,144(a0)
    task->previous = NULL;
 c32:	08053423          	sd	zero,136(a0)
    if (t->current_task != NULL){
 c36:	74d8                	ld	a4,168(s1)
 c38:	c311                	beqz	a4,c3c <thread_assign_task+0x46>
        t->current_task->previous = task;
 c3a:	e748                	sd	a0,136(a4)
    }
    t->current_task = task;
 c3c:	f4c8                	sd	a0,168(s1)
    tid++;
 c3e:	2785                	addiw	a5,a5,1
 c40:	00000717          	auipc	a4,0x0
 c44:	06f72a23          	sw	a5,116(a4) # cb4 <tid>
}
 c48:	70a2                	ld	ra,40(sp)
 c4a:	7402                	ld	s0,32(sp)
 c4c:	64e2                	ld	s1,24(sp)
 c4e:	6942                	ld	s2,16(sp)
 c50:	69a2                	ld	s3,8(sp)
 c52:	6145                	addi	sp,sp,48
 c54:	8082                	ret
