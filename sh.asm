
_sh:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
  return 0;
}

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    1009:	eb 0e                	jmp    1019 <main+0x19>
    100b:	90                   	nop
    100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
    1010:	83 f8 02             	cmp    $0x2,%eax
    1013:	0f 8f cd 00 00 00    	jg     10e6 <main+0xe6>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    1019:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1020:	00 
    1021:	c7 04 24 9e 23 00 00 	movl   $0x239e,(%esp)
    1028:	e8 05 0e 00 00       	call   1e32 <open>
    102d:	85 c0                	test   %eax,%eax
    102f:	79 df                	jns    1010 <main+0x10>
    1031:	eb 23                	jmp    1056 <main+0x56>
    1033:	90                   	nop
    1034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    1038:	80 3d e2 29 00 00 20 	cmpb   $0x20,0x29e2
    103f:	90                   	nop
    1040:	74 60                	je     10a2 <main+0xa2>
    1042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
    1048:	e8 43 01 00 00       	call   1190 <fork1>
    104d:	85 c0                	test   %eax,%eax
    104f:	74 38                	je     1089 <main+0x89>
      runcmd(parsecmd(buf));
    wait();
    1051:	e8 a4 0d 00 00       	call   1dfa <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1056:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
    105d:	00 
    105e:	c7 04 24 e0 29 00 00 	movl   $0x29e0,(%esp)
    1065:	e8 96 00 00 00       	call   1100 <getcmd>
    106a:	85 c0                	test   %eax,%eax
    106c:	78 2f                	js     109d <main+0x9d>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    106e:	80 3d e0 29 00 00 63 	cmpb   $0x63,0x29e0
    1075:	75 d1                	jne    1048 <main+0x48>
    1077:	80 3d e1 29 00 00 64 	cmpb   $0x64,0x29e1
    107e:	74 b8                	je     1038 <main+0x38>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
    1080:	e8 0b 01 00 00       	call   1190 <fork1>
    1085:	85 c0                	test   %eax,%eax
    1087:	75 c8                	jne    1051 <main+0x51>
      runcmd(parsecmd(buf));
    1089:	c7 04 24 e0 29 00 00 	movl   $0x29e0,(%esp)
    1090:	e8 bb 0a 00 00       	call   1b50 <parsecmd>
    1095:	89 04 24             	mov    %eax,(%esp)
    1098:	e8 13 01 00 00       	call   11b0 <runcmd>
    wait();
  }
  exit();
    109d:	e8 50 0d 00 00       	call   1df2 <exit>

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    10a2:	c7 04 24 e0 29 00 00 	movl   $0x29e0,(%esp)
    10a9:	e8 a2 0b 00 00       	call   1c50 <strlen>
      if(chdir(buf+3) < 0)
    10ae:	c7 04 24 e3 29 00 00 	movl   $0x29e3,(%esp)

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    10b5:	c6 80 df 29 00 00 00 	movb   $0x0,0x29df(%eax)
      if(chdir(buf+3) < 0)
    10bc:	e8 a1 0d 00 00       	call   1e62 <chdir>
    10c1:	85 c0                	test   %eax,%eax
    10c3:	79 91                	jns    1056 <main+0x56>
        printf(2, "cannot cd %s\n", buf+3);
    10c5:	c7 44 24 08 e3 29 00 	movl   $0x29e3,0x8(%esp)
    10cc:	00 
    10cd:	c7 44 24 04 a6 23 00 	movl   $0x23a6,0x4(%esp)
    10d4:	00 
    10d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10dc:	e8 6f 0e 00 00       	call   1f50 <printf>
    10e1:	e9 70 ff ff ff       	jmp    1056 <main+0x56>
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
    10e6:	89 04 24             	mov    %eax,(%esp)
    10e9:	e8 2c 0d 00 00       	call   1e1a <close>
    10ee:	66 90                	xchg   %ax,%ax
      break;
    10f0:	e9 61 ff ff ff       	jmp    1056 <main+0x56>
    10f5:	66 90                	xchg   %ax,%ax
    10f7:	66 90                	xchg   %ax,%ax
    10f9:	66 90                	xchg   %ax,%ax
    10fb:	66 90                	xchg   %ax,%ax
    10fd:	66 90                	xchg   %ax,%ax
    10ff:	90                   	nop

00001100 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	56                   	push   %esi
    1104:	53                   	push   %ebx
    1105:	83 ec 10             	sub    $0x10,%esp
    1108:	8b 5d 08             	mov    0x8(%ebp),%ebx
    110b:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
    110e:	c7 44 24 04 f4 22 00 	movl   $0x22f4,0x4(%esp)
    1115:	00 
    1116:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    111d:	e8 2e 0e 00 00       	call   1f50 <printf>
  memset(buf, 0, nbuf);
    1122:	89 74 24 08          	mov    %esi,0x8(%esp)
    1126:	89 1c 24             	mov    %ebx,(%esp)
    1129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1130:	00 
    1131:	e8 4a 0b 00 00       	call   1c80 <memset>
  gets(buf, nbuf);
    1136:	89 74 24 04          	mov    %esi,0x4(%esp)
    113a:	89 1c 24             	mov    %ebx,(%esp)
    113d:	e8 9e 0b 00 00       	call   1ce0 <gets>
  if(buf[0] == 0) // EOF
    1142:	31 c0                	xor    %eax,%eax
    1144:	80 3b 00             	cmpb   $0x0,(%ebx)
    1147:	0f 94 c0             	sete   %al
    return -1;
  return 0;
}
    114a:	83 c4 10             	add    $0x10,%esp
    114d:	5b                   	pop    %ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    114e:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
    1150:	5e                   	pop    %esi
    1151:	5d                   	pop    %ebp
    1152:	c3                   	ret    
    1153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001160 <panic>:
  exit();
}

void
panic(char *s)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
    1166:	8b 45 08             	mov    0x8(%ebp),%eax
    1169:	c7 44 24 04 9a 23 00 	movl   $0x239a,0x4(%esp)
    1170:	00 
    1171:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1178:	89 44 24 08          	mov    %eax,0x8(%esp)
    117c:	e8 cf 0d 00 00       	call   1f50 <printf>
  exit();
    1181:	e8 6c 0c 00 00       	call   1df2 <exit>
    1186:	8d 76 00             	lea    0x0(%esi),%esi
    1189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001190 <fork1>:
}

int
fork1(void)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
    1196:	e8 4f 0c 00 00       	call   1dea <fork>
  if(pid == -1)
    119b:	83 f8 ff             	cmp    $0xffffffff,%eax
    119e:	74 02                	je     11a2 <fork1+0x12>
    panic("fork");
  return pid;
}
    11a0:	c9                   	leave  
    11a1:	c3                   	ret    
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
    11a2:	c7 04 24 f7 22 00 00 	movl   $0x22f7,(%esp)
    11a9:	e8 b2 ff ff ff       	call   1160 <panic>
    11ae:	66 90                	xchg   %ax,%ax

