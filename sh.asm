
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
    1013:	0f 8f e5 00 00 00    	jg     10fe <main+0xfe>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    1019:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1020:	00 
    1021:	c7 04 24 b9 23 00 00 	movl   $0x23b9,(%esp)
    1028:	e8 25 0e 00 00       	call   1e52 <open>
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
    1038:	80 3d 02 2a 00 00 20 	cmpb   $0x20,0x2a02
    103f:	90                   	nop
    1040:	74 74                	je     10b6 <main+0xb6>
    1042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0){
    1048:	e8 53 01 00 00       	call   11a0 <fork1>
    104d:	85 c0                	test   %eax,%eax
    104f:	74 38                	je     1089 <main+0x89>
      printf(1,"************");runcmd(parsecmd(buf));}
    wait();
    1051:	e8 c4 0d 00 00       	call   1e1a <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1056:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
    105d:	00 
    105e:	c7 04 24 00 2a 00 00 	movl   $0x2a00,(%esp)
    1065:	e8 a6 00 00 00       	call   1110 <getcmd>
    106a:	85 c0                	test   %eax,%eax
    106c:	78 43                	js     10b1 <main+0xb1>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    106e:	80 3d 00 2a 00 00 63 	cmpb   $0x63,0x2a00
    1075:	75 d1                	jne    1048 <main+0x48>
    1077:	80 3d 01 2a 00 00 64 	cmpb   $0x64,0x2a01
    107e:	74 b8                	je     1038 <main+0x38>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0){
    1080:	e8 1b 01 00 00       	call   11a0 <fork1>
    1085:	85 c0                	test   %eax,%eax
    1087:	75 c8                	jne    1051 <main+0x51>
      printf(1,"************");runcmd(parsecmd(buf));}
    1089:	c7 44 24 04 cf 23 00 	movl   $0x23cf,0x4(%esp)
    1090:	00 
    1091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1098:	e8 d3 0e 00 00       	call   1f70 <printf>
    109d:	c7 04 24 00 2a 00 00 	movl   $0x2a00,(%esp)
    10a4:	e8 c7 0a 00 00       	call   1b70 <parsecmd>
    10a9:	89 04 24             	mov    %eax,(%esp)
    10ac:	e8 0f 01 00 00       	call   11c0 <runcmd>
    wait();
  }
  exit();
    10b1:	e8 5c 0d 00 00       	call   1e12 <exit>

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    10b6:	c7 04 24 00 2a 00 00 	movl   $0x2a00,(%esp)
    10bd:	e8 ae 0b 00 00       	call   1c70 <strlen>
      if(chdir(buf+3) < 0)
    10c2:	c7 04 24 03 2a 00 00 	movl   $0x2a03,(%esp)

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    10c9:	c6 80 ff 29 00 00 00 	movb   $0x0,0x29ff(%eax)
      if(chdir(buf+3) < 0)
    10d0:	e8 ad 0d 00 00       	call   1e82 <chdir>
    10d5:	85 c0                	test   %eax,%eax
    10d7:	0f 89 79 ff ff ff    	jns    1056 <main+0x56>
        printf(2, "cannot cd %s\n", buf+3);
    10dd:	c7 44 24 08 03 2a 00 	movl   $0x2a03,0x8(%esp)
    10e4:	00 
    10e5:	c7 44 24 04 c1 23 00 	movl   $0x23c1,0x4(%esp)
    10ec:	00 
    10ed:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10f4:	e8 77 0e 00 00       	call   1f70 <printf>
    10f9:	e9 58 ff ff ff       	jmp    1056 <main+0x56>
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 34 0d 00 00       	call   1e3a <close>
      break;
    1106:	e9 4b ff ff ff       	jmp    1056 <main+0x56>
    110b:	66 90                	xchg   %ax,%ax
    110d:	66 90                	xchg   %ax,%ax
    110f:	90                   	nop

00001110 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	56                   	push   %esi
    1114:	53                   	push   %ebx
    1115:	83 ec 10             	sub    $0x10,%esp
    1118:	8b 5d 08             	mov    0x8(%ebp),%ebx
    111b:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
    111e:	c7 44 24 04 14 23 00 	movl   $0x2314,0x4(%esp)
    1125:	00 
    1126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    112d:	e8 3e 0e 00 00       	call   1f70 <printf>
  memset(buf, 0, nbuf);
    1132:	89 74 24 08          	mov    %esi,0x8(%esp)
    1136:	89 1c 24             	mov    %ebx,(%esp)
    1139:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1140:	00 
    1141:	e8 5a 0b 00 00       	call   1ca0 <memset>
  gets(buf, nbuf);
    1146:	89 74 24 04          	mov    %esi,0x4(%esp)
    114a:	89 1c 24             	mov    %ebx,(%esp)
    114d:	e8 ae 0b 00 00       	call   1d00 <gets>
  if(buf[0] == 0) // EOF
    1152:	31 c0                	xor    %eax,%eax
    1154:	80 3b 00             	cmpb   $0x0,(%ebx)
    1157:	0f 94 c0             	sete   %al
    return -1;
  return 0;
}
    115a:	83 c4 10             	add    $0x10,%esp
    115d:	5b                   	pop    %ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    115e:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
    1160:	5e                   	pop    %esi
    1161:	5d                   	pop    %ebp
    1162:	c3                   	ret    
    1163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001170 <panic>:
  exit();
}

void
panic(char *s)
{
    1170:	55                   	push   %ebp
    1171:	89 e5                	mov    %esp,%ebp
    1173:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
    1176:	8b 45 08             	mov    0x8(%ebp),%eax
    1179:	c7 44 24 04 b5 23 00 	movl   $0x23b5,0x4(%esp)
    1180:	00 
    1181:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1188:	89 44 24 08          	mov    %eax,0x8(%esp)
    118c:	e8 df 0d 00 00       	call   1f70 <printf>
  exit();
    1191:	e8 7c 0c 00 00       	call   1e12 <exit>
    1196:	8d 76 00             	lea    0x0(%esi),%esi
    1199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011a0 <fork1>:
}

int
fork1(void)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
    11a6:	e8 5f 0c 00 00       	call   1e0a <fork>
  if(pid == -1)
    11ab:	83 f8 ff             	cmp    $0xffffffff,%eax
    11ae:	74 02                	je     11b2 <fork1+0x12>
    panic("fork");
  return pid;
}
    11b0:	c9                   	leave  
    11b1:	c3                   	ret    
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
    11b2:	c7 04 24 17 23 00 00 	movl   $0x2317,(%esp)
    11b9:	e8 b2 ff ff ff       	call   1170 <panic>
    11be:	66 90                	xchg   %ax,%ax