000011b0 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	53                   	push   %ebx
    11b4:	83 ec 24             	sub    $0x24,%esp
    11b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
	printf(1, "cmd: %d\n", cmd);
    11ba:	c7 44 24 04 fc 22 00 	movl   $0x22fc,0x4(%esp)
    11c1:	00 
    11c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    11cd:	e8 7e 0d 00 00       	call   1f50 <printf>
  if(cmd == 0)
    11d2:	85 db                	test   %ebx,%ebx
    11d4:	74 60                	je     1236 <runcmd+0x86>
    exit();

  switch(cmd->type){
    11d6:	83 3b 05             	cmpl   $0x5,(%ebx)
    11d9:	0f 87 e4 00 00 00    	ja     12c3 <runcmd+0x113>
    11df:	8b 03                	mov    (%ebx),%eax
    11e1:	ff 24 85 b4 23 00 00 	jmp    *0x23b4(,%eax,4)
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
    11e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
    11eb:	89 04 24             	mov    %eax,(%esp)
    11ee:	e8 0f 0c 00 00       	call   1e02 <pipe>
    11f3:	85 c0                	test   %eax,%eax
    11f5:	0f 88 d4 00 00 00    	js     12cf <runcmd+0x11f>
      panic("pipe");
    if(fork1() == 0){
    11fb:	e8 90 ff ff ff       	call   1190 <fork1>
    1200:	85 c0                	test   %eax,%eax
    1202:	0f 84 2b 01 00 00    	je     1333 <runcmd+0x183>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
    1208:	e8 83 ff ff ff       	call   1190 <fork1>
    120d:	85 c0                	test   %eax,%eax
    120f:	90                   	nop
    1210:	0f 84 e5 00 00 00    	je     12fb <runcmd+0x14b>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    1216:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1219:	89 04 24             	mov    %eax,(%esp)
    121c:	e8 f9 0b 00 00       	call   1e1a <close>
    close(p[1]);
    1221:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1224:	89 04 24             	mov    %eax,(%esp)
    1227:	e8 ee 0b 00 00       	call   1e1a <close>
    wait();
    122c:	e8 c9 0b 00 00       	call   1dfa <wait>
    wait();
    1231:	e8 c4 0b 00 00       	call   1dfa <wait>
  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
      exit();
    1236:	e8 b7 0b 00 00       	call   1df2 <exit>
    123b:	90                   	nop
    123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
    1240:	e8 4b ff ff ff       	call   1190 <fork1>
    1245:	85 c0                	test   %eax,%eax
    1247:	75 ed                	jne    1236 <runcmd+0x86>
    1249:	eb 6d                	jmp    12b8 <runcmd+0x108>
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
    124b:	8b 43 04             	mov    0x4(%ebx),%eax
    124e:	85 c0                	test   %eax,%eax
    1250:	74 e4                	je     1236 <runcmd+0x86>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
    1252:	8d 53 04             	lea    0x4(%ebx),%edx
    1255:	89 54 24 04          	mov    %edx,0x4(%esp)
    1259:	89 04 24             	mov    %eax,(%esp)
    125c:	e8 c9 0b 00 00       	call   1e2a <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    1261:	8b 43 04             	mov    0x4(%ebx),%eax
    1264:	c7 44 24 04 0c 23 00 	movl   $0x230c,0x4(%esp)
    126b:	00 
    126c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1273:	89 44 24 08          	mov    %eax,0x8(%esp)
    1277:	e8 d4 0c 00 00       	call   1f50 <printf>
    break;
    127c:	eb b8                	jmp    1236 <runcmd+0x86>
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
    127e:	e8 0d ff ff ff       	call   1190 <fork1>
    1283:	85 c0                	test   %eax,%eax
    1285:	74 31                	je     12b8 <runcmd+0x108>
      runcmd(lcmd->left);
    wait();
    1287:	e8 6e 0b 00 00       	call   1dfa <wait>
    runcmd(lcmd->right);
    128c:	8b 43 08             	mov    0x8(%ebx),%eax
    128f:	89 04 24             	mov    %eax,(%esp)
    1292:	e8 19 ff ff ff       	call   11b0 <runcmd>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    1297:	8b 43 14             	mov    0x14(%ebx),%eax
    129a:	89 04 24             	mov    %eax,(%esp)
    129d:	e8 78 0b 00 00       	call   1e1a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    12a2:	8b 43 10             	mov    0x10(%ebx),%eax
    12a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12a9:	8b 43 08             	mov    0x8(%ebx),%eax
    12ac:	89 04 24             	mov    %eax,(%esp)
    12af:	e8 7e 0b 00 00       	call   1e32 <open>
    12b4:	85 c0                	test   %eax,%eax
    12b6:	78 23                	js     12db <runcmd+0x12b>
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    12b8:	8b 43 04             	mov    0x4(%ebx),%eax
    12bb:	89 04 24             	mov    %eax,(%esp)
    12be:	e8 ed fe ff ff       	call   11b0 <runcmd>
  if(cmd == 0)
    exit();

  switch(cmd->type){
  default:
    panic("runcmd");
    12c3:	c7 04 24 05 23 00 00 	movl   $0x2305,(%esp)
    12ca:	e8 91 fe ff ff       	call   1160 <panic>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    12cf:	c7 04 24 2c 23 00 00 	movl   $0x232c,(%esp)
    12d6:	e8 85 fe ff ff       	call   1160 <panic>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
    12db:	8b 43 08             	mov    0x8(%ebx),%eax
    12de:	c7 44 24 04 1c 23 00 	movl   $0x231c,0x4(%esp)
    12e5:	00 
    12e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    12ed:	89 44 24 08          	mov    %eax,0x8(%esp)
    12f1:	e8 5a 0c 00 00       	call   1f50 <printf>
    12f6:	e9 3b ff ff ff       	jmp    1236 <runcmd+0x86>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
    12fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1302:	e8 13 0b 00 00       	call   1e1a <close>
      dup(p[0]);
    1307:	8b 45 f0             	mov    -0x10(%ebp),%eax
    130a:	89 04 24             	mov    %eax,(%esp)
    130d:	e8 58 0b 00 00       	call   1e6a <dup>
      close(p[0]);
    1312:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1315:	89 04 24             	mov    %eax,(%esp)
    1318:	e8 fd 0a 00 00       	call   1e1a <close>
      close(p[1]);
    131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1320:	89 04 24             	mov    %eax,(%esp)
    1323:	e8 f2 0a 00 00       	call   1e1a <close>
      runcmd(pcmd->right);
    1328:	8b 43 08             	mov    0x8(%ebx),%eax
    132b:	89 04 24             	mov    %eax,(%esp)
    132e:	e8 7d fe ff ff       	call   11b0 <runcmd>
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
    1333:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    133a:	e8 db 0a 00 00       	call   1e1a <close>
      dup(p[1]);
    133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1342:	89 04 24             	mov    %eax,(%esp)
    1345:	e8 20 0b 00 00       	call   1e6a <dup>
      close(p[0]);
    134a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    134d:	89 04 24             	mov    %eax,(%esp)
    1350:	e8 c5 0a 00 00       	call   1e1a <close>
      close(p[1]);
    1355:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1358:	89 04 24             	mov    %eax,(%esp)
    135b:	e8 ba 0a 00 00       	call   1e1a <close>
      runcmd(pcmd->left);
    1360:	8b 43 04             	mov    0x4(%ebx),%eax
    1363:	89 04 24             	mov    %eax,(%esp)
    1366:	e8 45 fe ff ff       	call   11b0 <runcmd>
    136b:	90                   	nop
    136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001370 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    1370:	55                   	push   %ebp
    1371:	89 e5                	mov    %esp,%ebp
    1373:	53                   	push   %ebx
    1374:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1377:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
    137e:	e8 4d 0e 00 00       	call   21d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    1383:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
    138a:	00 
    138b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1392:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1395:	89 04 24             	mov    %eax,(%esp)
    1398:	e8 e3 08 00 00       	call   1c80 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
    139d:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
    139f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
    13a5:	83 c4 14             	add    $0x14,%esp
    13a8:	5b                   	pop    %ebx
    13a9:	5d                   	pop    %ebp
    13aa:	c3                   	ret    
    13ab:	90                   	nop
    13ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000013b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	53                   	push   %ebx
    13b4:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13b7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    13be:	e8 0d 0e 00 00       	call   21d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    13c3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
    13ca:	00 
    13cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13d2:	00 
    13d3:	89 04 24             	mov    %eax,(%esp)
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13d6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    13d8:	e8 a3 08 00 00       	call   1c80 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
    13dd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
    13e0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
    13e6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
    13e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ec:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
    13ef:	8b 45 10             	mov    0x10(%ebp),%eax
    13f2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
    13f5:	8b 45 14             	mov    0x14(%ebp),%eax
    13f8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
    13fb:	8b 45 18             	mov    0x18(%ebp),%eax
    13fe:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
    1401:	83 c4 14             	add    $0x14,%esp
    1404:	89 d8                	mov    %ebx,%eax
    1406:	5b                   	pop    %ebx
    1407:	5d                   	pop    %ebp
    1408:	c3                   	ret    
    1409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001410 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	53                   	push   %ebx
    1414:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1417:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    141e:	e8 ad 0d 00 00       	call   21d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    1423:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    142a:	00 
    142b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1432:	00 
    1433:	89 04 24             	mov    %eax,(%esp)
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1436:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1438:	e8 43 08 00 00       	call   1c80 <memset>
  cmd->type = PIPE;
  cmd->left = left;
    143d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
    1440:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
    1446:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    1449:	8b 45 0c             	mov    0xc(%ebp),%eax
    144c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    144f:	83 c4 14             	add    $0x14,%esp
    1452:	89 d8                	mov    %ebx,%eax
    1454:	5b                   	pop    %ebx
    1455:	5d                   	pop    %ebp
    1456:	c3                   	ret    
    1457:	89 f6                	mov    %esi,%esi
    1459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001460 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    1460:	55                   	push   %ebp
    1461:	89 e5                	mov    %esp,%ebp
    1463:	53                   	push   %ebx
    1464:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1467:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    146e:	e8 5d 0d 00 00       	call   21d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    1473:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    147a:	00 
    147b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1482:	00 
    1483:	89 04 24             	mov    %eax,(%esp)
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1486:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1488:	e8 f3 07 00 00       	call   1c80 <memset>
  cmd->type = LIST;
  cmd->left = left;
    148d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
    1490:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
    1496:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    1499:	8b 45 0c             	mov    0xc(%ebp),%eax
    149c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    149f:	83 c4 14             	add    $0x14,%esp
    14a2:	89 d8                	mov    %ebx,%eax
    14a4:	5b                   	pop    %ebx
    14a5:	5d                   	pop    %ebp
    14a6:	c3                   	ret    
    14a7:	89 f6                	mov    %esi,%esi
    14a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000014b0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    14b0:	55                   	push   %ebp
    14b1:	89 e5                	mov    %esp,%ebp
    14b3:	53                   	push   %ebx
    14b4:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14b7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    14be:	e8 0d 0d 00 00       	call   21d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    14c3:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
    14ca:	00 
    14cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14d2:	00 
    14d3:	89 04 24             	mov    %eax,(%esp)
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14d6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    14d8:	e8 a3 07 00 00       	call   1c80 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
    14e0:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
    14e6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
    14e9:	83 c4 14             	add    $0x14,%esp
    14ec:	89 d8                	mov    %ebx,%eax
    14ee:	5b                   	pop    %ebx
    14ef:	5d                   	pop    %ebp
    14f0:	c3                   	ret    
    14f1:	eb 0d                	jmp    1500 <gettoken>
    14f3:	90                   	nop
    14f4:	90                   	nop
    14f5:	90                   	nop
    14f6:	90                   	nop
    14f7:	90                   	nop
    14f8:	90                   	nop
    14f9:	90                   	nop
    14fa:	90                   	nop
    14fb:	90                   	nop
    14fc:	90                   	nop
    14fd:	90                   	nop
    14fe:	90                   	nop
    14ff:	90                   	nop

00001500 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	57                   	push   %edi
    1504:	56                   	push   %esi
    1505:	53                   	push   %ebx
    1506:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;

  s = *ps;
    1509:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    150c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    150f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *s;
  int ret;

  s = *ps;
    1512:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
    1514:	39 df                	cmp    %ebx,%edi
    1516:	72 0f                	jb     1527 <gettoken+0x27>
    1518:	eb 24                	jmp    153e <gettoken+0x3e>
    151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
    1520:	83 c7 01             	add    $0x1,%edi
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    1523:	39 df                	cmp    %ebx,%edi
    1525:	74 17                	je     153e <gettoken+0x3e>
    1527:	0f be 07             	movsbl (%edi),%eax
    152a:	c7 04 24 c4 29 00 00 	movl   $0x29c4,(%esp)
    1531:	89 44 24 04          	mov    %eax,0x4(%esp)
    1535:	e8 66 07 00 00       	call   1ca0 <strchr>
    153a:	85 c0                	test   %eax,%eax
    153c:	75 e2                	jne    1520 <gettoken+0x20>
    s++;
  if(q)
    153e:	85 f6                	test   %esi,%esi
    1540:	74 02                	je     1544 <gettoken+0x44>
    *q = s;
    1542:	89 3e                	mov    %edi,(%esi)
  ret = *s;
    1544:	0f b6 0f             	movzbl (%edi),%ecx
    1547:	0f be f1             	movsbl %cl,%esi
  switch(*s){
    154a:	80 f9 29             	cmp    $0x29,%cl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
    154d:	89 f0                	mov    %esi,%eax
  switch(*s){
    154f:	7f 4f                	jg     15a0 <gettoken+0xa0>
    1551:	80 f9 28             	cmp    $0x28,%cl
    1554:	7d 55                	jge    15ab <gettoken+0xab>
    1556:	84 c9                	test   %cl,%cl
    1558:	0f 85 ca 00 00 00    	jne    1628 <gettoken+0x128>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    155e:	8b 45 14             	mov    0x14(%ebp),%eax
    1561:	85 c0                	test   %eax,%eax
    1563:	74 05                	je     156a <gettoken+0x6a>
    *eq = s;
    1565:	8b 45 14             	mov    0x14(%ebp),%eax
    1568:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
    156a:	39 df                	cmp    %ebx,%edi
    156c:	72 09                	jb     1577 <gettoken+0x77>
    156e:	eb 1e                	jmp    158e <gettoken+0x8e>
    s++;
    1570:	83 c7 01             	add    $0x1,%edi
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    1573:	39 df                	cmp    %ebx,%edi
    1575:	74 17                	je     158e <gettoken+0x8e>
    1577:	0f be 07             	movsbl (%edi),%eax
    157a:	c7 04 24 c4 29 00 00 	movl   $0x29c4,(%esp)
    1581:	89 44 24 04          	mov    %eax,0x4(%esp)
    1585:	e8 16 07 00 00       	call   1ca0 <strchr>
    158a:	85 c0                	test   %eax,%eax
    158c:	75 e2                	jne    1570 <gettoken+0x70>
    s++;
  *ps = s;
    158e:	8b 45 08             	mov    0x8(%ebp),%eax
    1591:	89 38                	mov    %edi,(%eax)
  return ret;
}
    1593:	83 c4 1c             	add    $0x1c,%esp
    1596:	89 f0                	mov    %esi,%eax
    1598:	5b                   	pop    %ebx
    1599:	5e                   	pop    %esi
    159a:	5f                   	pop    %edi
    159b:	5d                   	pop    %ebp
    159c:	c3                   	ret    
    159d:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    15a0:	80 f9 3e             	cmp    $0x3e,%cl
    15a3:	75 0b                	jne    15b0 <gettoken+0xb0>
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
    15a5:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    15a9:	74 6d                	je     1618 <gettoken+0x118>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    15ab:	83 c7 01             	add    $0x1,%edi
    15ae:	eb ae                	jmp    155e <gettoken+0x5e>
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    15b0:	7f 56                	jg     1608 <gettoken+0x108>
    15b2:	83 e9 3b             	sub    $0x3b,%ecx
    15b5:	80 f9 01             	cmp    $0x1,%cl
    15b8:	76 f1                	jbe    15ab <gettoken+0xab>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15ba:	39 fb                	cmp    %edi,%ebx
    15bc:	77 2b                	ja     15e9 <gettoken+0xe9>
    15be:	66 90                	xchg   %ax,%ax
    15c0:	eb 3b                	jmp    15fd <gettoken+0xfd>
    15c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    15c8:	0f be 07             	movsbl (%edi),%eax
    15cb:	c7 04 24 bc 29 00 00 	movl   $0x29bc,(%esp)
    15d2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d6:	e8 c5 06 00 00       	call   1ca0 <strchr>
    15db:	85 c0                	test   %eax,%eax
    15dd:	75 1e                	jne    15fd <gettoken+0xfd>
      s++;
    15df:	83 c7 01             	add    $0x1,%edi
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15e2:	39 df                	cmp    %ebx,%edi
    15e4:	74 17                	je     15fd <gettoken+0xfd>
    15e6:	0f be 07             	movsbl (%edi),%eax
    15e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ed:	c7 04 24 c4 29 00 00 	movl   $0x29c4,(%esp)
    15f4:	e8 a7 06 00 00       	call   1ca0 <strchr>
    15f9:	85 c0                	test   %eax,%eax
    15fb:	74 cb                	je     15c8 <gettoken+0xc8>
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    15fd:	be 61 00 00 00       	mov    $0x61,%esi
    1602:	e9 57 ff ff ff       	jmp    155e <gettoken+0x5e>
    1607:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    1608:	80 f9 7c             	cmp    $0x7c,%cl
    160b:	74 9e                	je     15ab <gettoken+0xab>
    160d:	8d 76 00             	lea    0x0(%esi),%esi
    1610:	eb a8                	jmp    15ba <gettoken+0xba>
    1612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    1618:	83 c7 02             	add    $0x2,%edi
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
    161b:	be 2b 00 00 00       	mov    $0x2b,%esi
    1620:	e9 39 ff ff ff       	jmp    155e <gettoken+0x5e>
    1625:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    1628:	80 f9 26             	cmp    $0x26,%cl
    162b:	75 8d                	jne    15ba <gettoken+0xba>
    162d:	e9 79 ff ff ff       	jmp    15ab <gettoken+0xab>
    1632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001640 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
    1640:	55                   	push   %ebp
    1641:	89 e5                	mov    %esp,%ebp
    1643:	57                   	push   %edi
    1644:	56                   	push   %esi
    1645:	53                   	push   %ebx
    1646:	83 ec 1c             	sub    $0x1c,%esp
    1649:	8b 7d 08             	mov    0x8(%ebp),%edi
    164c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
    164f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
    1651:	39 f3                	cmp    %esi,%ebx
    1653:	72 0a                	jb     165f <peek+0x1f>
    1655:	eb 1f                	jmp    1676 <peek+0x36>
    1657:	90                   	nop
    s++;
    1658:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    165b:	39 f3                	cmp    %esi,%ebx
    165d:	74 17                	je     1676 <peek+0x36>
    165f:	0f be 03             	movsbl (%ebx),%eax
    1662:	c7 04 24 c4 29 00 00 	movl   $0x29c4,(%esp)
    1669:	89 44 24 04          	mov    %eax,0x4(%esp)
    166d:	e8 2e 06 00 00       	call   1ca0 <strchr>
    1672:	85 c0                	test   %eax,%eax
    1674:	75 e2                	jne    1658 <peek+0x18>
    s++;
  *ps = s;
    1676:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
    1678:	0f be 13             	movsbl (%ebx),%edx
    167b:	31 c0                	xor    %eax,%eax
    167d:	84 d2                	test   %dl,%dl
    167f:	74 17                	je     1698 <peek+0x58>
    1681:	8b 45 10             	mov    0x10(%ebp),%eax
    1684:	89 54 24 04          	mov    %edx,0x4(%esp)
    1688:	89 04 24             	mov    %eax,(%esp)
    168b:	e8 10 06 00 00       	call   1ca0 <strchr>
    1690:	85 c0                	test   %eax,%eax
    1692:	0f 95 c0             	setne  %al
    1695:	0f b6 c0             	movzbl %al,%eax
}
    1698:	83 c4 1c             	add    $0x1c,%esp
    169b:	5b                   	pop    %ebx
    169c:	5e                   	pop    %esi
    169d:	5f                   	pop    %edi
    169e:	5d                   	pop    %ebp
    169f:	c3                   	ret    

000016a0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    16a0:	55                   	push   %ebp
    16a1:	89 e5                	mov    %esp,%ebp
    16a3:	57                   	push   %edi
    16a4:	56                   	push   %esi
    16a5:	53                   	push   %ebx
    16a6:	83 ec 3c             	sub    $0x3c,%esp
    16a9:	8b 75 0c             	mov    0xc(%ebp),%esi
    16ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16af:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    16b0:	c7 44 24 08 4e 23 00 	movl   $0x234e,0x8(%esp)
    16b7:	00 
    16b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    16bc:	89 34 24             	mov    %esi,(%esp)
    16bf:	e8 7c ff ff ff       	call   1640 <peek>
    16c4:	85 c0                	test   %eax,%eax
    16c6:	0f 84 9c 00 00 00    	je     1768 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
    16cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    16d3:	00 
    16d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    16db:	00 
    16dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    16e0:	89 34 24             	mov    %esi,(%esp)
    16e3:	e8 18 fe ff ff       	call   1500 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
    16e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    16ec:	89 34 24             	mov    %esi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    16ef:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
    16f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    16f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
    16f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
    16fb:	89 44 24 08          	mov    %eax,0x8(%esp)
    16ff:	e8 fc fd ff ff       	call   1500 <gettoken>
    1704:	83 f8 61             	cmp    $0x61,%eax
    1707:	75 6a                	jne    1773 <parseredirs+0xd3>
      panic("missing file for redirection");
    switch(tok){
    1709:	83 ff 3c             	cmp    $0x3c,%edi
    170c:	74 42                	je     1750 <parseredirs+0xb0>
    170e:	83 ff 3e             	cmp    $0x3e,%edi
    1711:	74 05                	je     1718 <parseredirs+0x78>
    1713:	83 ff 2b             	cmp    $0x2b,%edi
    1716:	75 98                	jne    16b0 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1718:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    171f:	00 
    1720:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    1727:	00 
    1728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    172b:	89 44 24 08          	mov    %eax,0x8(%esp)
    172f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1732:	89 44 24 04          	mov    %eax,0x4(%esp)
    1736:	8b 45 08             	mov    0x8(%ebp),%eax
    1739:	89 04 24             	mov    %eax,(%esp)
    173c:	e8 6f fc ff ff       	call   13b0 <redircmd>
    1741:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    1744:	e9 67 ff ff ff       	jmp    16b0 <parseredirs+0x10>
    1749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    1750:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1757:	00 
    1758:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    175f:	00 
    1760:	eb c6                	jmp    1728 <parseredirs+0x88>
    1762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
    1768:	8b 45 08             	mov    0x8(%ebp),%eax
    176b:	83 c4 3c             	add    $0x3c,%esp
    176e:	5b                   	pop    %ebx
    176f:	5e                   	pop    %esi
    1770:	5f                   	pop    %edi
    1771:	5d                   	pop    %ebp
    1772:	c3                   	ret    
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    1773:	c7 04 24 31 23 00 00 	movl   $0x2331,(%esp)
    177a:	e8 e1 f9 ff ff       	call   1160 <panic>
    177f:	90                   	nop

00001780 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
    1780:	55                   	push   %ebp
    1781:	89 e5                	mov    %esp,%ebp
    1783:	57                   	push   %edi
    1784:	56                   	push   %esi
    1785:	53                   	push   %ebx
    1786:	83 ec 3c             	sub    $0x3c,%esp
    1789:	8b 75 08             	mov    0x8(%ebp),%esi
    178c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    178f:	c7 44 24 08 51 23 00 	movl   $0x2351,0x8(%esp)
    1796:	00 
    1797:	89 34 24             	mov    %esi,(%esp)
    179a:	89 7c 24 04          	mov    %edi,0x4(%esp)
    179e:	e8 9d fe ff ff       	call   1640 <peek>
    17a3:	85 c0                	test   %eax,%eax
    17a5:	0f 85 a5 00 00 00    	jne    1850 <parseexec+0xd0>
    return parseblock(ps, es);

  ret = execcmd();
    17ab:	e8 c0 fb ff ff       	call   1370 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    17b0:	89 7c 24 08          	mov    %edi,0x8(%esp)
    17b4:	89 74 24 04          	mov    %esi,0x4(%esp)
    17b8:	89 04 24             	mov    %eax,(%esp)
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
    17bb:	89 c3                	mov    %eax,%ebx
    17bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    17c0:	e8 db fe ff ff       	call   16a0 <parseredirs>
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
    17c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  ret = parseredirs(ret, ps, es);
    17cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
    17cf:	eb 1d                	jmp    17ee <parseexec+0x6e>
    17d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
    17d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    17db:	89 7c 24 08          	mov    %edi,0x8(%esp)
    17df:	89 74 24 04          	mov    %esi,0x4(%esp)
    17e3:	89 04 24             	mov    %eax,(%esp)
    17e6:	e8 b5 fe ff ff       	call   16a0 <parseredirs>
    17eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    17ee:	c7 44 24 08 68 23 00 	movl   $0x2368,0x8(%esp)
    17f5:	00 
    17f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
    17fa:	89 34 24             	mov    %esi,(%esp)
    17fd:	e8 3e fe ff ff       	call   1640 <peek>
    1802:	85 c0                	test   %eax,%eax
    1804:	75 62                	jne    1868 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1806:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1809:	89 44 24 0c          	mov    %eax,0xc(%esp)
    180d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1810:	89 44 24 08          	mov    %eax,0x8(%esp)
    1814:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1818:	89 34 24             	mov    %esi,(%esp)
    181b:	e8 e0 fc ff ff       	call   1500 <gettoken>
    1820:	85 c0                	test   %eax,%eax
    1822:	74 44                	je     1868 <parseexec+0xe8>
      break;
    if(tok != 'a')
    1824:	83 f8 61             	cmp    $0x61,%eax
    1827:	75 61                	jne    188a <parseexec+0x10a>
      panic("syntax");
    cmd->argv[argc] = q;
    1829:	8b 45 e0             	mov    -0x20(%ebp),%eax
    182c:	83 c3 04             	add    $0x4,%ebx
    cmd->eargv[argc] = eq;
    argc++;
    182f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    1833:	89 03                	mov    %eax,(%ebx)
    cmd->eargv[argc] = eq;
    1835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1838:	89 43 28             	mov    %eax,0x28(%ebx)
    argc++;
    if(argc >= MAXARGS)
    183b:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
    183f:	75 97                	jne    17d8 <parseexec+0x58>
      panic("too many args");
    1841:	c7 04 24 5a 23 00 00 	movl   $0x235a,(%esp)
    1848:	e8 13 f9 ff ff       	call   1160 <panic>
    184d:	8d 76 00             	lea    0x0(%esi),%esi
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);
    1850:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1854:	89 34 24             	mov    %esi,(%esp)
    1857:	e8 84 01 00 00       	call   19e0 <parseblock>
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
    185c:	83 c4 3c             	add    $0x3c,%esp
    185f:	5b                   	pop    %ebx
    1860:	5e                   	pop    %esi
    1861:	5f                   	pop    %edi
    1862:	5d                   	pop    %ebp
    1863:	c3                   	ret    
    1864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1868:	8b 45 cc             	mov    -0x34(%ebp),%eax
    186b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    186e:	8d 04 90             	lea    (%eax,%edx,4),%eax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
    1871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
    1878:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
    187f:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
    1882:	83 c4 3c             	add    $0x3c,%esp
    1885:	5b                   	pop    %ebx
    1886:	5e                   	pop    %esi
    1887:	5f                   	pop    %edi
    1888:	5d                   	pop    %ebp
    1889:	c3                   	ret    
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    188a:	c7 04 24 53 23 00 00 	movl   $0x2353,(%esp)
    1891:	e8 ca f8 ff ff       	call   1160 <panic>
    1896:	8d 76 00             	lea    0x0(%esi),%esi
    1899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000018a0 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
    18a0:	55                   	push   %ebp
    18a1:	89 e5                	mov    %esp,%ebp
    18a3:	57                   	push   %edi
    18a4:	56                   	push   %esi
    18a5:	53                   	push   %ebx
    18a6:	83 ec 1c             	sub    $0x1c,%esp
    18a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    18ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    18af:	89 1c 24             	mov    %ebx,(%esp)
    18b2:	89 74 24 04          	mov    %esi,0x4(%esp)
    18b6:	e8 c5 fe ff ff       	call   1780 <parseexec>
  if(peek(ps, es, "|")){
    18bb:	c7 44 24 08 6d 23 00 	movl   $0x236d,0x8(%esp)
    18c2:	00 
    18c3:	89 74 24 04          	mov    %esi,0x4(%esp)
    18c7:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    18ca:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
    18cc:	e8 6f fd ff ff       	call   1640 <peek>
    18d1:	85 c0                	test   %eax,%eax
    18d3:	75 0b                	jne    18e0 <parsepipe+0x40>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
    18d5:	83 c4 1c             	add    $0x1c,%esp
    18d8:	89 f8                	mov    %edi,%eax
    18da:	5b                   	pop    %ebx
    18db:	5e                   	pop    %esi
    18dc:	5f                   	pop    %edi
    18dd:	5d                   	pop    %ebp
    18de:	c3                   	ret    
    18df:	90                   	nop
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    18e0:	89 74 24 04          	mov    %esi,0x4(%esp)
    18e4:	89 1c 24             	mov    %ebx,(%esp)
    18e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18ee:	00 
    18ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    18f6:	00 
    18f7:	e8 04 fc ff ff       	call   1500 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    18fc:	89 74 24 04          	mov    %esi,0x4(%esp)
    1900:	89 1c 24             	mov    %ebx,(%esp)
    1903:	e8 98 ff ff ff       	call   18a0 <parsepipe>
    1908:	89 7d 08             	mov    %edi,0x8(%ebp)
    190b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
    190e:	83 c4 1c             	add    $0x1c,%esp
    1911:	5b                   	pop    %ebx
    1912:	5e                   	pop    %esi
    1913:	5f                   	pop    %edi
    1914:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
    1915:	e9 f6 fa ff ff       	jmp    1410 <pipecmd>
    191a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001920 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
    1920:	55                   	push   %ebp
    1921:	89 e5                	mov    %esp,%ebp
    1923:	57                   	push   %edi
    1924:	56                   	push   %esi
    1925:	53                   	push   %ebx
    1926:	83 ec 1c             	sub    $0x1c,%esp
    1929:	8b 5d 08             	mov    0x8(%ebp),%ebx
    192c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    192f:	89 1c 24             	mov    %ebx,(%esp)
    1932:	89 74 24 04          	mov    %esi,0x4(%esp)
    1936:	e8 65 ff ff ff       	call   18a0 <parsepipe>
    193b:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
    193d:	eb 27                	jmp    1966 <parseline+0x46>
    193f:	90                   	nop
    gettoken(ps, es, 0, 0);
    1940:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1947:	00 
    1948:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    194f:	00 
    1950:	89 74 24 04          	mov    %esi,0x4(%esp)
    1954:	89 1c 24             	mov    %ebx,(%esp)
    1957:	e8 a4 fb ff ff       	call   1500 <gettoken>
    cmd = backcmd(cmd);
    195c:	89 3c 24             	mov    %edi,(%esp)
    195f:	e8 4c fb ff ff       	call   14b0 <backcmd>
    1964:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    1966:	c7 44 24 08 6f 23 00 	movl   $0x236f,0x8(%esp)
    196d:	00 
    196e:	89 74 24 04          	mov    %esi,0x4(%esp)
    1972:	89 1c 24             	mov    %ebx,(%esp)
    1975:	e8 c6 fc ff ff       	call   1640 <peek>
    197a:	85 c0                	test   %eax,%eax
    197c:	75 c2                	jne    1940 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    197e:	c7 44 24 08 6b 23 00 	movl   $0x236b,0x8(%esp)
    1985:	00 
    1986:	89 74 24 04          	mov    %esi,0x4(%esp)
    198a:	89 1c 24             	mov    %ebx,(%esp)
    198d:	e8 ae fc ff ff       	call   1640 <peek>
    1992:	85 c0                	test   %eax,%eax
    1994:	75 0a                	jne    19a0 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
    1996:	83 c4 1c             	add    $0x1c,%esp
    1999:	89 f8                	mov    %edi,%eax
    199b:	5b                   	pop    %ebx
    199c:	5e                   	pop    %esi
    199d:	5f                   	pop    %edi
    199e:	5d                   	pop    %ebp
    199f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    19a0:	89 74 24 04          	mov    %esi,0x4(%esp)
    19a4:	89 1c 24             	mov    %ebx,(%esp)
    19a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    19ae:	00 
    19af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    19b6:	00 
    19b7:	e8 44 fb ff ff       	call   1500 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    19bc:	89 74 24 04          	mov    %esi,0x4(%esp)
    19c0:	89 1c 24             	mov    %ebx,(%esp)
    19c3:	e8 58 ff ff ff       	call   1920 <parseline>
    19c8:	89 7d 08             	mov    %edi,0x8(%ebp)
    19cb:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
    19ce:	83 c4 1c             	add    $0x1c,%esp
    19d1:	5b                   	pop    %ebx
    19d2:	5e                   	pop    %esi
    19d3:	5f                   	pop    %edi
    19d4:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
    19d5:	e9 86 fa ff ff       	jmp    1460 <listcmd>
    19da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000019e0 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
    19e0:	55                   	push   %ebp
    19e1:	89 e5                	mov    %esp,%ebp
    19e3:	57                   	push   %edi
    19e4:	56                   	push   %esi
    19e5:	53                   	push   %ebx
    19e6:	83 ec 1c             	sub    $0x1c,%esp
    19e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    19ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    19ef:	c7 44 24 08 51 23 00 	movl   $0x2351,0x8(%esp)
    19f6:	00 
    19f7:	89 1c 24             	mov    %ebx,(%esp)
    19fa:	89 74 24 04          	mov    %esi,0x4(%esp)
    19fe:	e8 3d fc ff ff       	call   1640 <peek>
    1a03:	85 c0                	test   %eax,%eax
    1a05:	74 76                	je     1a7d <parseblock+0x9d>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
    1a07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a0e:	00 
    1a0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a16:	00 
    1a17:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a1b:	89 1c 24             	mov    %ebx,(%esp)
    1a1e:	e8 dd fa ff ff       	call   1500 <gettoken>
  cmd = parseline(ps, es);
    1a23:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a27:	89 1c 24             	mov    %ebx,(%esp)
    1a2a:	e8 f1 fe ff ff       	call   1920 <parseline>
  if(!peek(ps, es, ")"))
    1a2f:	c7 44 24 08 8d 23 00 	movl   $0x238d,0x8(%esp)
    1a36:	00 
    1a37:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a3b:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
    1a3e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
    1a40:	e8 fb fb ff ff       	call   1640 <peek>
    1a45:	85 c0                	test   %eax,%eax
    1a47:	74 40                	je     1a89 <parseblock+0xa9>
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
    1a49:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a4d:	89 1c 24             	mov    %ebx,(%esp)
    1a50:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a57:	00 
    1a58:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a5f:	00 
    1a60:	e8 9b fa ff ff       	call   1500 <gettoken>
  cmd = parseredirs(cmd, ps, es);
    1a65:	89 74 24 08          	mov    %esi,0x8(%esp)
    1a69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1a6d:	89 3c 24             	mov    %edi,(%esp)
    1a70:	e8 2b fc ff ff       	call   16a0 <parseredirs>
  return cmd;
}
    1a75:	83 c4 1c             	add    $0x1c,%esp
    1a78:	5b                   	pop    %ebx
    1a79:	5e                   	pop    %esi
    1a7a:	5f                   	pop    %edi
    1a7b:	5d                   	pop    %ebp
    1a7c:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
    1a7d:	c7 04 24 71 23 00 00 	movl   $0x2371,(%esp)
    1a84:	e8 d7 f6 ff ff       	call   1160 <panic>
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
    1a89:	c7 04 24 7c 23 00 00 	movl   $0x237c,(%esp)
    1a90:	e8 cb f6 ff ff       	call   1160 <panic>
    1a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001aa0 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    1aa0:	55                   	push   %ebp
    1aa1:	89 e5                	mov    %esp,%ebp
    1aa3:	53                   	push   %ebx
    1aa4:	83 ec 14             	sub    $0x14,%esp
    1aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1aaa:	85 db                	test   %ebx,%ebx
    1aac:	0f 84 8e 00 00 00    	je     1b40 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
    1ab2:	83 3b 05             	cmpl   $0x5,(%ebx)
    1ab5:	77 49                	ja     1b00 <nulterminate+0x60>
    1ab7:	8b 03                	mov    (%ebx),%eax
    1ab9:	ff 24 85 cc 23 00 00 	jmp    *0x23cc(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    1ac0:	8b 43 04             	mov    0x4(%ebx),%eax
    1ac3:	89 04 24             	mov    %eax,(%esp)
    1ac6:	e8 d5 ff ff ff       	call   1aa0 <nulterminate>
    nulterminate(lcmd->right);
    1acb:	8b 43 08             	mov    0x8(%ebx),%eax
    1ace:	89 04 24             	mov    %eax,(%esp)
    1ad1:	e8 ca ff ff ff       	call   1aa0 <nulterminate>
    break;
    1ad6:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1ad8:	83 c4 14             	add    $0x14,%esp
    1adb:	5b                   	pop    %ebx
    1adc:	5d                   	pop    %ebp
    1add:	c3                   	ret    
    1ade:	66 90                	xchg   %ax,%ax
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1ae0:	8b 4b 04             	mov    0x4(%ebx),%ecx
    1ae3:	89 d8                	mov    %ebx,%eax
    1ae5:	85 c9                	test   %ecx,%ecx
    1ae7:	74 17                	je     1b00 <nulterminate+0x60>
    1ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    1af0:	8b 50 2c             	mov    0x2c(%eax),%edx
    1af3:	83 c0 04             	add    $0x4,%eax
    1af6:	c6 02 00             	movb   $0x0,(%edx)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1af9:	8b 50 04             	mov    0x4(%eax),%edx
    1afc:	85 d2                	test   %edx,%edx
    1afe:	75 f0                	jne    1af0 <nulterminate+0x50>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b00:	83 c4 14             	add    $0x14,%esp
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
    1b03:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b05:	5b                   	pop    %ebx
    1b06:	5d                   	pop    %ebp
    1b07:	c3                   	ret    
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    1b08:	8b 43 04             	mov    0x4(%ebx),%eax
    1b0b:	89 04 24             	mov    %eax,(%esp)
    1b0e:	e8 8d ff ff ff       	call   1aa0 <nulterminate>
    break;
  }
  return cmd;
}
    1b13:	83 c4 14             	add    $0x14,%esp
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
    1b16:	89 d8                	mov    %ebx,%eax
  }
  return cmd;
}
    1b18:	5b                   	pop    %ebx
    1b19:	5d                   	pop    %ebp
    1b1a:	c3                   	ret    
    1b1b:	90                   	nop
    1b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    1b20:	8b 43 04             	mov    0x4(%ebx),%eax
    1b23:	89 04 24             	mov    %eax,(%esp)
    1b26:	e8 75 ff ff ff       	call   1aa0 <nulterminate>
    *rcmd->efile = 0;
    1b2b:	8b 43 0c             	mov    0xc(%ebx),%eax
    1b2e:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b31:	83 c4 14             	add    $0x14,%esp

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;
    1b34:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b36:	5b                   	pop    %ebx
    1b37:	5d                   	pop    %ebp
    1b38:	c3                   	ret    
    1b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
    1b40:	31 c0                	xor    %eax,%eax
    1b42:	eb 94                	jmp    1ad8 <nulterminate+0x38>
    1b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001b50 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    1b50:	55                   	push   %ebp
    1b51:	89 e5                	mov    %esp,%ebp
    1b53:	56                   	push   %esi
    1b54:	53                   	push   %ebx
    1b55:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    1b58:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1b5b:	89 1c 24             	mov    %ebx,(%esp)
    1b5e:	e8 ed 00 00 00       	call   1c50 <strlen>
    1b63:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
    1b65:	8d 45 08             	lea    0x8(%ebp),%eax
    1b68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1b6c:	89 04 24             	mov    %eax,(%esp)
    1b6f:	e8 ac fd ff ff       	call   1920 <parseline>
  peek(&s, es, "");
    1b74:	c7 44 24 08 04 23 00 	movl   $0x2304,0x8(%esp)
    1b7b:	00 
    1b7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
    1b80:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
    1b82:	8d 45 08             	lea    0x8(%ebp),%eax
    1b85:	89 04 24             	mov    %eax,(%esp)
    1b88:	e8 b3 fa ff ff       	call   1640 <peek>
  if(s != es){
    1b8d:	8b 45 08             	mov    0x8(%ebp),%eax
    1b90:	39 d8                	cmp    %ebx,%eax
    1b92:	75 11                	jne    1ba5 <parsecmd+0x55>
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
    1b94:	89 34 24             	mov    %esi,(%esp)
    1b97:	e8 04 ff ff ff       	call   1aa0 <nulterminate>
  return cmd;
}
    1b9c:	83 c4 10             	add    $0x10,%esp
    1b9f:	89 f0                	mov    %esi,%eax
    1ba1:	5b                   	pop    %ebx
    1ba2:	5e                   	pop    %esi
    1ba3:	5d                   	pop    %ebp
    1ba4:	c3                   	ret    

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    1ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ba9:	c7 44 24 04 8f 23 00 	movl   $0x238f,0x4(%esp)
    1bb0:	00 
    1bb1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bb8:	e8 93 03 00 00       	call   1f50 <printf>
    panic("syntax");
    1bbd:	c7 04 24 53 23 00 00 	movl   $0x2353,(%esp)
    1bc4:	e8 97 f5 ff ff       	call   1160 <panic>
    1bc9:	66 90                	xchg   %ax,%ax
    1bcb:	66 90                	xchg   %ax,%ax
    1bcd:	66 90                	xchg   %ax,%ax
    1bcf:	90                   	nop

00001bd0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1bd0:	55                   	push   %ebp
    1bd1:	89 e5                	mov    %esp,%ebp
    1bd3:	8b 45 08             	mov    0x8(%ebp),%eax
    1bd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1bd9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1bda:	89 c2                	mov    %eax,%edx
    1bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1be0:	83 c1 01             	add    $0x1,%ecx
    1be3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1be7:	83 c2 01             	add    $0x1,%edx
    1bea:	84 db                	test   %bl,%bl
    1bec:	88 5a ff             	mov    %bl,-0x1(%edx)
    1bef:	75 ef                	jne    1be0 <strcpy+0x10>
    ;
  return os;
}
    1bf1:	5b                   	pop    %ebx
    1bf2:	5d                   	pop    %ebp
    1bf3:	c3                   	ret    
    1bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001c00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1c00:	55                   	push   %ebp
    1c01:	89 e5                	mov    %esp,%ebp
    1c03:	8b 55 08             	mov    0x8(%ebp),%edx
    1c06:	53                   	push   %ebx
    1c07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    1c0a:	0f b6 02             	movzbl (%edx),%eax
    1c0d:	84 c0                	test   %al,%al
    1c0f:	74 2d                	je     1c3e <strcmp+0x3e>
    1c11:	0f b6 19             	movzbl (%ecx),%ebx
    1c14:	38 d8                	cmp    %bl,%al
    1c16:	74 0e                	je     1c26 <strcmp+0x26>
    1c18:	eb 2b                	jmp    1c45 <strcmp+0x45>
    1c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1c20:	38 c8                	cmp    %cl,%al
    1c22:	75 15                	jne    1c39 <strcmp+0x39>
    p++, q++;
    1c24:	89 d9                	mov    %ebx,%ecx
    1c26:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c29:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    1c2c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c2f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    1c33:	84 c0                	test   %al,%al
    1c35:	75 e9                	jne    1c20 <strcmp+0x20>
    1c37:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1c39:	29 c8                	sub    %ecx,%eax
}
    1c3b:	5b                   	pop    %ebx
    1c3c:	5d                   	pop    %ebp
    1c3d:	c3                   	ret    
    1c3e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c41:	31 c0                	xor    %eax,%eax
    1c43:	eb f4                	jmp    1c39 <strcmp+0x39>
    1c45:	0f b6 cb             	movzbl %bl,%ecx
    1c48:	eb ef                	jmp    1c39 <strcmp+0x39>
    1c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001c50 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    1c50:	55                   	push   %ebp
    1c51:	89 e5                	mov    %esp,%ebp
    1c53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1c56:	80 39 00             	cmpb   $0x0,(%ecx)
    1c59:	74 12                	je     1c6d <strlen+0x1d>
    1c5b:	31 d2                	xor    %edx,%edx
    1c5d:	8d 76 00             	lea    0x0(%esi),%esi
    1c60:	83 c2 01             	add    $0x1,%edx
    1c63:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1c67:	89 d0                	mov    %edx,%eax
    1c69:	75 f5                	jne    1c60 <strlen+0x10>
    ;
  return n;
}
    1c6b:	5d                   	pop    %ebp
    1c6c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    1c6d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    1c6f:	5d                   	pop    %ebp
    1c70:	c3                   	ret    
    1c71:	eb 0d                	jmp    1c80 <memset>
    1c73:	90                   	nop
    1c74:	90                   	nop
    1c75:	90                   	nop
    1c76:	90                   	nop
    1c77:	90                   	nop
    1c78:	90                   	nop
    1c79:	90                   	nop
    1c7a:	90                   	nop
    1c7b:	90                   	nop
    1c7c:	90                   	nop
    1c7d:	90                   	nop
    1c7e:	90                   	nop
    1c7f:	90                   	nop