000011c0 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	53                   	push   %ebx
    11c4:	83 ec 24             	sub    $0x24,%esp
    11c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0){
    11ca:	85 db                	test   %ebx,%ebx
    11cc:	0f 84 ff 00 00 00    	je     12d1 <runcmd+0x111>
    printf(1,"%d\n", cmd->type);exit();}

  switch(cmd->type){
    11d2:	83 3b 05             	cmpl   $0x5,(%ebx)
    11d5:	0f 87 ea 00 00 00    	ja     12c5 <runcmd+0x105>
    11db:	8b 03                	mov    (%ebx),%eax
    11dd:	ff 24 85 dc 23 00 00 	jmp    *0x23dc(,%eax,4)
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
    11e4:	e8 b7 ff ff ff       	call   11a0 <fork1>
    11e9:	85 c0                	test   %eax,%eax
    11eb:	0f 84 c9 00 00 00    	je     12ba <runcmd+0xfa>
  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
      exit();
    11f1:	e8 1c 0c 00 00       	call   1e12 <exit>
    panic("runcmd");

  case EXEC:
		
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
    11f6:	8b 43 04             	mov    0x4(%ebx),%eax
    11f9:	85 c0                	test   %eax,%eax
    11fb:	74 f4                	je     11f1 <runcmd+0x31>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
    11fd:	8d 53 04             	lea    0x4(%ebx),%edx
    1200:	89 54 24 04          	mov    %edx,0x4(%esp)
    1204:	89 04 24             	mov    %eax,(%esp)
    1207:	e8 3e 0c 00 00       	call   1e4a <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    120c:	8b 43 04             	mov    0x4(%ebx),%eax
    120f:	c7 44 24 04 27 23 00 	movl   $0x2327,0x4(%esp)
    1216:	00 
    1217:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    121e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1222:	e8 49 0d 00 00       	call   1f70 <printf>
    break;
    1227:	eb c8                	jmp    11f1 <runcmd+0x31>
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
    1229:	8d 45 f0             	lea    -0x10(%ebp),%eax
    122c:	89 04 24             	mov    %eax,(%esp)
    122f:	e8 ee 0b 00 00       	call   1e22 <pipe>
    1234:	85 c0                	test   %eax,%eax
    1236:	0f 88 b7 00 00 00    	js     12f3 <runcmd+0x133>
      panic("pipe");
    if(fork1() == 0){
    123c:	e8 5f ff ff ff       	call   11a0 <fork1>
    1241:	85 c0                	test   %eax,%eax
    1243:	0f 84 0e 01 00 00    	je     1357 <runcmd+0x197>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
    1249:	e8 52 ff ff ff       	call   11a0 <fork1>
    124e:	85 c0                	test   %eax,%eax
    1250:	0f 84 c9 00 00 00    	je     131f <runcmd+0x15f>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    1256:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1259:	89 04 24             	mov    %eax,(%esp)
    125c:	e8 d9 0b 00 00       	call   1e3a <close>
    close(p[1]);
    1261:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1264:	89 04 24             	mov    %eax,(%esp)
    1267:	e8 ce 0b 00 00       	call   1e3a <close>
    wait();
    126c:	e8 a9 0b 00 00       	call   1e1a <wait>
    wait();
    1271:	e8 a4 0b 00 00       	call   1e1a <wait>
    break;
    1276:	e9 76 ff ff ff       	jmp    11f1 <runcmd+0x31>
    127b:	90                   	nop
    127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
    1280:	e8 1b ff ff ff       	call   11a0 <fork1>
    1285:	85 c0                	test   %eax,%eax
    1287:	74 31                	je     12ba <runcmd+0xfa>
      runcmd(lcmd->left);
    wait();
    1289:	e8 8c 0b 00 00       	call   1e1a <wait>
    runcmd(lcmd->right);
    128e:	8b 43 08             	mov    0x8(%ebx),%eax
    1291:	89 04 24             	mov    %eax,(%esp)
    1294:	e8 27 ff ff ff       	call   11c0 <runcmd>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    1299:	8b 43 14             	mov    0x14(%ebx),%eax
    129c:	89 04 24             	mov    %eax,(%esp)
    129f:	e8 96 0b 00 00       	call   1e3a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    12a4:	8b 43 10             	mov    0x10(%ebx),%eax
    12a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    12ab:	8b 43 08             	mov    0x8(%ebx),%eax
    12ae:	89 04 24             	mov    %eax,(%esp)
    12b1:	e8 9c 0b 00 00       	call   1e52 <open>
    12b6:	85 c0                	test   %eax,%eax
    12b8:	78 45                	js     12ff <runcmd+0x13f>
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    12ba:	8b 43 04             	mov    0x4(%ebx),%eax
    12bd:	89 04 24             	mov    %eax,(%esp)
    12c0:	e8 fb fe ff ff       	call   11c0 <runcmd>

  switch(cmd->type){
	
  default:
		
    panic("runcmd");
    12c5:	c7 04 24 20 23 00 00 	movl   $0x2320,(%esp)
    12cc:	e8 9f fe ff ff       	call   1170 <panic>
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0){
    printf(1,"%d\n", cmd->type);exit();}
    12d1:	a1 00 00 00 00       	mov    0x0,%eax
    12d6:	c7 44 24 04 1c 23 00 	movl   $0x231c,0x4(%esp)
    12dd:	00 
    12de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12e5:	89 44 24 08          	mov    %eax,0x8(%esp)
    12e9:	e8 82 0c 00 00       	call   1f70 <printf>
    12ee:	e8 1f 0b 00 00       	call   1e12 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    12f3:	c7 04 24 47 23 00 00 	movl   $0x2347,(%esp)
    12fa:	e8 71 fe ff ff       	call   1170 <panic>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
    12ff:	8b 43 08             	mov    0x8(%ebx),%eax
    1302:	c7 44 24 04 37 23 00 	movl   $0x2337,0x4(%esp)
    1309:	00 
    130a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1311:	89 44 24 08          	mov    %eax,0x8(%esp)
    1315:	e8 56 0c 00 00       	call   1f70 <printf>
    131a:	e9 d2 fe ff ff       	jmp    11f1 <runcmd+0x31>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
    131f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1326:	e8 0f 0b 00 00       	call   1e3a <close>
      dup(p[0]);
    132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132e:	89 04 24             	mov    %eax,(%esp)
    1331:	e8 54 0b 00 00       	call   1e8a <dup>
      close(p[0]);
    1336:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1339:	89 04 24             	mov    %eax,(%esp)
    133c:	e8 f9 0a 00 00       	call   1e3a <close>
      close(p[1]);
    1341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1344:	89 04 24             	mov    %eax,(%esp)
    1347:	e8 ee 0a 00 00       	call   1e3a <close>
      runcmd(pcmd->right);
    134c:	8b 43 08             	mov    0x8(%ebx),%eax
    134f:	89 04 24             	mov    %eax,(%esp)
    1352:	e8 69 fe ff ff       	call   11c0 <runcmd>
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
    1357:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    135e:	e8 d7 0a 00 00       	call   1e3a <close>
      dup(p[1]);
    1363:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1366:	89 04 24             	mov    %eax,(%esp)
    1369:	e8 1c 0b 00 00       	call   1e8a <dup>
      close(p[0]);
    136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1371:	89 04 24             	mov    %eax,(%esp)
    1374:	e8 c1 0a 00 00       	call   1e3a <close>
      close(p[1]);
    1379:	8b 45 f4             	mov    -0xc(%ebp),%eax
    137c:	89 04 24             	mov    %eax,(%esp)
    137f:	e8 b6 0a 00 00       	call   1e3a <close>
      runcmd(pcmd->left);
    1384:	8b 43 04             	mov    0x4(%ebx),%eax
    1387:	89 04 24             	mov    %eax,(%esp)
    138a:	e8 31 fe ff ff       	call   11c0 <runcmd>
    138f:	90                   	nop

00001390 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    1390:	55                   	push   %ebp
    1391:	89 e5                	mov    %esp,%ebp
    1393:	53                   	push   %ebx
    1394:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1397:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
    139e:	e8 4d 0e 00 00       	call   21f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    13a3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
    13aa:	00 
    13ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13b2:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13b3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    13b5:	89 04 24             	mov    %eax,(%esp)
    13b8:	e8 e3 08 00 00       	call   1ca0 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
    13bd:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
    13bf:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
    13c5:	83 c4 14             	add    $0x14,%esp
    13c8:	5b                   	pop    %ebx
    13c9:	5d                   	pop    %ebp
    13ca:	c3                   	ret    
    13cb:	90                   	nop
    13cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000013d0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	53                   	push   %ebx
    13d4:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13d7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    13de:	e8 0d 0e 00 00       	call   21f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    13e3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
    13ea:	00 
    13eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13f2:	00 
    13f3:	89 04 24             	mov    %eax,(%esp)
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13f6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    13f8:	e8 a3 08 00 00       	call   1ca0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
    13fd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
    1400:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
    1406:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
    1409:	8b 45 0c             	mov    0xc(%ebp),%eax
    140c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
    140f:	8b 45 10             	mov    0x10(%ebp),%eax
    1412:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
    1415:	8b 45 14             	mov    0x14(%ebp),%eax
    1418:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
    141b:	8b 45 18             	mov    0x18(%ebp),%eax
    141e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
    1421:	83 c4 14             	add    $0x14,%esp
    1424:	89 d8                	mov    %ebx,%eax
    1426:	5b                   	pop    %ebx
    1427:	5d                   	pop    %ebp
    1428:	c3                   	ret    
    1429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001430 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	53                   	push   %ebx
    1434:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1437:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    143e:	e8 ad 0d 00 00       	call   21f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    1443:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    144a:	00 
    144b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1452:	00 
    1453:	89 04 24             	mov    %eax,(%esp)
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1456:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1458:	e8 43 08 00 00       	call   1ca0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
    145d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
    1460:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
    1466:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    1469:	8b 45 0c             	mov    0xc(%ebp),%eax
    146c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    146f:	83 c4 14             	add    $0x14,%esp
    1472:	89 d8                	mov    %ebx,%eax
    1474:	5b                   	pop    %ebx
    1475:	5d                   	pop    %ebp
    1476:	c3                   	ret    
    1477:	89 f6                	mov    %esi,%esi
    1479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001480 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    1480:	55                   	push   %ebp
    1481:	89 e5                	mov    %esp,%ebp
    1483:	53                   	push   %ebx
    1484:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1487:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    148e:	e8 5d 0d 00 00       	call   21f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    1493:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    149a:	00 
    149b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14a2:	00 
    14a3:	89 04 24             	mov    %eax,(%esp)
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14a6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    14a8:	e8 f3 07 00 00       	call   1ca0 <memset>
  cmd->type = LIST;
  cmd->left = left;
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
    14b0:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
    14b6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    14b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    14bc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    14bf:	83 c4 14             	add    $0x14,%esp
    14c2:	89 d8                	mov    %ebx,%eax
    14c4:	5b                   	pop    %ebx
    14c5:	5d                   	pop    %ebp
    14c6:	c3                   	ret    
    14c7:	89 f6                	mov    %esi,%esi
    14c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000014d0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    14d0:	55                   	push   %ebp
    14d1:	89 e5                	mov    %esp,%ebp
    14d3:	53                   	push   %ebx
    14d4:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    14de:	e8 0d 0d 00 00       	call   21f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
    14e3:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
    14ea:	00 
    14eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f2:	00 
    14f3:	89 04 24             	mov    %eax,(%esp)
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14f6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    14f8:	e8 a3 07 00 00       	call   1ca0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
    14fd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
    1500:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
    1506:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
    1509:	83 c4 14             	add    $0x14,%esp
    150c:	89 d8                	mov    %ebx,%eax
    150e:	5b                   	pop    %ebx
    150f:	5d                   	pop    %ebp
    1510:	c3                   	ret    
    1511:	eb 0d                	jmp    1520 <gettoken>
    1513:	90                   	nop
    1514:	90                   	nop
    1515:	90                   	nop
    1516:	90                   	nop
    1517:	90                   	nop
    1518:	90                   	nop
    1519:	90                   	nop
    151a:	90                   	nop
    151b:	90                   	nop
    151c:	90                   	nop
    151d:	90                   	nop
    151e:	90                   	nop
    151f:	90                   	nop

00001520 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    1520:	55                   	push   %ebp
    1521:	89 e5                	mov    %esp,%ebp
    1523:	57                   	push   %edi
    1524:	56                   	push   %esi
    1525:	53                   	push   %ebx
    1526:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;

  s = *ps;
    1529:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    152c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    152f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *s;
  int ret;

  s = *ps;
    1532:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
    1534:	39 df                	cmp    %ebx,%edi
    1536:	72 0f                	jb     1547 <gettoken+0x27>
    1538:	eb 24                	jmp    155e <gettoken+0x3e>
    153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
    1540:	83 c7 01             	add    $0x1,%edi
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    1543:	39 df                	cmp    %ebx,%edi
    1545:	74 17                	je     155e <gettoken+0x3e>
    1547:	0f be 07             	movsbl (%edi),%eax
    154a:	c7 04 24 ec 29 00 00 	movl   $0x29ec,(%esp)
    1551:	89 44 24 04          	mov    %eax,0x4(%esp)
    1555:	e8 66 07 00 00       	call   1cc0 <strchr>
    155a:	85 c0                	test   %eax,%eax
    155c:	75 e2                	jne    1540 <gettoken+0x20>
    s++;
  if(q)
    155e:	85 f6                	test   %esi,%esi
    1560:	74 02                	je     1564 <gettoken+0x44>
    *q = s;
    1562:	89 3e                	mov    %edi,(%esi)
  ret = *s;
    1564:	0f b6 0f             	movzbl (%edi),%ecx
    1567:	0f be f1             	movsbl %cl,%esi
  switch(*s){
    156a:	80 f9 29             	cmp    $0x29,%cl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
    156d:	89 f0                	mov    %esi,%eax
  switch(*s){
    156f:	7f 4f                	jg     15c0 <gettoken+0xa0>
    1571:	80 f9 28             	cmp    $0x28,%cl
    1574:	7d 55                	jge    15cb <gettoken+0xab>
    1576:	84 c9                	test   %cl,%cl
    1578:	0f 85 ca 00 00 00    	jne    1648 <gettoken+0x128>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    157e:	8b 45 14             	mov    0x14(%ebp),%eax
    1581:	85 c0                	test   %eax,%eax
    1583:	74 05                	je     158a <gettoken+0x6a>
    *eq = s;
    1585:	8b 45 14             	mov    0x14(%ebp),%eax
    1588:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
    158a:	39 df                	cmp    %ebx,%edi
    158c:	72 09                	jb     1597 <gettoken+0x77>
    158e:	eb 1e                	jmp    15ae <gettoken+0x8e>
    s++;
    1590:	83 c7 01             	add    $0x1,%edi
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    1593:	39 df                	cmp    %ebx,%edi
    1595:	74 17                	je     15ae <gettoken+0x8e>
    1597:	0f be 07             	movsbl (%edi),%eax
    159a:	c7 04 24 ec 29 00 00 	movl   $0x29ec,(%esp)
    15a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a5:	e8 16 07 00 00       	call   1cc0 <strchr>
    15aa:	85 c0                	test   %eax,%eax
    15ac:	75 e2                	jne    1590 <gettoken+0x70>
    s++;
  *ps = s;
    15ae:	8b 45 08             	mov    0x8(%ebp),%eax
    15b1:	89 38                	mov    %edi,(%eax)
  return ret;
}
    15b3:	83 c4 1c             	add    $0x1c,%esp
    15b6:	89 f0                	mov    %esi,%eax
    15b8:	5b                   	pop    %ebx
    15b9:	5e                   	pop    %esi
    15ba:	5f                   	pop    %edi
    15bb:	5d                   	pop    %ebp
    15bc:	c3                   	ret    
    15bd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    15c0:	80 f9 3e             	cmp    $0x3e,%cl
    15c3:	75 0b                	jne    15d0 <gettoken+0xb0>
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
    15c5:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    15c9:	74 6d                	je     1638 <gettoken+0x118>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    15cb:	83 c7 01             	add    $0x1,%edi
    15ce:	eb ae                	jmp    157e <gettoken+0x5e>
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    15d0:	7f 56                	jg     1628 <gettoken+0x108>
    15d2:	83 e9 3b             	sub    $0x3b,%ecx
    15d5:	80 f9 01             	cmp    $0x1,%cl
    15d8:	76 f1                	jbe    15cb <gettoken+0xab>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15da:	39 fb                	cmp    %edi,%ebx
    15dc:	77 2b                	ja     1609 <gettoken+0xe9>
    15de:	66 90                	xchg   %ax,%ax
    15e0:	eb 3b                	jmp    161d <gettoken+0xfd>
    15e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    15e8:	0f be 07             	movsbl (%edi),%eax
    15eb:	c7 04 24 e4 29 00 00 	movl   $0x29e4,(%esp)
    15f2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f6:	e8 c5 06 00 00       	call   1cc0 <strchr>
    15fb:	85 c0                	test   %eax,%eax
    15fd:	75 1e                	jne    161d <gettoken+0xfd>
      s++;
    15ff:	83 c7 01             	add    $0x1,%edi
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    1602:	39 df                	cmp    %ebx,%edi
    1604:	74 17                	je     161d <gettoken+0xfd>
    1606:	0f be 07             	movsbl (%edi),%eax
    1609:	89 44 24 04          	mov    %eax,0x4(%esp)
    160d:	c7 04 24 ec 29 00 00 	movl   $0x29ec,(%esp)
    1614:	e8 a7 06 00 00       	call   1cc0 <strchr>
    1619:	85 c0                	test   %eax,%eax
    161b:	74 cb                	je     15e8 <gettoken+0xc8>
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    161d:	be 61 00 00 00       	mov    $0x61,%esi
    1622:	e9 57 ff ff ff       	jmp    157e <gettoken+0x5e>
    1627:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    1628:	80 f9 7c             	cmp    $0x7c,%cl
    162b:	74 9e                	je     15cb <gettoken+0xab>
    162d:	8d 76 00             	lea    0x0(%esi),%esi
    1630:	eb a8                	jmp    15da <gettoken+0xba>
    1632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    1638:	83 c7 02             	add    $0x2,%edi
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
    163b:	be 2b 00 00 00       	mov    $0x2b,%esi
    1640:	e9 39 ff ff ff       	jmp    157e <gettoken+0x5e>
    1645:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
    1648:	80 f9 26             	cmp    $0x26,%cl
    164b:	75 8d                	jne    15da <gettoken+0xba>
    164d:	e9 79 ff ff ff       	jmp    15cb <gettoken+0xab>
    1652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001660 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
    1660:	55                   	push   %ebp
    1661:	89 e5                	mov    %esp,%ebp
    1663:	57                   	push   %edi
    1664:	56                   	push   %esi
    1665:	53                   	push   %ebx
    1666:	83 ec 1c             	sub    $0x1c,%esp
    1669:	8b 7d 08             	mov    0x8(%ebp),%edi
    166c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
    166f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
    1671:	39 f3                	cmp    %esi,%ebx
    1673:	72 0a                	jb     167f <peek+0x1f>
    1675:	eb 1f                	jmp    1696 <peek+0x36>
    1677:	90                   	nop
    s++;
    1678:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    167b:	39 f3                	cmp    %esi,%ebx
    167d:	74 17                	je     1696 <peek+0x36>
    167f:	0f be 03             	movsbl (%ebx),%eax
    1682:	c7 04 24 ec 29 00 00 	movl   $0x29ec,(%esp)
    1689:	89 44 24 04          	mov    %eax,0x4(%esp)
    168d:	e8 2e 06 00 00       	call   1cc0 <strchr>
    1692:	85 c0                	test   %eax,%eax
    1694:	75 e2                	jne    1678 <peek+0x18>
    s++;
  *ps = s;
    1696:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
    1698:	0f be 13             	movsbl (%ebx),%edx
    169b:	31 c0                	xor    %eax,%eax
    169d:	84 d2                	test   %dl,%dl
    169f:	74 17                	je     16b8 <peek+0x58>
    16a1:	8b 45 10             	mov    0x10(%ebp),%eax
    16a4:	89 54 24 04          	mov    %edx,0x4(%esp)
    16a8:	89 04 24             	mov    %eax,(%esp)
    16ab:	e8 10 06 00 00       	call   1cc0 <strchr>
    16b0:	85 c0                	test   %eax,%eax
    16b2:	0f 95 c0             	setne  %al
    16b5:	0f b6 c0             	movzbl %al,%eax
}
    16b8:	83 c4 1c             	add    $0x1c,%esp
    16bb:	5b                   	pop    %ebx
    16bc:	5e                   	pop    %esi
    16bd:	5f                   	pop    %edi
    16be:	5d                   	pop    %ebp
    16bf:	c3                   	ret    

000016c0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    16c0:	55                   	push   %ebp
    16c1:	89 e5                	mov    %esp,%ebp
    16c3:	57                   	push   %edi
    16c4:	56                   	push   %esi
    16c5:	53                   	push   %ebx
    16c6:	83 ec 3c             	sub    $0x3c,%esp
    16c9:	8b 75 0c             	mov    0xc(%ebp),%esi
    16cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16cf:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    16d0:	c7 44 24 08 69 23 00 	movl   $0x2369,0x8(%esp)
    16d7:	00 
    16d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    16dc:	89 34 24             	mov    %esi,(%esp)
    16df:	e8 7c ff ff ff       	call   1660 <peek>
    16e4:	85 c0                	test   %eax,%eax
    16e6:	0f 84 9c 00 00 00    	je     1788 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
    16ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    16f3:	00 
    16f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    16fb:	00 
    16fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1700:	89 34 24             	mov    %esi,(%esp)
    1703:	e8 18 fe ff ff       	call   1520 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
    1708:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    170c:	89 34 24             	mov    %esi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    170f:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
    1711:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1714:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1718:	8d 45 e0             	lea    -0x20(%ebp),%eax
    171b:	89 44 24 08          	mov    %eax,0x8(%esp)
    171f:	e8 fc fd ff ff       	call   1520 <gettoken>
    1724:	83 f8 61             	cmp    $0x61,%eax
    1727:	75 6a                	jne    1793 <parseredirs+0xd3>
      panic("missing file for redirection");
    switch(tok){
    1729:	83 ff 3c             	cmp    $0x3c,%edi
    172c:	74 42                	je     1770 <parseredirs+0xb0>
    172e:	83 ff 3e             	cmp    $0x3e,%edi
    1731:	74 05                	je     1738 <parseredirs+0x78>
    1733:	83 ff 2b             	cmp    $0x2b,%edi
    1736:	75 98                	jne    16d0 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1738:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    173f:	00 
    1740:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    1747:	00 
    1748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    174b:	89 44 24 08          	mov    %eax,0x8(%esp)
    174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1752:	89 44 24 04          	mov    %eax,0x4(%esp)
    1756:	8b 45 08             	mov    0x8(%ebp),%eax
    1759:	89 04 24             	mov    %eax,(%esp)
    175c:	e8 6f fc ff ff       	call   13d0 <redircmd>
    1761:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    1764:	e9 67 ff ff ff       	jmp    16d0 <parseredirs+0x10>
    1769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    1770:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    1777:	00 
    1778:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    177f:	00 
    1780:	eb c6                	jmp    1748 <parseredirs+0x88>
    1782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
    1788:	8b 45 08             	mov    0x8(%ebp),%eax
    178b:	83 c4 3c             	add    $0x3c,%esp
    178e:	5b                   	pop    %ebx
    178f:	5e                   	pop    %esi
    1790:	5f                   	pop    %edi
    1791:	5d                   	pop    %ebp
    1792:	c3                   	ret    
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    1793:	c7 04 24 4c 23 00 00 	movl   $0x234c,(%esp)
    179a:	e8 d1 f9 ff ff       	call   1170 <panic>
    179f:	90                   	nop

000017a0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
    17a0:	55                   	push   %ebp
    17a1:	89 e5                	mov    %esp,%ebp
    17a3:	57                   	push   %edi
    17a4:	56                   	push   %esi
    17a5:	53                   	push   %ebx
    17a6:	83 ec 3c             	sub    $0x3c,%esp
    17a9:	8b 75 08             	mov    0x8(%ebp),%esi
    17ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    17af:	c7 44 24 08 6c 23 00 	movl   $0x236c,0x8(%esp)
    17b6:	00 
    17b7:	89 34 24             	mov    %esi,(%esp)
    17ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
    17be:	e8 9d fe ff ff       	call   1660 <peek>
    17c3:	85 c0                	test   %eax,%eax
    17c5:	0f 85 a5 00 00 00    	jne    1870 <parseexec+0xd0>
    return parseblock(ps, es);

  ret = execcmd();
    17cb:	e8 c0 fb ff ff       	call   1390 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    17d0:	89 7c 24 08          	mov    %edi,0x8(%esp)
    17d4:	89 74 24 04          	mov    %esi,0x4(%esp)
    17d8:	89 04 24             	mov    %eax,(%esp)
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
    17db:	89 c3                	mov    %eax,%ebx
    17dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    17e0:	e8 db fe ff ff       	call   16c0 <parseredirs>
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
    17e5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  ret = parseredirs(ret, ps, es);
    17ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
    17ef:	eb 1d                	jmp    180e <parseexec+0x6e>
    17f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
    17f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    17fb:	89 7c 24 08          	mov    %edi,0x8(%esp)
    17ff:	89 74 24 04          	mov    %esi,0x4(%esp)
    1803:	89 04 24             	mov    %eax,(%esp)
    1806:	e8 b5 fe ff ff       	call   16c0 <parseredirs>
    180b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    180e:	c7 44 24 08 83 23 00 	movl   $0x2383,0x8(%esp)
    1815:	00 
    1816:	89 7c 24 04          	mov    %edi,0x4(%esp)
    181a:	89 34 24             	mov    %esi,(%esp)
    181d:	e8 3e fe ff ff       	call   1660 <peek>
    1822:	85 c0                	test   %eax,%eax
    1824:	75 62                	jne    1888 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1826:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1829:	89 44 24 0c          	mov    %eax,0xc(%esp)
    182d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1830:	89 44 24 08          	mov    %eax,0x8(%esp)
    1834:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1838:	89 34 24             	mov    %esi,(%esp)
    183b:	e8 e0 fc ff ff       	call   1520 <gettoken>
    1840:	85 c0                	test   %eax,%eax
    1842:	74 44                	je     1888 <parseexec+0xe8>
      break;
    if(tok != 'a')
    1844:	83 f8 61             	cmp    $0x61,%eax
    1847:	75 61                	jne    18aa <parseexec+0x10a>
      panic("syntax");
    cmd->argv[argc] = q;
    1849:	8b 45 e0             	mov    -0x20(%ebp),%eax
    184c:	83 c3 04             	add    $0x4,%ebx
    cmd->eargv[argc] = eq;
    argc++;
    184f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    1853:	89 03                	mov    %eax,(%ebx)
    cmd->eargv[argc] = eq;
    1855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1858:	89 43 28             	mov    %eax,0x28(%ebx)
    argc++;
    if(argc >= MAXARGS)
    185b:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
    185f:	75 97                	jne    17f8 <parseexec+0x58>
      panic("too many args");
    1861:	c7 04 24 75 23 00 00 	movl   $0x2375,(%esp)
    1868:	e8 03 f9 ff ff       	call   1170 <panic>
    186d:	8d 76 00             	lea    0x0(%esi),%esi
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);
    1870:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1874:	89 34 24             	mov    %esi,(%esp)
    1877:	e8 84 01 00 00       	call   1a00 <parseblock>
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
    187c:	83 c4 3c             	add    $0x3c,%esp
    187f:	5b                   	pop    %ebx
    1880:	5e                   	pop    %esi
    1881:	5f                   	pop    %edi
    1882:	5d                   	pop    %ebp
    1883:	c3                   	ret    
    1884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1888:	8b 45 cc             	mov    -0x34(%ebp),%eax
    188b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    188e:	8d 04 90             	lea    (%eax,%edx,4),%eax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
    1891:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
    1898:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
    189f:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
    18a2:	83 c4 3c             	add    $0x3c,%esp
    18a5:	5b                   	pop    %ebx
    18a6:	5e                   	pop    %esi
    18a7:	5f                   	pop    %edi
    18a8:	5d                   	pop    %ebp
    18a9:	c3                   	ret    
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    18aa:	c7 04 24 6e 23 00 00 	movl   $0x236e,(%esp)
    18b1:	e8 ba f8 ff ff       	call   1170 <panic>
    18b6:	8d 76 00             	lea    0x0(%esi),%esi
    18b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000018c0 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
    18c0:	55                   	push   %ebp
    18c1:	89 e5                	mov    %esp,%ebp
    18c3:	57                   	push   %edi
    18c4:	56                   	push   %esi
    18c5:	53                   	push   %ebx
    18c6:	83 ec 1c             	sub    $0x1c,%esp
    18c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    18cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    18cf:	89 1c 24             	mov    %ebx,(%esp)
    18d2:	89 74 24 04          	mov    %esi,0x4(%esp)
    18d6:	e8 c5 fe ff ff       	call   17a0 <parseexec>
  if(peek(ps, es, "|")){
    18db:	c7 44 24 08 88 23 00 	movl   $0x2388,0x8(%esp)
    18e2:	00 
    18e3:	89 74 24 04          	mov    %esi,0x4(%esp)
    18e7:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    18ea:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
    18ec:	e8 6f fd ff ff       	call   1660 <peek>
    18f1:	85 c0                	test   %eax,%eax
    18f3:	75 0b                	jne    1900 <parsepipe+0x40>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
    18f5:	83 c4 1c             	add    $0x1c,%esp
    18f8:	89 f8                	mov    %edi,%eax
    18fa:	5b                   	pop    %ebx
    18fb:	5e                   	pop    %esi
    18fc:	5f                   	pop    %edi
    18fd:	5d                   	pop    %ebp
    18fe:	c3                   	ret    
    18ff:	90                   	nop
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    1900:	89 74 24 04          	mov    %esi,0x4(%esp)
    1904:	89 1c 24             	mov    %ebx,(%esp)
    1907:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    190e:	00 
    190f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1916:	00 
    1917:	e8 04 fc ff ff       	call   1520 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    191c:	89 74 24 04          	mov    %esi,0x4(%esp)
    1920:	89 1c 24             	mov    %ebx,(%esp)
    1923:	e8 98 ff ff ff       	call   18c0 <parsepipe>
    1928:	89 7d 08             	mov    %edi,0x8(%ebp)
    192b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
    192e:	83 c4 1c             	add    $0x1c,%esp
    1931:	5b                   	pop    %ebx
    1932:	5e                   	pop    %esi
    1933:	5f                   	pop    %edi
    1934:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
    1935:	e9 f6 fa ff ff       	jmp    1430 <pipecmd>
    193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001940 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
    1940:	55                   	push   %ebp
    1941:	89 e5                	mov    %esp,%ebp
    1943:	57                   	push   %edi
    1944:	56                   	push   %esi
    1945:	53                   	push   %ebx
    1946:	83 ec 1c             	sub    $0x1c,%esp
    1949:	8b 5d 08             	mov    0x8(%ebp),%ebx
    194c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    194f:	89 1c 24             	mov    %ebx,(%esp)
    1952:	89 74 24 04          	mov    %esi,0x4(%esp)
    1956:	e8 65 ff ff ff       	call   18c0 <parsepipe>
    195b:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
    195d:	eb 27                	jmp    1986 <parseline+0x46>
    195f:	90                   	nop
    gettoken(ps, es, 0, 0);
    1960:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1967:	00 
    1968:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    196f:	00 
    1970:	89 74 24 04          	mov    %esi,0x4(%esp)
    1974:	89 1c 24             	mov    %ebx,(%esp)
    1977:	e8 a4 fb ff ff       	call   1520 <gettoken>
    cmd = backcmd(cmd);
    197c:	89 3c 24             	mov    %edi,(%esp)
    197f:	e8 4c fb ff ff       	call   14d0 <backcmd>
    1984:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    1986:	c7 44 24 08 8a 23 00 	movl   $0x238a,0x8(%esp)
    198d:	00 
    198e:	89 74 24 04          	mov    %esi,0x4(%esp)
    1992:	89 1c 24             	mov    %ebx,(%esp)
    1995:	e8 c6 fc ff ff       	call   1660 <peek>
    199a:	85 c0                	test   %eax,%eax
    199c:	75 c2                	jne    1960 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    199e:	c7 44 24 08 86 23 00 	movl   $0x2386,0x8(%esp)
    19a5:	00 
    19a6:	89 74 24 04          	mov    %esi,0x4(%esp)
    19aa:	89 1c 24             	mov    %ebx,(%esp)
    19ad:	e8 ae fc ff ff       	call   1660 <peek>
    19b2:	85 c0                	test   %eax,%eax
    19b4:	75 0a                	jne    19c0 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
    19b6:	83 c4 1c             	add    $0x1c,%esp
    19b9:	89 f8                	mov    %edi,%eax
    19bb:	5b                   	pop    %ebx
    19bc:	5e                   	pop    %esi
    19bd:	5f                   	pop    %edi
    19be:	5d                   	pop    %ebp
    19bf:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    19c0:	89 74 24 04          	mov    %esi,0x4(%esp)
    19c4:	89 1c 24             	mov    %ebx,(%esp)
    19c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    19ce:	00 
    19cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    19d6:	00 
    19d7:	e8 44 fb ff ff       	call   1520 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    19dc:	89 74 24 04          	mov    %esi,0x4(%esp)
    19e0:	89 1c 24             	mov    %ebx,(%esp)
    19e3:	e8 58 ff ff ff       	call   1940 <parseline>
    19e8:	89 7d 08             	mov    %edi,0x8(%ebp)
    19eb:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
    19ee:	83 c4 1c             	add    $0x1c,%esp
    19f1:	5b                   	pop    %ebx
    19f2:	5e                   	pop    %esi
    19f3:	5f                   	pop    %edi
    19f4:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
    19f5:	e9 86 fa ff ff       	jmp    1480 <listcmd>
    19fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001a00 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
    1a00:	55                   	push   %ebp
    1a01:	89 e5                	mov    %esp,%ebp
    1a03:	57                   	push   %edi
    1a04:	56                   	push   %esi
    1a05:	53                   	push   %ebx
    1a06:	83 ec 1c             	sub    $0x1c,%esp
    1a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    1a0f:	c7 44 24 08 6c 23 00 	movl   $0x236c,0x8(%esp)
    1a16:	00 
    1a17:	89 1c 24             	mov    %ebx,(%esp)
    1a1a:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a1e:	e8 3d fc ff ff       	call   1660 <peek>
    1a23:	85 c0                	test   %eax,%eax
    1a25:	74 76                	je     1a9d <parseblock+0x9d>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
    1a27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a2e:	00 
    1a2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a36:	00 
    1a37:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a3b:	89 1c 24             	mov    %ebx,(%esp)
    1a3e:	e8 dd fa ff ff       	call   1520 <gettoken>
  cmd = parseline(ps, es);
    1a43:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a47:	89 1c 24             	mov    %ebx,(%esp)
    1a4a:	e8 f1 fe ff ff       	call   1940 <parseline>
  if(!peek(ps, es, ")"))
    1a4f:	c7 44 24 08 a8 23 00 	movl   $0x23a8,0x8(%esp)
    1a56:	00 
    1a57:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a5b:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
    1a5e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
    1a60:	e8 fb fb ff ff       	call   1660 <peek>
    1a65:	85 c0                	test   %eax,%eax
    1a67:	74 40                	je     1aa9 <parseblock+0xa9>
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
    1a69:	89 74 24 04          	mov    %esi,0x4(%esp)
    1a6d:	89 1c 24             	mov    %ebx,(%esp)
    1a70:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a77:	00 
    1a78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a7f:	00 
    1a80:	e8 9b fa ff ff       	call   1520 <gettoken>
  cmd = parseredirs(cmd, ps, es);
    1a85:	89 74 24 08          	mov    %esi,0x8(%esp)
    1a89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1a8d:	89 3c 24             	mov    %edi,(%esp)
    1a90:	e8 2b fc ff ff       	call   16c0 <parseredirs>
  return cmd;
}
    1a95:	83 c4 1c             	add    $0x1c,%esp
    1a98:	5b                   	pop    %ebx
    1a99:	5e                   	pop    %esi
    1a9a:	5f                   	pop    %edi
    1a9b:	5d                   	pop    %ebp
    1a9c:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
    1a9d:	c7 04 24 8c 23 00 00 	movl   $0x238c,(%esp)
    1aa4:	e8 c7 f6 ff ff       	call   1170 <panic>
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
    1aa9:	c7 04 24 97 23 00 00 	movl   $0x2397,(%esp)
    1ab0:	e8 bb f6 ff ff       	call   1170 <panic>
    1ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001ac0 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    1ac0:	55                   	push   %ebp
    1ac1:	89 e5                	mov    %esp,%ebp
    1ac3:	53                   	push   %ebx
    1ac4:	83 ec 14             	sub    $0x14,%esp
    1ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1aca:	85 db                	test   %ebx,%ebx
    1acc:	0f 84 8e 00 00 00    	je     1b60 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
    1ad2:	83 3b 05             	cmpl   $0x5,(%ebx)
    1ad5:	77 49                	ja     1b20 <nulterminate+0x60>
    1ad7:	8b 03                	mov    (%ebx),%eax
    1ad9:	ff 24 85 f4 23 00 00 	jmp    *0x23f4(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    1ae0:	8b 43 04             	mov    0x4(%ebx),%eax
    1ae3:	89 04 24             	mov    %eax,(%esp)
    1ae6:	e8 d5 ff ff ff       	call   1ac0 <nulterminate>
    nulterminate(lcmd->right);
    1aeb:	8b 43 08             	mov    0x8(%ebx),%eax
    1aee:	89 04 24             	mov    %eax,(%esp)
    1af1:	e8 ca ff ff ff       	call   1ac0 <nulterminate>
    break;
    1af6:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1af8:	83 c4 14             	add    $0x14,%esp
    1afb:	5b                   	pop    %ebx
    1afc:	5d                   	pop    %ebp
    1afd:	c3                   	ret    
    1afe:	66 90                	xchg   %ax,%ax
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1b00:	8b 4b 04             	mov    0x4(%ebx),%ecx
    1b03:	89 d8                	mov    %ebx,%eax
    1b05:	85 c9                	test   %ecx,%ecx
    1b07:	74 17                	je     1b20 <nulterminate+0x60>
    1b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    1b10:	8b 50 2c             	mov    0x2c(%eax),%edx
    1b13:	83 c0 04             	add    $0x4,%eax
    1b16:	c6 02 00             	movb   $0x0,(%edx)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1b19:	8b 50 04             	mov    0x4(%eax),%edx
    1b1c:	85 d2                	test   %edx,%edx
    1b1e:	75 f0                	jne    1b10 <nulterminate+0x50>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b20:	83 c4 14             	add    $0x14,%esp
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
    1b23:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b25:	5b                   	pop    %ebx
    1b26:	5d                   	pop    %ebp
    1b27:	c3                   	ret    
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    1b28:	8b 43 04             	mov    0x4(%ebx),%eax
    1b2b:	89 04 24             	mov    %eax,(%esp)
    1b2e:	e8 8d ff ff ff       	call   1ac0 <nulterminate>
    break;
  }
  return cmd;
}
    1b33:	83 c4 14             	add    $0x14,%esp
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
    1b36:	89 d8                	mov    %ebx,%eax
  }
  return cmd;
}
    1b38:	5b                   	pop    %ebx
    1b39:	5d                   	pop    %ebp
    1b3a:	c3                   	ret    
    1b3b:	90                   	nop
    1b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    1b40:	8b 43 04             	mov    0x4(%ebx),%eax
    1b43:	89 04 24             	mov    %eax,(%esp)
    1b46:	e8 75 ff ff ff       	call   1ac0 <nulterminate>
    *rcmd->efile = 0;
    1b4b:	8b 43 0c             	mov    0xc(%ebx),%eax
    1b4e:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b51:	83 c4 14             	add    $0x14,%esp

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;
    1b54:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1b56:	5b                   	pop    %ebx
    1b57:	5d                   	pop    %ebp
    1b58:	c3                   	ret    
    1b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
    1b60:	31 c0                	xor    %eax,%eax
    1b62:	eb 94                	jmp    1af8 <nulterminate+0x38>
    1b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001b70 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    1b70:	55                   	push   %ebp
    1b71:	89 e5                	mov    %esp,%ebp
    1b73:	56                   	push   %esi
    1b74:	53                   	push   %ebx
    1b75:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    1b78:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1b7b:	89 1c 24             	mov    %ebx,(%esp)
    1b7e:	e8 ed 00 00 00       	call   1c70 <strlen>
    1b83:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
    1b85:	8d 45 08             	lea    0x8(%ebp),%eax
    1b88:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1b8c:	89 04 24             	mov    %eax,(%esp)
    1b8f:	e8 ac fd ff ff       	call   1940 <parseline>
  peek(&s, es, "");
    1b94:	c7 44 24 08 1f 23 00 	movl   $0x231f,0x8(%esp)
    1b9b:	00 
    1b9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
    1ba0:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
    1ba2:	8d 45 08             	lea    0x8(%ebp),%eax
    1ba5:	89 04 24             	mov    %eax,(%esp)
    1ba8:	e8 b3 fa ff ff       	call   1660 <peek>
  if(s != es){
    1bad:	8b 45 08             	mov    0x8(%ebp),%eax
    1bb0:	39 d8                	cmp    %ebx,%eax
    1bb2:	75 11                	jne    1bc5 <parsecmd+0x55>
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
    1bb4:	89 34 24             	mov    %esi,(%esp)
    1bb7:	e8 04 ff ff ff       	call   1ac0 <nulterminate>
  return cmd;
}
    1bbc:	83 c4 10             	add    $0x10,%esp
    1bbf:	89 f0                	mov    %esi,%eax
    1bc1:	5b                   	pop    %ebx
    1bc2:	5e                   	pop    %esi
    1bc3:	5d                   	pop    %ebp
    1bc4:	c3                   	ret    

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    1bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
    1bc9:	c7 44 24 04 aa 23 00 	movl   $0x23aa,0x4(%esp)
    1bd0:	00 
    1bd1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1bd8:	e8 93 03 00 00       	call   1f70 <printf>
    panic("syntax");
    1bdd:	c7 04 24 6e 23 00 00 	movl   $0x236e,(%esp)
    1be4:	e8 87 f5 ff ff       	call   1170 <panic>
    1be9:	66 90                	xchg   %ax,%ax
    1beb:	66 90                	xchg   %ax,%ax
    1bed:	66 90                	xchg   %ax,%ax
    1bef:	90                   	nop