00001c80 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1c80:	55                   	push   %ebp
    1c81:	89 e5                	mov    %esp,%ebp
    1c83:	8b 55 08             	mov    0x8(%ebp),%edx
    1c86:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1c87:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
    1c8d:	89 d7                	mov    %edx,%edi
    1c8f:	fc                   	cld    
    1c90:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1c92:	89 d0                	mov    %edx,%eax
    1c94:	5f                   	pop    %edi
    1c95:	5d                   	pop    %ebp
    1c96:	c3                   	ret    
    1c97:	89 f6                	mov    %esi,%esi
    1c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001ca0 <strchr>:

char*
strchr(const char *s, char c)
{
    1ca0:	55                   	push   %ebp
    1ca1:	89 e5                	mov    %esp,%ebp
    1ca3:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca6:	53                   	push   %ebx
    1ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    1caa:	0f b6 18             	movzbl (%eax),%ebx
    1cad:	84 db                	test   %bl,%bl
    1caf:	74 1d                	je     1cce <strchr+0x2e>
    if(*s == c)
    1cb1:	38 d3                	cmp    %dl,%bl
    1cb3:	89 d1                	mov    %edx,%ecx
    1cb5:	75 0d                	jne    1cc4 <strchr+0x24>
    1cb7:	eb 17                	jmp    1cd0 <strchr+0x30>
    1cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1cc0:	38 ca                	cmp    %cl,%dl
    1cc2:	74 0c                	je     1cd0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1cc4:	83 c0 01             	add    $0x1,%eax
    1cc7:	0f b6 10             	movzbl (%eax),%edx
    1cca:	84 d2                	test   %dl,%dl
    1ccc:	75 f2                	jne    1cc0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    1cce:	31 c0                	xor    %eax,%eax
}
    1cd0:	5b                   	pop    %ebx
    1cd1:	5d                   	pop    %ebp
    1cd2:	c3                   	ret    
    1cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001ce0 <gets>:

char*
gets(char *buf, int max)
{
    1ce0:	55                   	push   %ebp
    1ce1:	89 e5                	mov    %esp,%ebp
    1ce3:	57                   	push   %edi
    1ce4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1ce5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1ce7:	53                   	push   %ebx
    1ce8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1ceb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1cee:	eb 31                	jmp    1d21 <gets+0x41>
    cc = read(0, &c, 1);
    1cf0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1cf7:	00 
    1cf8:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1cfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1d03:	e8 02 01 00 00       	call   1e0a <read>
    if(cc < 1)
    1d08:	85 c0                	test   %eax,%eax
    1d0a:	7e 1d                	jle    1d29 <gets+0x49>
      break;
    buf[i++] = c;
    1d0c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d10:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1d12:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    1d15:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1d17:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    1d1b:	74 0c                	je     1d29 <gets+0x49>
    1d1d:	3c 0a                	cmp    $0xa,%al
    1d1f:	74 08                	je     1d29 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d21:	8d 5e 01             	lea    0x1(%esi),%ebx
    1d24:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1d27:	7c c7                	jl     1cf0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1d29:	8b 45 08             	mov    0x8(%ebp),%eax
    1d2c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1d30:	83 c4 2c             	add    $0x2c,%esp
    1d33:	5b                   	pop    %ebx
    1d34:	5e                   	pop    %esi
    1d35:	5f                   	pop    %edi
    1d36:	5d                   	pop    %ebp
    1d37:	c3                   	ret    
    1d38:	90                   	nop
    1d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001d40 <stat>:

int
stat(char *n, struct stat *st)
{
    1d40:	55                   	push   %ebp
    1d41:	89 e5                	mov    %esp,%ebp
    1d43:	56                   	push   %esi
    1d44:	53                   	push   %ebx
    1d45:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1d48:	8b 45 08             	mov    0x8(%ebp),%eax
    1d4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1d52:	00 
    1d53:	89 04 24             	mov    %eax,(%esp)
    1d56:	e8 d7 00 00 00       	call   1e32 <open>
  if(fd < 0)
    1d5b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1d5d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    1d5f:	78 27                	js     1d88 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1d61:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d64:	89 1c 24             	mov    %ebx,(%esp)
    1d67:	89 44 24 04          	mov    %eax,0x4(%esp)
    1d6b:	e8 da 00 00 00       	call   1e4a <fstat>
  close(fd);
    1d70:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    1d73:	89 c6                	mov    %eax,%esi
  close(fd);
    1d75:	e8 a0 00 00 00       	call   1e1a <close>
  return r;
    1d7a:	89 f0                	mov    %esi,%eax
}
    1d7c:	83 c4 10             	add    $0x10,%esp
    1d7f:	5b                   	pop    %ebx
    1d80:	5e                   	pop    %esi
    1d81:	5d                   	pop    %ebp
    1d82:	c3                   	ret    
    1d83:	90                   	nop
    1d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1d88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1d8d:	eb ed                	jmp    1d7c <stat+0x3c>
    1d8f:	90                   	nop

00001d90 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    1d90:	55                   	push   %ebp
    1d91:	89 e5                	mov    %esp,%ebp
    1d93:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1d96:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1d97:	0f be 11             	movsbl (%ecx),%edx
    1d9a:	8d 42 d0             	lea    -0x30(%edx),%eax
    1d9d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    1d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1da4:	77 17                	ja     1dbd <atoi+0x2d>
    1da6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1da8:	83 c1 01             	add    $0x1,%ecx
    1dab:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1dae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1db2:	0f be 11             	movsbl (%ecx),%edx
    1db5:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1db8:	80 fb 09             	cmp    $0x9,%bl
    1dbb:	76 eb                	jbe    1da8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    1dbd:	5b                   	pop    %ebx
    1dbe:	5d                   	pop    %ebp
    1dbf:	c3                   	ret    

00001dc0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1dc0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1dc1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    1dc3:	89 e5                	mov    %esp,%ebp
    1dc5:	56                   	push   %esi
    1dc6:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc9:	53                   	push   %ebx
    1dca:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1dcd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1dd0:	85 db                	test   %ebx,%ebx
    1dd2:	7e 12                	jle    1de6 <memmove+0x26>
    1dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1dd8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1ddc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1ddf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1de2:	39 da                	cmp    %ebx,%edx
    1de4:	75 f2                	jne    1dd8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1de6:	5b                   	pop    %ebx
    1de7:	5e                   	pop    %esi
    1de8:	5d                   	pop    %ebp
    1de9:	c3                   	ret    

00001dea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1dea:	b8 01 00 00 00       	mov    $0x1,%eax
    1def:	cd 40                	int    $0x40
    1df1:	c3                   	ret    

00001df2 <exit>:
SYSCALL(exit)
    1df2:	b8 02 00 00 00       	mov    $0x2,%eax
    1df7:	cd 40                	int    $0x40
    1df9:	c3                   	ret    

00001dfa <wait>:
SYSCALL(wait)
    1dfa:	b8 03 00 00 00       	mov    $0x3,%eax
    1dff:	cd 40                	int    $0x40
    1e01:	c3                   	ret    

00001e02 <pipe>:
SYSCALL(pipe)
    1e02:	b8 04 00 00 00       	mov    $0x4,%eax
    1e07:	cd 40                	int    $0x40
    1e09:	c3                   	ret    

00001e0a <read>:
SYSCALL(read)
    1e0a:	b8 05 00 00 00       	mov    $0x5,%eax
    1e0f:	cd 40                	int    $0x40
    1e11:	c3                   	ret    

00001e12 <write>:
SYSCALL(write)
    1e12:	b8 10 00 00 00       	mov    $0x10,%eax
    1e17:	cd 40                	int    $0x40
    1e19:	c3                   	ret    

00001e1a <close>:
SYSCALL(close)
    1e1a:	b8 15 00 00 00       	mov    $0x15,%eax
    1e1f:	cd 40                	int    $0x40
    1e21:	c3                   	ret    

00001e22 <kill>:
SYSCALL(kill)
    1e22:	b8 06 00 00 00       	mov    $0x6,%eax
    1e27:	cd 40                	int    $0x40
    1e29:	c3                   	ret    

00001e2a <exec>:
SYSCALL(exec)
    1e2a:	b8 07 00 00 00       	mov    $0x7,%eax
    1e2f:	cd 40                	int    $0x40
    1e31:	c3                   	ret    

00001e32 <open>:
SYSCALL(open)
    1e32:	b8 0f 00 00 00       	mov    $0xf,%eax
    1e37:	cd 40                	int    $0x40
    1e39:	c3                   	ret    

00001e3a <mknod>:
SYSCALL(mknod)
    1e3a:	b8 11 00 00 00       	mov    $0x11,%eax
    1e3f:	cd 40                	int    $0x40
    1e41:	c3                   	ret    

00001e42 <unlink>:
SYSCALL(unlink)
    1e42:	b8 12 00 00 00       	mov    $0x12,%eax
    1e47:	cd 40                	int    $0x40
    1e49:	c3                   	ret    

00001e4a <fstat>:
SYSCALL(fstat)
    1e4a:	b8 08 00 00 00       	mov    $0x8,%eax
    1e4f:	cd 40                	int    $0x40
    1e51:	c3                   	ret    

00001e52 <link>:
SYSCALL(link)
    1e52:	b8 13 00 00 00       	mov    $0x13,%eax
    1e57:	cd 40                	int    $0x40
    1e59:	c3                   	ret    

00001e5a <mkdir>:
SYSCALL(mkdir)
    1e5a:	b8 14 00 00 00       	mov    $0x14,%eax
    1e5f:	cd 40                	int    $0x40
    1e61:	c3                   	ret    

00001e62 <chdir>:
SYSCALL(chdir)
    1e62:	b8 09 00 00 00       	mov    $0x9,%eax
    1e67:	cd 40                	int    $0x40
    1e69:	c3                   	ret    

00001e6a <dup>:
SYSCALL(dup)
    1e6a:	b8 0a 00 00 00       	mov    $0xa,%eax
    1e6f:	cd 40                	int    $0x40
    1e71:	c3                   	ret    

00001e72 <getpid>:
SYSCALL(getpid)
    1e72:	b8 0b 00 00 00       	mov    $0xb,%eax
    1e77:	cd 40                	int    $0x40
    1e79:	c3                   	ret    

00001e7a <sbrk>:
SYSCALL(sbrk)
    1e7a:	b8 0c 00 00 00       	mov    $0xc,%eax
    1e7f:	cd 40                	int    $0x40
    1e81:	c3                   	ret    

00001e82 <sleep>:
SYSCALL(sleep)
    1e82:	b8 0d 00 00 00       	mov    $0xd,%eax
    1e87:	cd 40                	int    $0x40
    1e89:	c3                   	ret    

00001e8a <uptime>:
SYSCALL(uptime)
    1e8a:	b8 0e 00 00 00       	mov    $0xe,%eax
    1e8f:	cd 40                	int    $0x40
    1e91:	c3                   	ret    

00001e92 <shm_open>:
SYSCALL(shm_open)
    1e92:	b8 16 00 00 00       	mov    $0x16,%eax
    1e97:	cd 40                	int    $0x40
    1e99:	c3                   	ret    

00001e9a <shm_close>:
SYSCALL(shm_close)	
    1e9a:	b8 17 00 00 00       	mov    $0x17,%eax
    1e9f:	cd 40                	int    $0x40
    1ea1:	c3                   	ret    
    1ea2:	66 90                	xchg   %ax,%ax
    1ea4:	66 90                	xchg   %ax,%ax
    1ea6:	66 90                	xchg   %ax,%ax
    1ea8:	66 90                	xchg   %ax,%ax
    1eaa:	66 90                	xchg   %ax,%ax
    1eac:	66 90                	xchg   %ax,%ax
    1eae:	66 90                	xchg   %ax,%ax

00001eb0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1eb0:	55                   	push   %ebp
    1eb1:	89 e5                	mov    %esp,%ebp
    1eb3:	57                   	push   %edi
    1eb4:	56                   	push   %esi
    1eb5:	89 c6                	mov    %eax,%esi
    1eb7:	53                   	push   %ebx
    1eb8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1ebe:	85 db                	test   %ebx,%ebx
    1ec0:	74 09                	je     1ecb <printint+0x1b>
    1ec2:	89 d0                	mov    %edx,%eax
    1ec4:	c1 e8 1f             	shr    $0x1f,%eax
    1ec7:	84 c0                	test   %al,%al
    1ec9:	75 75                	jne    1f40 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1ecb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1ecd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1ed4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1ed7:	31 ff                	xor    %edi,%edi
    1ed9:	89 ce                	mov    %ecx,%esi
    1edb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1ede:	eb 02                	jmp    1ee2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    1ee0:	89 cf                	mov    %ecx,%edi
    1ee2:	31 d2                	xor    %edx,%edx
    1ee4:	f7 f6                	div    %esi
    1ee6:	8d 4f 01             	lea    0x1(%edi),%ecx
    1ee9:	0f b6 92 eb 23 00 00 	movzbl 0x23eb(%edx),%edx
  }while((x /= base) != 0);
    1ef0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1ef2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    1ef5:	75 e9                	jne    1ee0 <printint+0x30>
  if(neg)
    1ef7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1efa:	89 c8                	mov    %ecx,%eax
    1efc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    1eff:	85 d2                	test   %edx,%edx
    1f01:	74 08                	je     1f0b <printint+0x5b>
    buf[i++] = '-';
    1f03:	8d 4f 02             	lea    0x2(%edi),%ecx
    1f06:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    1f0b:	8d 79 ff             	lea    -0x1(%ecx),%edi
    1f0e:	66 90                	xchg   %ax,%ax
    1f10:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    1f15:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1f18:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1f1f:	00 
    1f20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1f24:	89 34 24             	mov    %esi,(%esp)
    1f27:	88 45 d7             	mov    %al,-0x29(%ebp)
    1f2a:	e8 e3 fe ff ff       	call   1e12 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1f2f:	83 ff ff             	cmp    $0xffffffff,%edi
    1f32:	75 dc                	jne    1f10 <printint+0x60>
    putc(fd, buf[i]);
}
    1f34:	83 c4 4c             	add    $0x4c,%esp
    1f37:	5b                   	pop    %ebx
    1f38:	5e                   	pop    %esi
    1f39:	5f                   	pop    %edi
    1f3a:	5d                   	pop    %ebp
    1f3b:	c3                   	ret    
    1f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1f40:	89 d0                	mov    %edx,%eax
    1f42:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    1f44:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    1f4b:	eb 87                	jmp    1ed4 <printint+0x24>
    1f4d:	8d 76 00             	lea    0x0(%esi),%esi