00001bf0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1bf0:	55                   	push   %ebp
    1bf1:	89 e5                	mov    %esp,%ebp
    1bf3:	8b 45 08             	mov    0x8(%ebp),%eax
    1bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1bf9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1bfa:	89 c2                	mov    %eax,%edx
    1bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1c00:	83 c1 01             	add    $0x1,%ecx
    1c03:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1c07:	83 c2 01             	add    $0x1,%edx
    1c0a:	84 db                	test   %bl,%bl
    1c0c:	88 5a ff             	mov    %bl,-0x1(%edx)
    1c0f:	75 ef                	jne    1c00 <strcpy+0x10>
    ;
  return os;
}
    1c11:	5b                   	pop    %ebx
    1c12:	5d                   	pop    %ebp
    1c13:	c3                   	ret    
    1c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001c20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1c20:	55                   	push   %ebp
    1c21:	89 e5                	mov    %esp,%ebp
    1c23:	8b 55 08             	mov    0x8(%ebp),%edx
    1c26:	53                   	push   %ebx
    1c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    1c2a:	0f b6 02             	movzbl (%edx),%eax
    1c2d:	84 c0                	test   %al,%al
    1c2f:	74 2d                	je     1c5e <strcmp+0x3e>
    1c31:	0f b6 19             	movzbl (%ecx),%ebx
    1c34:	38 d8                	cmp    %bl,%al
    1c36:	74 0e                	je     1c46 <strcmp+0x26>
    1c38:	eb 2b                	jmp    1c65 <strcmp+0x45>
    1c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1c40:	38 c8                	cmp    %cl,%al
    1c42:	75 15                	jne    1c59 <strcmp+0x39>
    p++, q++;
    1c44:	89 d9                	mov    %ebx,%ecx
    1c46:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c49:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    1c4c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c4f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    1c53:	84 c0                	test   %al,%al
    1c55:	75 e9                	jne    1c40 <strcmp+0x20>
    1c57:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1c59:	29 c8                	sub    %ecx,%eax
}
    1c5b:	5b                   	pop    %ebx
    1c5c:	5d                   	pop    %ebp
    1c5d:	c3                   	ret    
    1c5e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1c61:	31 c0                	xor    %eax,%eax
    1c63:	eb f4                	jmp    1c59 <strcmp+0x39>
    1c65:	0f b6 cb             	movzbl %bl,%ecx
    1c68:	eb ef                	jmp    1c59 <strcmp+0x39>
    1c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001c70 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    1c70:	55                   	push   %ebp
    1c71:	89 e5                	mov    %esp,%ebp
    1c73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1c76:	80 39 00             	cmpb   $0x0,(%ecx)
    1c79:	74 12                	je     1c8d <strlen+0x1d>
    1c7b:	31 d2                	xor    %edx,%edx
    1c7d:	8d 76 00             	lea    0x0(%esi),%esi
    1c80:	83 c2 01             	add    $0x1,%edx
    1c83:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1c87:	89 d0                	mov    %edx,%eax
    1c89:	75 f5                	jne    1c80 <strlen+0x10>
    ;
  return n;
}
    1c8b:	5d                   	pop    %ebp
    1c8c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    1c8d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    1c8f:	5d                   	pop    %ebp
    1c90:	c3                   	ret    
    1c91:	eb 0d                	jmp    1ca0 <memset>
    1c93:	90                   	nop
    1c94:	90                   	nop
    1c95:	90                   	nop
    1c96:	90                   	nop
    1c97:	90                   	nop
    1c98:	90                   	nop
    1c99:	90                   	nop
    1c9a:	90                   	nop
    1c9b:	90                   	nop
    1c9c:	90                   	nop
    1c9d:	90                   	nop
    1c9e:	90                   	nop
    1c9f:	90                   	nop