00001f50 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f50:	55                   	push   %ebp
    1f51:	89 e5                	mov    %esp,%ebp
    1f53:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1f54:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f56:	56                   	push   %esi
    1f57:	53                   	push   %ebx
    1f58:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1f5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1f5e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f61:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1f64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1f67:	0f b6 13             	movzbl (%ebx),%edx
    1f6a:	83 c3 01             	add    $0x1,%ebx
    1f6d:	84 d2                	test   %dl,%dl
    1f6f:	75 39                	jne    1faa <printf+0x5a>
    1f71:	e9 c2 00 00 00       	jmp    2038 <printf+0xe8>
    1f76:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1f78:	83 fa 25             	cmp    $0x25,%edx
    1f7b:	0f 84 bf 00 00 00    	je     2040 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1f81:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1f84:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1f8b:	00 
    1f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f90:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1f93:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1f96:	e8 77 fe ff ff       	call   1e12 <write>
    1f9b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1f9e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1fa2:	84 d2                	test   %dl,%dl
    1fa4:	0f 84 8e 00 00 00    	je     2038 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    1faa:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1fac:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    1faf:	74 c7                	je     1f78 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1fb1:	83 ff 25             	cmp    $0x25,%edi
    1fb4:	75 e5                	jne    1f9b <printf+0x4b>
      if(c == 'd'){
    1fb6:	83 fa 64             	cmp    $0x64,%edx
    1fb9:	0f 84 31 01 00 00    	je     20f0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1fbf:	25 f7 00 00 00       	and    $0xf7,%eax
    1fc4:	83 f8 70             	cmp    $0x70,%eax
    1fc7:	0f 84 83 00 00 00    	je     2050 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1fcd:	83 fa 73             	cmp    $0x73,%edx
    1fd0:	0f 84 a2 00 00 00    	je     2078 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1fd6:	83 fa 63             	cmp    $0x63,%edx
    1fd9:	0f 84 35 01 00 00    	je     2114 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1fdf:	83 fa 25             	cmp    $0x25,%edx
    1fe2:	0f 84 e0 00 00 00    	je     20c8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1fe8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1feb:	83 c3 01             	add    $0x1,%ebx
    1fee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1ff5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1ff6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ffc:	89 34 24             	mov    %esi,(%esp)
    1fff:	89 55 d0             	mov    %edx,-0x30(%ebp)
    2002:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    2006:	e8 07 fe ff ff       	call   1e12 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    200b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    200e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    2011:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2018:	00 
    2019:	89 44 24 04          	mov    %eax,0x4(%esp)
    201d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    2020:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2023:	e8 ea fd ff ff       	call   1e12 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2028:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    202c:	84 d2                	test   %dl,%dl
    202e:	0f 85 76 ff ff ff    	jne    1faa <printf+0x5a>
    2034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    2038:	83 c4 3c             	add    $0x3c,%esp
    203b:	5b                   	pop    %ebx
    203c:	5e                   	pop    %esi
    203d:	5f                   	pop    %edi
    203e:	5d                   	pop    %ebp
    203f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    2040:	bf 25 00 00 00       	mov    $0x25,%edi
    2045:	e9 51 ff ff ff       	jmp    1f9b <printf+0x4b>
    204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2050:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2053:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2058:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    205a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2061:	8b 10                	mov    (%eax),%edx
    2063:	89 f0                	mov    %esi,%eax
    2065:	e8 46 fe ff ff       	call   1eb0 <printint>
        ap++;
    206a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    206e:	e9 28 ff ff ff       	jmp    1f9b <printf+0x4b>
    2073:	90                   	nop
    2074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    2078:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    207b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    207f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    2081:	b8 e4 23 00 00       	mov    $0x23e4,%eax
    2086:	85 ff                	test   %edi,%edi
    2088:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    208b:	0f b6 07             	movzbl (%edi),%eax
    208e:	84 c0                	test   %al,%al
    2090:	74 2a                	je     20bc <printf+0x16c>
    2092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2098:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    209b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    209e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20a8:	00 
    20a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    20ad:	89 34 24             	mov    %esi,(%esp)
    20b0:	e8 5d fd ff ff       	call   1e12 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    20b5:	0f b6 07             	movzbl (%edi),%eax
    20b8:	84 c0                	test   %al,%al
    20ba:	75 dc                	jne    2098 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    20bc:	31 ff                	xor    %edi,%edi
    20be:	e9 d8 fe ff ff       	jmp    1f9b <printf+0x4b>
    20c3:	90                   	nop
    20c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    20cb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20d4:	00 
    20d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    20d9:	89 34 24             	mov    %esi,(%esp)
    20dc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    20e0:	e8 2d fd ff ff       	call   1e12 <write>
    20e5:	e9 b1 fe ff ff       	jmp    1f9b <printf+0x4b>
    20ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    20f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    20f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    20f8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    20fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2102:	8b 10                	mov    (%eax),%edx
    2104:	89 f0                	mov    %esi,%eax
    2106:	e8 a5 fd ff ff       	call   1eb0 <printint>
        ap++;
    210b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    210f:	e9 87 fe ff ff       	jmp    1f9b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2114:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2117:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2119:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    211b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2122:	00 
    2123:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2126:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2129:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    212c:	89 44 24 04          	mov    %eax,0x4(%esp)
    2130:	e8 dd fc ff ff       	call   1e12 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    2135:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    2139:	e9 5d fe ff ff       	jmp    1f9b <printf+0x4b>
    213e:	66 90                	xchg   %ax,%ax

00002140 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2140:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2141:	a1 44 2a 00 00       	mov    0x2a44,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    2146:	89 e5                	mov    %esp,%ebp
    2148:	57                   	push   %edi
    2149:	56                   	push   %esi
    214a:	53                   	push   %ebx
    214b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    214e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2150:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2153:	39 d0                	cmp    %edx,%eax
    2155:	72 11                	jb     2168 <free+0x28>
    2157:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2158:	39 c8                	cmp    %ecx,%eax
    215a:	72 04                	jb     2160 <free+0x20>
    215c:	39 ca                	cmp    %ecx,%edx
    215e:	72 10                	jb     2170 <free+0x30>
    2160:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2162:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2164:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2166:	73 f0                	jae    2158 <free+0x18>
    2168:	39 ca                	cmp    %ecx,%edx
    216a:	72 04                	jb     2170 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    216c:	39 c8                	cmp    %ecx,%eax
    216e:	72 f0                	jb     2160 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2170:	8b 73 fc             	mov    -0x4(%ebx),%esi
    2173:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    2176:	39 cf                	cmp    %ecx,%edi
    2178:	74 1e                	je     2198 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    217a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    217d:	8b 48 04             	mov    0x4(%eax),%ecx
    2180:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    2183:	39 f2                	cmp    %esi,%edx
    2185:	74 28                	je     21af <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    2187:	89 10                	mov    %edx,(%eax)
  freep = p;
    2189:	a3 44 2a 00 00       	mov    %eax,0x2a44
}
    218e:	5b                   	pop    %ebx
    218f:	5e                   	pop    %esi
    2190:	5f                   	pop    %edi
    2191:	5d                   	pop    %ebp
    2192:	c3                   	ret    
    2193:	90                   	nop
    2194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    2198:	03 71 04             	add    0x4(%ecx),%esi
    219b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    219e:	8b 08                	mov    (%eax),%ecx
    21a0:	8b 09                	mov    (%ecx),%ecx
    21a2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    21a5:	8b 48 04             	mov    0x4(%eax),%ecx
    21a8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    21ab:	39 f2                	cmp    %esi,%edx
    21ad:	75 d8                	jne    2187 <free+0x47>
    p->s.size += bp->s.size;
    21af:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    21b2:	a3 44 2a 00 00       	mov    %eax,0x2a44
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    21b7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    21ba:	8b 53 f8             	mov    -0x8(%ebx),%edx
    21bd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    21bf:	5b                   	pop    %ebx
    21c0:	5e                   	pop    %esi
    21c1:	5f                   	pop    %edi
    21c2:	5d                   	pop    %ebp
    21c3:	c3                   	ret    
    21c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    21ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000021d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    21d0:	55                   	push   %ebp
    21d1:	89 e5                	mov    %esp,%ebp
    21d3:	57                   	push   %edi
    21d4:	56                   	push   %esi
    21d5:	53                   	push   %ebx
    21d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    21d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    21dc:	8b 1d 44 2a 00 00    	mov    0x2a44,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    21e2:	8d 48 07             	lea    0x7(%eax),%ecx
    21e5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    21e8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    21ea:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    21ed:	0f 84 9b 00 00 00    	je     228e <malloc+0xbe>
    21f3:	8b 13                	mov    (%ebx),%edx
    21f5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    21f8:	39 fe                	cmp    %edi,%esi
    21fa:	76 64                	jbe    2260 <malloc+0x90>
    21fc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    2203:	bb 00 80 00 00       	mov    $0x8000,%ebx
    2208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    220b:	eb 0e                	jmp    221b <malloc+0x4b>
    220d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2210:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    2212:	8b 78 04             	mov    0x4(%eax),%edi
    2215:	39 fe                	cmp    %edi,%esi
    2217:	76 4f                	jbe    2268 <malloc+0x98>
    2219:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    221b:	3b 15 44 2a 00 00    	cmp    0x2a44,%edx
    2221:	75 ed                	jne    2210 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    2223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2226:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    222c:	bf 00 10 00 00       	mov    $0x1000,%edi
    2231:	0f 43 fe             	cmovae %esi,%edi
    2234:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    2237:	89 04 24             	mov    %eax,(%esp)
    223a:	e8 3b fc ff ff       	call   1e7a <sbrk>
  if(p == (char*)-1)
    223f:	83 f8 ff             	cmp    $0xffffffff,%eax
    2242:	74 18                	je     225c <malloc+0x8c>
    {return 0;}
  hp = (Header*)p;
  hp->s.size = nu;
    2244:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    2247:	83 c0 08             	add    $0x8,%eax
    224a:	89 04 24             	mov    %eax,(%esp)
    224d:	e8 ee fe ff ff       	call   2140 <free>
  return freep;
    2252:	8b 15 44 2a 00 00    	mov    0x2a44,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    2258:	85 d2                	test   %edx,%edx
    225a:	75 b4                	jne    2210 <malloc+0x40>
        {return 0;}
    225c:	31 c0                	xor    %eax,%eax
    225e:	eb 20                	jmp    2280 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    2260:	89 d0                	mov    %edx,%eax
    2262:	89 da                	mov    %ebx,%edx
    2264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    2268:	39 fe                	cmp    %edi,%esi
    226a:	74 1c                	je     2288 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    226c:	29 f7                	sub    %esi,%edi
    226e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    2271:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    2274:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    2277:	89 15 44 2a 00 00    	mov    %edx,0x2a44
      return (void*)(p + 1);
    227d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        {return 0;}
  }
}
    2280:	83 c4 1c             	add    $0x1c,%esp
    2283:	5b                   	pop    %ebx
    2284:	5e                   	pop    %esi
    2285:	5f                   	pop    %edi
    2286:	5d                   	pop    %ebp
    2287:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    2288:	8b 08                	mov    (%eax),%ecx
    228a:	89 0a                	mov    %ecx,(%edx)
    228c:	eb e9                	jmp    2277 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    228e:	c7 05 44 2a 00 00 48 	movl   $0x2a48,0x2a44
    2295:	2a 00 00 
    base.s.size = 0;
    2298:	ba 48 2a 00 00       	mov    $0x2a48,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    229d:	c7 05 48 2a 00 00 48 	movl   $0x2a48,0x2a48
    22a4:	2a 00 00 
    base.s.size = 0;
    22a7:	c7 05 4c 2a 00 00 00 	movl   $0x0,0x2a4c
    22ae:	00 00 00 
    22b1:	e9 46 ff ff ff       	jmp    21fc <malloc+0x2c>
    22b6:	66 90                	xchg   %ax,%ax
    22b8:	66 90                	xchg   %ax,%ax
    22ba:	66 90                	xchg   %ax,%ax
    22bc:	66 90                	xchg   %ax,%ax
    22be:	66 90                	xchg   %ax,%ax

000022c0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    22c0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    22c1:	b9 01 00 00 00       	mov    $0x1,%ecx
    22c6:	89 e5                	mov    %esp,%ebp
    22c8:	8b 55 08             	mov    0x8(%ebp),%edx
    22cb:	90                   	nop
    22cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    22d0:	89 c8                	mov    %ecx,%eax
    22d2:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    22d5:	85 c0                	test   %eax,%eax
    22d7:	75 f7                	jne    22d0 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    22d9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    22de:	5d                   	pop    %ebp
    22df:	c3                   	ret    

000022e0 <urelease>:

void urelease (struct uspinlock *lk) {
    22e0:	55                   	push   %ebp
    22e1:	89 e5                	mov    %esp,%ebp
    22e3:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    22e6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    22eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    22f1:	5d                   	pop    %ebp
    22f2:	c3                   	ret    