00001ca0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1ca0:	55                   	push   %ebp
    1ca1:	89 e5                	mov    %esp,%ebp
    1ca3:	8b 55 08             	mov    0x8(%ebp),%edx
    1ca6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1caa:	8b 45 0c             	mov    0xc(%ebp),%eax
    1cad:	89 d7                	mov    %edx,%edi
    1caf:	fc                   	cld    
    1cb0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1cb2:	89 d0                	mov    %edx,%eax
    1cb4:	5f                   	pop    %edi
    1cb5:	5d                   	pop    %ebp
    1cb6:	c3                   	ret    
    1cb7:	89 f6                	mov    %esi,%esi
    1cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001cc0 <strchr>:

char*
strchr(const char *s, char c)
{
    1cc0:	55                   	push   %ebp
    1cc1:	89 e5                	mov    %esp,%ebp
    1cc3:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc6:	53                   	push   %ebx
    1cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    1cca:	0f b6 18             	movzbl (%eax),%ebx
    1ccd:	84 db                	test   %bl,%bl
    1ccf:	74 1d                	je     1cee <strchr+0x2e>
    if(*s == c)
    1cd1:	38 d3                	cmp    %dl,%bl
    1cd3:	89 d1                	mov    %edx,%ecx
    1cd5:	75 0d                	jne    1ce4 <strchr+0x24>
    1cd7:	eb 17                	jmp    1cf0 <strchr+0x30>
    1cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1ce0:	38 ca                	cmp    %cl,%dl
    1ce2:	74 0c                	je     1cf0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1ce4:	83 c0 01             	add    $0x1,%eax
    1ce7:	0f b6 10             	movzbl (%eax),%edx
    1cea:	84 d2                	test   %dl,%dl
    1cec:	75 f2                	jne    1ce0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    1cee:	31 c0                	xor    %eax,%eax
}
    1cf0:	5b                   	pop    %ebx
    1cf1:	5d                   	pop    %ebp
    1cf2:	c3                   	ret    
    1cf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001d00 <gets>:

char*
gets(char *buf, int max)
{
    1d00:	55                   	push   %ebp
    1d01:	89 e5                	mov    %esp,%ebp
    1d03:	57                   	push   %edi
    1d04:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d05:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1d07:	53                   	push   %ebx
    1d08:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1d0b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d0e:	eb 31                	jmp    1d41 <gets+0x41>
    cc = read(0, &c, 1);
    1d10:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1d17:	00 
    1d18:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1d1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1d23:	e8 02 01 00 00       	call   1e2a <read>
    if(cc < 1)
    1d28:	85 c0                	test   %eax,%eax
    1d2a:	7e 1d                	jle    1d49 <gets+0x49>
      break;
    buf[i++] = c;
    1d2c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d30:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1d32:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    1d35:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1d37:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    1d3b:	74 0c                	je     1d49 <gets+0x49>
    1d3d:	3c 0a                	cmp    $0xa,%al
    1d3f:	74 08                	je     1d49 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1d41:	8d 5e 01             	lea    0x1(%esi),%ebx
    1d44:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1d47:	7c c7                	jl     1d10 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1d49:	8b 45 08             	mov    0x8(%ebp),%eax
    1d4c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1d50:	83 c4 2c             	add    $0x2c,%esp
    1d53:	5b                   	pop    %ebx
    1d54:	5e                   	pop    %esi
    1d55:	5f                   	pop    %edi
    1d56:	5d                   	pop    %ebp
    1d57:	c3                   	ret    
    1d58:	90                   	nop
    1d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001d60 <stat>:

int
stat(char *n, struct stat *st)
{
    1d60:	55                   	push   %ebp
    1d61:	89 e5                	mov    %esp,%ebp
    1d63:	56                   	push   %esi
    1d64:	53                   	push   %ebx
    1d65:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1d68:	8b 45 08             	mov    0x8(%ebp),%eax
    1d6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1d72:	00 
    1d73:	89 04 24             	mov    %eax,(%esp)
    1d76:	e8 d7 00 00 00       	call   1e52 <open>
  if(fd < 0)
    1d7b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1d7d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    1d7f:	78 27                	js     1da8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1d81:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d84:	89 1c 24             	mov    %ebx,(%esp)
    1d87:	89 44 24 04          	mov    %eax,0x4(%esp)
    1d8b:	e8 da 00 00 00       	call   1e6a <fstat>
  close(fd);
    1d90:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    1d93:	89 c6                	mov    %eax,%esi
  close(fd);
    1d95:	e8 a0 00 00 00       	call   1e3a <close>
  return r;
    1d9a:	89 f0                	mov    %esi,%eax
}
    1d9c:	83 c4 10             	add    $0x10,%esp
    1d9f:	5b                   	pop    %ebx
    1da0:	5e                   	pop    %esi
    1da1:	5d                   	pop    %ebp
    1da2:	c3                   	ret    
    1da3:	90                   	nop
    1da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1dad:	eb ed                	jmp    1d9c <stat+0x3c>
    1daf:	90                   	nop

00001db0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    1db0:	55                   	push   %ebp
    1db1:	89 e5                	mov    %esp,%ebp
    1db3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1db6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1db7:	0f be 11             	movsbl (%ecx),%edx
    1dba:	8d 42 d0             	lea    -0x30(%edx),%eax
    1dbd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    1dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1dc4:	77 17                	ja     1ddd <atoi+0x2d>
    1dc6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1dc8:	83 c1 01             	add    $0x1,%ecx
    1dcb:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1dce:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1dd2:	0f be 11             	movsbl (%ecx),%edx
    1dd5:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1dd8:	80 fb 09             	cmp    $0x9,%bl
    1ddb:	76 eb                	jbe    1dc8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    1ddd:	5b                   	pop    %ebx
    1dde:	5d                   	pop    %ebp
    1ddf:	c3                   	ret    

00001de0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1de0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1de1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    1de3:	89 e5                	mov    %esp,%ebp
    1de5:	56                   	push   %esi
    1de6:	8b 45 08             	mov    0x8(%ebp),%eax
    1de9:	53                   	push   %ebx
    1dea:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1ded:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1df0:	85 db                	test   %ebx,%ebx
    1df2:	7e 12                	jle    1e06 <memmove+0x26>
    1df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1df8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1dfc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1dff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1e02:	39 da                	cmp    %ebx,%edx
    1e04:	75 f2                	jne    1df8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1e06:	5b                   	pop    %ebx
    1e07:	5e                   	pop    %esi
    1e08:	5d                   	pop    %ebp
    1e09:	c3                   	ret    

00001e0a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1e0a:	b8 01 00 00 00       	mov    $0x1,%eax
    1e0f:	cd 40                	int    $0x40
    1e11:	c3                   	ret    

00001e12 <exit>:
SYSCALL(exit)
    1e12:	b8 02 00 00 00       	mov    $0x2,%eax
    1e17:	cd 40                	int    $0x40
    1e19:	c3                   	ret    

00001e1a <wait>:
SYSCALL(wait)
    1e1a:	b8 03 00 00 00       	mov    $0x3,%eax
    1e1f:	cd 40                	int    $0x40
    1e21:	c3                   	ret    

00001e22 <pipe>:
SYSCALL(pipe)
    1e22:	b8 04 00 00 00       	mov    $0x4,%eax
    1e27:	cd 40                	int    $0x40
    1e29:	c3                   	ret    

00001e2a <read>:
SYSCALL(read)
    1e2a:	b8 05 00 00 00       	mov    $0x5,%eax
    1e2f:	cd 40                	int    $0x40
    1e31:	c3                   	ret    

00001e32 <write>:
SYSCALL(write)
    1e32:	b8 10 00 00 00       	mov    $0x10,%eax
    1e37:	cd 40                	int    $0x40
    1e39:	c3                   	ret    

00001e3a <close>:
SYSCALL(close)
    1e3a:	b8 15 00 00 00       	mov    $0x15,%eax
    1e3f:	cd 40                	int    $0x40
    1e41:	c3                   	ret    

00001e42 <kill>:
SYSCALL(kill)
    1e42:	b8 06 00 00 00       	mov    $0x6,%eax
    1e47:	cd 40                	int    $0x40
    1e49:	c3                   	ret    

00001e4a <exec>:
SYSCALL(exec)
    1e4a:	b8 07 00 00 00       	mov    $0x7,%eax
    1e4f:	cd 40                	int    $0x40
    1e51:	c3                   	ret    

00001e52 <open>:
SYSCALL(open)
    1e52:	b8 0f 00 00 00       	mov    $0xf,%eax
    1e57:	cd 40                	int    $0x40
    1e59:	c3                   	ret    

00001e5a <mknod>:
SYSCALL(mknod)
    1e5a:	b8 11 00 00 00       	mov    $0x11,%eax
    1e5f:	cd 40                	int    $0x40
    1e61:	c3                   	ret    

00001e62 <unlink>:
SYSCALL(unlink)
    1e62:	b8 12 00 00 00       	mov    $0x12,%eax
    1e67:	cd 40                	int    $0x40
    1e69:	c3                   	ret    

00001e6a <fstat>:
SYSCALL(fstat)
    1e6a:	b8 08 00 00 00       	mov    $0x8,%eax
    1e6f:	cd 40                	int    $0x40
    1e71:	c3                   	ret    

00001e72 <link>:
SYSCALL(link)
    1e72:	b8 13 00 00 00       	mov    $0x13,%eax
    1e77:	cd 40                	int    $0x40
    1e79:	c3                   	ret    

00001e7a <mkdir>:
SYSCALL(mkdir)
    1e7a:	b8 14 00 00 00       	mov    $0x14,%eax
    1e7f:	cd 40                	int    $0x40
    1e81:	c3                   	ret    

00001e82 <chdir>:
SYSCALL(chdir)
    1e82:	b8 09 00 00 00       	mov    $0x9,%eax
    1e87:	cd 40                	int    $0x40
    1e89:	c3                   	ret    

00001e8a <dup>:
SYSCALL(dup)
    1e8a:	b8 0a 00 00 00       	mov    $0xa,%eax
    1e8f:	cd 40                	int    $0x40
    1e91:	c3                   	ret    

00001e92 <getpid>:
SYSCALL(getpid)
    1e92:	b8 0b 00 00 00       	mov    $0xb,%eax
    1e97:	cd 40                	int    $0x40
    1e99:	c3                   	ret    

00001e9a <sbrk>:
SYSCALL(sbrk)
    1e9a:	b8 0c 00 00 00       	mov    $0xc,%eax
    1e9f:	cd 40                	int    $0x40
    1ea1:	c3                   	ret    

00001ea2 <sleep>:
SYSCALL(sleep)
    1ea2:	b8 0d 00 00 00       	mov    $0xd,%eax
    1ea7:	cd 40                	int    $0x40
    1ea9:	c3                   	ret    

00001eaa <uptime>:
SYSCALL(uptime)
    1eaa:	b8 0e 00 00 00       	mov    $0xe,%eax
    1eaf:	cd 40                	int    $0x40
    1eb1:	c3                   	ret    

00001eb2 <shm_open>:
SYSCALL(shm_open)
    1eb2:	b8 16 00 00 00       	mov    $0x16,%eax
    1eb7:	cd 40                	int    $0x40
    1eb9:	c3                   	ret    

00001eba <shm_close>:
SYSCALL(shm_close)	
    1eba:	b8 17 00 00 00       	mov    $0x17,%eax
    1ebf:	cd 40                	int    $0x40
    1ec1:	c3                   	ret    
    1ec2:	66 90                	xchg   %ax,%ax
    1ec4:	66 90                	xchg   %ax,%ax
    1ec6:	66 90                	xchg   %ax,%ax
    1ec8:	66 90                	xchg   %ax,%ax
    1eca:	66 90                	xchg   %ax,%ax
    1ecc:	66 90                	xchg   %ax,%ax
    1ece:	66 90                	xchg   %ax,%ax

00001ed0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1ed0:	55                   	push   %ebp
    1ed1:	89 e5                	mov    %esp,%ebp
    1ed3:	57                   	push   %edi
    1ed4:	56                   	push   %esi
    1ed5:	89 c6                	mov    %eax,%esi
    1ed7:	53                   	push   %ebx
    1ed8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1ede:	85 db                	test   %ebx,%ebx
    1ee0:	74 09                	je     1eeb <printint+0x1b>
    1ee2:	89 d0                	mov    %edx,%eax
    1ee4:	c1 e8 1f             	shr    $0x1f,%eax
    1ee7:	84 c0                	test   %al,%al
    1ee9:	75 75                	jne    1f60 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1eeb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1eed:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1ef4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1ef7:	31 ff                	xor    %edi,%edi
    1ef9:	89 ce                	mov    %ecx,%esi
    1efb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1efe:	eb 02                	jmp    1f02 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    1f00:	89 cf                	mov    %ecx,%edi
    1f02:	31 d2                	xor    %edx,%edx
    1f04:	f7 f6                	div    %esi
    1f06:	8d 4f 01             	lea    0x1(%edi),%ecx
    1f09:	0f b6 92 13 24 00 00 	movzbl 0x2413(%edx),%edx
  }while((x /= base) != 0);
    1f10:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1f12:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    1f15:	75 e9                	jne    1f00 <printint+0x30>
  if(neg)
    1f17:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1f1a:	89 c8                	mov    %ecx,%eax
    1f1c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    1f1f:	85 d2                	test   %edx,%edx
    1f21:	74 08                	je     1f2b <printint+0x5b>
    buf[i++] = '-';
    1f23:	8d 4f 02             	lea    0x2(%edi),%ecx
    1f26:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    1f2b:	8d 79 ff             	lea    -0x1(%ecx),%edi
    1f2e:	66 90                	xchg   %ax,%ax
    1f30:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    1f35:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1f38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1f3f:	00 
    1f40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1f44:	89 34 24             	mov    %esi,(%esp)
    1f47:	88 45 d7             	mov    %al,-0x29(%ebp)
    1f4a:	e8 e3 fe ff ff       	call   1e32 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1f4f:	83 ff ff             	cmp    $0xffffffff,%edi
    1f52:	75 dc                	jne    1f30 <printint+0x60>
    putc(fd, buf[i]);
}
    1f54:	83 c4 4c             	add    $0x4c,%esp
    1f57:	5b                   	pop    %ebx
    1f58:	5e                   	pop    %esi
    1f59:	5f                   	pop    %edi
    1f5a:	5d                   	pop    %ebp
    1f5b:	c3                   	ret    
    1f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1f60:	89 d0                	mov    %edx,%eax
    1f62:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    1f64:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    1f6b:	eb 87                	jmp    1ef4 <printint+0x24>
    1f6d:	8d 76 00             	lea    0x0(%esi),%esi

00001f70 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f70:	55                   	push   %ebp
    1f71:	89 e5                	mov    %esp,%ebp
    1f73:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1f74:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f76:	56                   	push   %esi
    1f77:	53                   	push   %ebx
    1f78:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1f7b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1f7e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1f81:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1f84:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1f87:	0f b6 13             	movzbl (%ebx),%edx
    1f8a:	83 c3 01             	add    $0x1,%ebx
    1f8d:	84 d2                	test   %dl,%dl
    1f8f:	75 39                	jne    1fca <printf+0x5a>
    1f91:	e9 c2 00 00 00       	jmp    2058 <printf+0xe8>
    1f96:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1f98:	83 fa 25             	cmp    $0x25,%edx
    1f9b:	0f 84 bf 00 00 00    	je     2060 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1fa1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1fa4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1fab:	00 
    1fac:	89 44 24 04          	mov    %eax,0x4(%esp)
    1fb0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1fb3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1fb6:	e8 77 fe ff ff       	call   1e32 <write>
    1fbb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1fbe:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1fc2:	84 d2                	test   %dl,%dl
    1fc4:	0f 84 8e 00 00 00    	je     2058 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    1fca:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1fcc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    1fcf:	74 c7                	je     1f98 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1fd1:	83 ff 25             	cmp    $0x25,%edi
    1fd4:	75 e5                	jne    1fbb <printf+0x4b>
      if(c == 'd'){
    1fd6:	83 fa 64             	cmp    $0x64,%edx
    1fd9:	0f 84 31 01 00 00    	je     2110 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1fdf:	25 f7 00 00 00       	and    $0xf7,%eax
    1fe4:	83 f8 70             	cmp    $0x70,%eax
    1fe7:	0f 84 83 00 00 00    	je     2070 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1fed:	83 fa 73             	cmp    $0x73,%edx
    1ff0:	0f 84 a2 00 00 00    	je     2098 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1ff6:	83 fa 63             	cmp    $0x63,%edx
    1ff9:	0f 84 35 01 00 00    	je     2134 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1fff:	83 fa 25             	cmp    $0x25,%edx
    2002:	0f 84 e0 00 00 00    	je     20e8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2008:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    200b:	83 c3 01             	add    $0x1,%ebx
    200e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2015:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2016:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2018:	89 44 24 04          	mov    %eax,0x4(%esp)
    201c:	89 34 24             	mov    %esi,(%esp)
    201f:	89 55 d0             	mov    %edx,-0x30(%ebp)
    2022:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    2026:	e8 07 fe ff ff       	call   1e32 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    202b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    202e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    2031:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2038:	00 
    2039:	89 44 24 04          	mov    %eax,0x4(%esp)
    203d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    2040:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2043:	e8 ea fd ff ff       	call   1e32 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2048:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    204c:	84 d2                	test   %dl,%dl
    204e:	0f 85 76 ff ff ff    	jne    1fca <printf+0x5a>
    2054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    2058:	83 c4 3c             	add    $0x3c,%esp
    205b:	5b                   	pop    %ebx
    205c:	5e                   	pop    %esi
    205d:	5f                   	pop    %edi
    205e:	5d                   	pop    %ebp
    205f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    2060:	bf 25 00 00 00       	mov    $0x25,%edi
    2065:	e9 51 ff ff ff       	jmp    1fbb <printf+0x4b>
    206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2070:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2073:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2078:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    207a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2081:	8b 10                	mov    (%eax),%edx
    2083:	89 f0                	mov    %esi,%eax
    2085:	e8 46 fe ff ff       	call   1ed0 <printint>
        ap++;
    208a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    208e:	e9 28 ff ff ff       	jmp    1fbb <printf+0x4b>
    2093:	90                   	nop
    2094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    2098:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    209b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    209f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    20a1:	b8 0c 24 00 00       	mov    $0x240c,%eax
    20a6:	85 ff                	test   %edi,%edi
    20a8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    20ab:	0f b6 07             	movzbl (%edi),%eax
    20ae:	84 c0                	test   %al,%al
    20b0:	74 2a                	je     20dc <printf+0x16c>
    20b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    20b8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20bb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    20be:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20c8:	00 
    20c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    20cd:	89 34 24             	mov    %esi,(%esp)
    20d0:	e8 5d fd ff ff       	call   1e32 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    20d5:	0f b6 07             	movzbl (%edi),%eax
    20d8:	84 c0                	test   %al,%al
    20da:	75 dc                	jne    20b8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    20dc:	31 ff                	xor    %edi,%edi
    20de:	e9 d8 fe ff ff       	jmp    1fbb <printf+0x4b>
    20e3:	90                   	nop
    20e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20e8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    20eb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    20ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    20f4:	00 
    20f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    20f9:	89 34 24             	mov    %esi,(%esp)
    20fc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    2100:	e8 2d fd ff ff       	call   1e32 <write>
    2105:	e9 b1 fe ff ff       	jmp    1fbb <printf+0x4b>
    210a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    2110:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2113:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2118:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    211b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2122:	8b 10                	mov    (%eax),%edx
    2124:	89 f0                	mov    %esi,%eax
    2126:	e8 a5 fd ff ff       	call   1ed0 <printint>
        ap++;
    212b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    212f:	e9 87 fe ff ff       	jmp    1fbb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2134:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2137:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2139:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    213b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2142:	00 
    2143:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    2146:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2149:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    214c:	89 44 24 04          	mov    %eax,0x4(%esp)
    2150:	e8 dd fc ff ff       	call   1e32 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    2155:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    2159:	e9 5d fe ff ff       	jmp    1fbb <printf+0x4b>
    215e:	66 90                	xchg   %ax,%ax

00002160 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2160:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2161:	a1 64 2a 00 00       	mov    0x2a64,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    2166:	89 e5                	mov    %esp,%ebp
    2168:	57                   	push   %edi
    2169:	56                   	push   %esi
    216a:	53                   	push   %ebx
    216b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    216e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2170:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2173:	39 d0                	cmp    %edx,%eax
    2175:	72 11                	jb     2188 <free+0x28>
    2177:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2178:	39 c8                	cmp    %ecx,%eax
    217a:	72 04                	jb     2180 <free+0x20>
    217c:	39 ca                	cmp    %ecx,%edx
    217e:	72 10                	jb     2190 <free+0x30>
    2180:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2182:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2184:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2186:	73 f0                	jae    2178 <free+0x18>
    2188:	39 ca                	cmp    %ecx,%edx
    218a:	72 04                	jb     2190 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    218c:	39 c8                	cmp    %ecx,%eax
    218e:	72 f0                	jb     2180 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2190:	8b 73 fc             	mov    -0x4(%ebx),%esi
    2193:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    2196:	39 cf                	cmp    %ecx,%edi
    2198:	74 1e                	je     21b8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    219a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    219d:	8b 48 04             	mov    0x4(%eax),%ecx
    21a0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    21a3:	39 f2                	cmp    %esi,%edx
    21a5:	74 28                	je     21cf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    21a7:	89 10                	mov    %edx,(%eax)
  freep = p;
    21a9:	a3 64 2a 00 00       	mov    %eax,0x2a64
}
    21ae:	5b                   	pop    %ebx
    21af:	5e                   	pop    %esi
    21b0:	5f                   	pop    %edi
    21b1:	5d                   	pop    %ebp
    21b2:	c3                   	ret    
    21b3:	90                   	nop
    21b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    21b8:	03 71 04             	add    0x4(%ecx),%esi
    21bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    21be:	8b 08                	mov    (%eax),%ecx
    21c0:	8b 09                	mov    (%ecx),%ecx
    21c2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    21c5:	8b 48 04             	mov    0x4(%eax),%ecx
    21c8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    21cb:	39 f2                	cmp    %esi,%edx
    21cd:	75 d8                	jne    21a7 <free+0x47>
    p->s.size += bp->s.size;
    21cf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    21d2:	a3 64 2a 00 00       	mov    %eax,0x2a64
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    21d7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    21da:	8b 53 f8             	mov    -0x8(%ebx),%edx
    21dd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    21df:	5b                   	pop    %ebx
    21e0:	5e                   	pop    %esi
    21e1:	5f                   	pop    %edi
    21e2:	5d                   	pop    %ebp
    21e3:	c3                   	ret    
    21e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    21ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000021f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    21f0:	55                   	push   %ebp
    21f1:	89 e5                	mov    %esp,%ebp
    21f3:	57                   	push   %edi
    21f4:	56                   	push   %esi
    21f5:	53                   	push   %ebx
    21f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    21f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    21fc:	8b 1d 64 2a 00 00    	mov    0x2a64,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2202:	8d 48 07             	lea    0x7(%eax),%ecx
    2205:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    2208:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    220a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    220d:	0f 84 9b 00 00 00    	je     22ae <malloc+0xbe>
    2213:	8b 13                	mov    (%ebx),%edx
    2215:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    2218:	39 fe                	cmp    %edi,%esi
    221a:	76 64                	jbe    2280 <malloc+0x90>
    221c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    2223:	bb 00 80 00 00       	mov    $0x8000,%ebx
    2228:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    222b:	eb 0e                	jmp    223b <malloc+0x4b>
    222d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2230:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    2232:	8b 78 04             	mov    0x4(%eax),%edi
    2235:	39 fe                	cmp    %edi,%esi
    2237:	76 4f                	jbe    2288 <malloc+0x98>
    2239:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    223b:	3b 15 64 2a 00 00    	cmp    0x2a64,%edx
    2241:	75 ed                	jne    2230 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    2243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2246:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    224c:	bf 00 10 00 00       	mov    $0x1000,%edi
    2251:	0f 43 fe             	cmovae %esi,%edi
    2254:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    2257:	89 04 24             	mov    %eax,(%esp)
    225a:	e8 3b fc ff ff       	call   1e9a <sbrk>
  if(p == (char*)-1)
    225f:	83 f8 ff             	cmp    $0xffffffff,%eax
    2262:	74 18                	je     227c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    2264:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    2267:	83 c0 08             	add    $0x8,%eax
    226a:	89 04 24             	mov    %eax,(%esp)
    226d:	e8 ee fe ff ff       	call   2160 <free>
  return freep;
    2272:	8b 15 64 2a 00 00    	mov    0x2a64,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    2278:	85 d2                	test   %edx,%edx
    227a:	75 b4                	jne    2230 <malloc+0x40>
        return 0;
    227c:	31 c0                	xor    %eax,%eax
    227e:	eb 20                	jmp    22a0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    2280:	89 d0                	mov    %edx,%eax
    2282:	89 da                	mov    %ebx,%edx
    2284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    2288:	39 fe                	cmp    %edi,%esi
    228a:	74 1c                	je     22a8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    228c:	29 f7                	sub    %esi,%edi
    228e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    2291:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    2294:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    2297:	89 15 64 2a 00 00    	mov    %edx,0x2a64
      return (void*)(p + 1);
    229d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    22a0:	83 c4 1c             	add    $0x1c,%esp
    22a3:	5b                   	pop    %ebx
    22a4:	5e                   	pop    %esi
    22a5:	5f                   	pop    %edi
    22a6:	5d                   	pop    %ebp
    22a7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    22a8:	8b 08                	mov    (%eax),%ecx
    22aa:	89 0a                	mov    %ecx,(%edx)
    22ac:	eb e9                	jmp    2297 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    22ae:	c7 05 64 2a 00 00 68 	movl   $0x2a68,0x2a64
    22b5:	2a 00 00 
    base.s.size = 0;
    22b8:	ba 68 2a 00 00       	mov    $0x2a68,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    22bd:	c7 05 68 2a 00 00 68 	movl   $0x2a68,0x2a68
    22c4:	2a 00 00 
    base.s.size = 0;
    22c7:	c7 05 6c 2a 00 00 00 	movl   $0x0,0x2a6c
    22ce:	00 00 00 
    22d1:	e9 46 ff ff ff       	jmp    221c <malloc+0x2c>
    22d6:	66 90                	xchg   %ax,%ax
    22d8:	66 90                	xchg   %ax,%ax
    22da:	66 90                	xchg   %ax,%ax
    22dc:	66 90                	xchg   %ax,%ax
    22de:	66 90                	xchg   %ax,%ax

000022e0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    22e0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    22e1:	b9 01 00 00 00       	mov    $0x1,%ecx
    22e6:	89 e5                	mov    %esp,%ebp
    22e8:	8b 55 08             	mov    0x8(%ebp),%edx
    22eb:	90                   	nop
    22ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    22f0:	89 c8                	mov    %ecx,%eax
    22f2:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    22f5:	85 c0                	test   %eax,%eax
    22f7:	75 f7                	jne    22f0 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    22f9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
    22fe:	5d                   	pop    %ebp
    22ff:	c3                   	ret    

00002300 <urelease>:

void urelease (struct uspinlock *lk) {
    2300:	55                   	push   %ebp
    2301:	89 e5                	mov    %esp,%ebp
    2303:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    2306:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    230b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    2311:	5d                   	pop    %ebp
    2312:	c3                   	ret    
