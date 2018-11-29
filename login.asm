
_login：     檔案格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
    return 0;
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
    int pid = 0,fd, wpid;
  11:	31 db                	xor    %ebx,%ebx
    return 0;
}

int
main(void)
{
  13:	83 ec 28             	sub    $0x28,%esp
  16:	8d 76 00             	lea    0x0(%esi),%esi
  19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    int pid = 0,fd, wpid;
    char* username;
    char* password;
    while(1)
    {
        printf(1, "Username: ");
  20:	83 ec 08             	sub    $0x8,%esp
  23:	68 e3 0a 00 00       	push   $0xae3
  28:	6a 01                	push   $0x1
  2a:	e8 01 07 00 00       	call   730 <printf>
	username = gets("username", MAXLEN);
  2f:	58                   	pop    %eax
  30:	5a                   	pop    %edx
  31:	6a 1e                	push   $0x1e
  33:	68 ee 0a 00 00       	push   $0xaee
  38:	e8 73 04 00 00       	call   4b0 <gets>
	printf(1, "Password: ");
  3d:	59                   	pop    %ecx
  3e:	5e                   	pop    %esi
  3f:	68 f7 0a 00 00       	push   $0xaf7
  44:	6a 01                	push   $0x1
    char* username;
    char* password;
    while(1)
    {
        printf(1, "Username: ");
	username = gets("username", MAXLEN);
  46:	89 c7                	mov    %eax,%edi
	printf(1, "Password: ");
  48:	e8 e3 06 00 00       	call   730 <printf>
        password = gets("password", MAXLEN);
  4d:	58                   	pop    %eax
  4e:	5a                   	pop    %edx
  4f:	6a 1e                	push   $0x1e
  51:	68 02 0b 00 00       	push   $0xb02
  56:	e8 55 04 00 00       	call   4b0 <gets>
        dup(0);  // stdout
  5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    while(1)
    {
        printf(1, "Username: ");
	username = gets("username", MAXLEN);
	printf(1, "Password: ");
        password = gets("password", MAXLEN);
  62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        dup(0);  // stdout
  65:	e8 f0 05 00 00       	call   65a <dup>
	dup(0);  // stderr
  6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  71:	e8 e4 05 00 00       	call   65a <dup>
	//printf(1, "init:
        if((fd = open("/.userpasswd", O_RDONLY)) < 0){
  76:	59                   	pop    %ecx
  77:	5e                   	pop    %esi
  78:	6a 00                	push   $0x0
  7a:	68 0b 0b 00 00       	push   $0xb0b
  7f:	e8 9e 05 00 00       	call   622 <open>
  84:	83 c4 10             	add    $0x10,%esp
  87:	85 c0                	test   %eax,%eax
  89:	89 c6                	mov    %eax,%esi
  8b:	0f 88 a7 00 00 00    	js     138 <main+0x138>
                printf(1, "Login: can't open Userpassword\n");
        }

        if(CheckAccount(fd,username,password)){
  91:	83 ec 04             	sub    $0x4,%esp
  94:	ff 75 d4             	pushl  -0x2c(%ebp)
  97:	57                   	push   %edi
  98:	56                   	push   %esi
  99:	e8 f2 00 00 00       	call   190 <CheckAccount>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	85 c0                	test   %eax,%eax
  a3:	74 6b                	je     110 <main+0x110>
            printf(1, "Username %s login success.\n", username);
  a5:	83 ec 04             	sub    $0x4,%esp
  a8:	57                   	push   %edi
  a9:	68 18 0b 00 00       	push   $0xb18
  ae:	6a 01                	push   $0x1
  b0:	e8 7b 06 00 00       	call   730 <printf>
            pid = fork();
  b5:	e8 20 05 00 00       	call   5da <fork>
            if(pid < 0){
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	85 c0                	test   %eax,%eax
                printf(1, "Login: can't open Userpassword\n");
        }

        if(CheckAccount(fd,username,password)){
            printf(1, "Username %s login success.\n", username);
            pid = fork();
  bf:	89 c3                	mov    %eax,%ebx
            if(pid < 0){
  c1:	0f 88 88 00 00 00    	js     14f <main+0x14f>
                printf(1, "login: fork failed\n");
                exit();
            }
            if(pid == 0){
  c7:	0f 84 95 00 00 00    	je     162 <main+0x162>
        else{
            printf(1, "you print error username or password\n");
            printf(1, "please input your account again\n");
        }

        close(fd);
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	56                   	push   %esi
  d1:	e8 34 05 00 00       	call   60a <close>
        while((wpid=wait()) >= 0 && wpid != pid)
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e0:	e8 05 05 00 00       	call   5ea <wait>
  e5:	39 c3                	cmp    %eax,%ebx
  e7:	0f 84 33 ff ff ff    	je     20 <main+0x20>
  ed:	85 c0                	test   %eax,%eax
  ef:	0f 88 2b ff ff ff    	js     20 <main+0x20>
	    printf(1, "zombie!\n");
  f5:	83 ec 08             	sub    $0x8,%esp
  f8:	68 62 0b 00 00       	push   $0xb62
  fd:	6a 01                	push   $0x1
  ff:	e8 2c 06 00 00       	call   730 <printf>
 104:	83 c4 10             	add    $0x10,%esp
 107:	eb d7                	jmp    e0 <main+0xe0>
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "login: exec sh failed\n");
                exit();
            }
        }
        else{
            printf(1, "you print error username or password\n");
 110:	83 ec 08             	sub    $0x8,%esp
 113:	68 90 0a 00 00       	push   $0xa90
 118:	6a 01                	push   $0x1
 11a:	e8 11 06 00 00       	call   730 <printf>
            printf(1, "please input your account again\n");
 11f:	58                   	pop    %eax
 120:	5a                   	pop    %edx
 121:	68 b8 0a 00 00       	push   $0xab8
 126:	6a 01                	push   $0x1
 128:	e8 03 06 00 00       	call   730 <printf>
 12d:	83 c4 10             	add    $0x10,%esp
 130:	eb 9b                	jmp    cd <main+0xcd>
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        password = gets("password", MAXLEN);
        dup(0);  // stdout
	dup(0);  // stderr
	//printf(1, "init:
        if((fd = open("/.userpasswd", O_RDONLY)) < 0){
                printf(1, "Login: can't open Userpassword\n");
 138:	83 ec 08             	sub    $0x8,%esp
 13b:	68 70 0a 00 00       	push   $0xa70
 140:	6a 01                	push   $0x1
 142:	e8 e9 05 00 00       	call   730 <printf>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	e9 42 ff ff ff       	jmp    91 <main+0x91>

        if(CheckAccount(fd,username,password)){
            printf(1, "Username %s login success.\n", username);
            pid = fork();
            if(pid < 0){
                printf(1, "login: fork failed\n");
 14f:	57                   	push   %edi
 150:	57                   	push   %edi
 151:	68 34 0b 00 00       	push   $0xb34
 156:	6a 01                	push   $0x1
 158:	e8 d3 05 00 00       	call   730 <printf>
                exit();
 15d:	e8 80 04 00 00       	call   5e2 <exit>
            }
            if(pid == 0){
                char * uname[] = {username};
                exec("sh", uname);
 162:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 165:	51                   	push   %ecx
 166:	51                   	push   %ecx
            if(pid < 0){
                printf(1, "login: fork failed\n");
                exit();
            }
            if(pid == 0){
                char * uname[] = {username};
 167:	89 7d e4             	mov    %edi,-0x1c(%ebp)
                exec("sh", uname);
 16a:	50                   	push   %eax
 16b:	68 48 0b 00 00       	push   $0xb48
 170:	e8 a5 04 00 00       	call   61a <exec>
                printf(1, "login: exec sh failed\n");
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	68 4b 0b 00 00       	push   $0xb4b
 17c:	6a 01                	push   $0x1
 17e:	e8 ad 05 00 00       	call   730 <printf>
                exit();
 183:	e8 5a 04 00 00       	call   5e2 <exit>
 188:	66 90                	xchg   %ax,%ax
 18a:	66 90                	xchg   %ax,%ax
 18c:	66 90                	xchg   %ax,%ax
 18e:	66 90                	xchg   %ax,%ax

00000190 <CheckAccount>:
#define MAXLEN 30
char *argv[] = { "sh", 0 };

int
CheckAccount(int fd , char *user , char *passwd)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	53                   	push   %ebx
 196:	81 ec 68 04 00 00    	sub    $0x468,%esp
    char allWord[1024];
    char _user[MAXLEN];
    char _password[MAXLEN];
    int num,now = 0;

    if(user[strlen(user)-1]  == '\n'){
 19c:	ff 75 0c             	pushl  0xc(%ebp)
 19f:	e8 7c 02 00 00       	call   420 <strlen>
 1a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
 1a7:	83 c4 10             	add    $0x10,%esp
 1aa:	80 7c 07 ff 0a       	cmpb   $0xa,-0x1(%edi,%eax,1)
 1af:	0f 84 d0 01 00 00    	je     385 <CheckAccount+0x1f5>
  	    user[strlen(user)-1]  = 0;
    }
    if(passwd[strlen(passwd)-1]  == '\n'){
 1b5:	83 ec 0c             	sub    $0xc,%esp
 1b8:	ff 75 10             	pushl  0x10(%ebp)
 1bb:	e8 60 02 00 00       	call   420 <strlen>
 1c0:	8b 7d 10             	mov    0x10(%ebp),%edi
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	80 7c 07 ff 0a       	cmpb   $0xa,-0x1(%edi,%eax,1)
 1cb:	0f 84 9b 01 00 00    	je     36c <CheckAccount+0x1dc>
 1d1:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
  	    passwd[strlen(passwd)-1]  = 0;
    }

    while((num = read(fd, allWord, sizeof(allWord))) > 0){
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	68 00 04 00 00       	push   $0x400
 1df:	57                   	push   %edi
 1e0:	ff 75 08             	pushl  0x8(%ebp)
 1e3:	e8 12 04 00 00       	call   5fa <read>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	85 c0                	test   %eax,%eax
 1ed:	89 85 a4 fb ff ff    	mov    %eax,-0x45c(%ebp)
 1f3:	b8 00 00 00 00       	mov    $0x0,%eax
 1f8:	0f 8e 4f 01 00 00    	jle    34d <CheckAccount+0x1bd>
 1fe:	31 f6                	xor    %esi,%esi
        now = 0;
        for(int i =0;i<num;i++)
        {
            for(;allWord[i]!=';'||i == num;i++,now++){
 200:	0f b6 9c 05 e8 fb ff 	movzbl -0x418(%ebp,%eax,1),%ebx
 207:	ff 
 208:	80 fb 3b             	cmp    $0x3b,%bl
 20b:	75 0a                	jne    217 <CheckAccount+0x87>
 20d:	39 85 a4 fb ff ff    	cmp    %eax,-0x45c(%ebp)
 213:	89 f1                	mov    %esi,%ecx
 215:	75 2b                	jne    242 <CheckAccount+0xb2>
 217:	89 f2                	mov    %esi,%edx
                _user[now] = allWord[i];
 219:	8d b5 ac fb ff ff    	lea    -0x454(%ebp),%esi
 21f:	29 c2                	sub    %eax,%edx
 221:	01 d6                	add    %edx,%esi
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 228:	88 1c 06             	mov    %bl,(%esi,%eax,1)

    while((num = read(fd, allWord, sizeof(allWord))) > 0){
        now = 0;
        for(int i =0;i<num;i++)
        {
            for(;allWord[i]!=';'||i == num;i++,now++){
 22b:	83 c0 01             	add    $0x1,%eax
 22e:	0f b6 1c 07          	movzbl (%edi,%eax,1),%ebx
 232:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 235:	80 fb 3b             	cmp    $0x3b,%bl
 238:	75 ee                	jne    228 <CheckAccount+0x98>
 23a:	39 85 a4 fb ff ff    	cmp    %eax,-0x45c(%ebp)
 240:	74 e6                	je     228 <CheckAccount+0x98>
                _user[now] = allWord[i];
            }
            i++;
 242:	83 c0 01             	add    $0x1,%eax
            _user[now] = '\0';
            if(i>=num){
 245:	39 85 a4 fb ff ff    	cmp    %eax,-0x45c(%ebp)
        {
            for(;allWord[i]!=';'||i == num;i++,now++){
                _user[now] = allWord[i];
            }
            i++;
            _user[now] = '\0';
 24b:	c6 84 0d ac fb ff ff 	movb   $0x0,-0x454(%ebp,%ecx,1)
 252:	00 
            if(i>=num){
 253:	0f 8e fc 00 00 00    	jle    355 <CheckAccount+0x1c5>
                printf(1, "Login:Account File have error\n");
                break;
            }
            now =0;
            for(;allWord[i]!=';'||i == num;i++,now++){
 259:	0f b6 8c 05 e8 fb ff 	movzbl -0x418(%ebp,%eax,1),%ecx
 260:	ff 
 261:	31 f6                	xor    %esi,%esi
 263:	8d 95 ca fb ff ff    	lea    -0x436(%ebp),%edx
 269:	80 f9 3b             	cmp    $0x3b,%cl
 26c:	74 1c                	je     28a <CheckAccount+0xfa>
 26e:	66 90                	xchg   %ax,%ax
 270:	83 c0 01             	add    $0x1,%eax
                _password[now] = allWord[i];
 273:	88 0c 32             	mov    %cl,(%edx,%esi,1)
            if(i>=num){
                printf(1, "Login:Account File have error\n");
                break;
            }
            now =0;
            for(;allWord[i]!=';'||i == num;i++,now++){
 276:	83 c6 01             	add    $0x1,%esi
 279:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
 27d:	80 f9 3b             	cmp    $0x3b,%cl
 280:	75 ee                	jne    270 <CheckAccount+0xe0>
 282:	39 85 a4 fb ff ff    	cmp    %eax,-0x45c(%ebp)
 288:	74 e6                	je     270 <CheckAccount+0xe0>
                _password[now] = allWord[i];
            }
            i++;
 28a:	8d 58 01             	lea    0x1(%eax),%ebx
            _password[now] = '\0';
            if(i>=num){
 28d:	39 9d a4 fb ff ff    	cmp    %ebx,-0x45c(%ebp)
            now =0;
            for(;allWord[i]!=';'||i == num;i++,now++){
                _password[now] = allWord[i];
            }
            i++;
            _password[now] = '\0';
 293:	c6 84 35 ca fb ff ff 	movb   $0x0,-0x436(%ebp,%esi,1)
 29a:	00 
            if(i>=num){
 29b:	0f 8e b4 00 00 00    	jle    355 <CheckAccount+0x1c5>
                printf(1, "Login:Account File have error\n");
                break;
            }
            if(!strcmp(user,_user) && !strcmp(passwd,_password)){
 2a1:	8d 85 ac fb ff ff    	lea    -0x454(%ebp),%eax
 2a7:	83 ec 08             	sub    $0x8,%esp
 2aa:	50                   	push   %eax
 2ab:	ff 75 0c             	pushl  0xc(%ebp)
 2ae:	e8 1d 01 00 00       	call   3d0 <strcmp>
 2b3:	83 c4 10             	add    $0x10,%esp
 2b6:	85 c0                	test   %eax,%eax
 2b8:	74 49                	je     303 <CheckAccount+0x173>
 2ba:	89 b5 a0 fb ff ff    	mov    %esi,-0x460(%ebp)
 2c0:	8b b5 a4 fb ff ff    	mov    -0x45c(%ebp),%esi
 2c6:	eb 0a                	jmp    2d2 <CheckAccount+0x142>
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2d0:	89 c3                	mov    %eax,%ebx
                strcpy(dirToCreate + strlen(dirToCreate), user);
                //printf(1,"%s\n", dirToCreate);
                mkdir(dirToCreate);
                return 1;
            }
            while(i <num && allWord[i++] != '\n');
 2d2:	8d 43 01             	lea    0x1(%ebx),%eax
 2d5:	80 bc 05 e7 fb ff ff 	cmpb   $0xa,-0x419(%ebp,%eax,1)
 2dc:	0a 
 2dd:	0f 95 c1             	setne  %cl
 2e0:	39 c6                	cmp    %eax,%esi
 2e2:	0f 9f c2             	setg   %dl
 2e5:	84 d1                	test   %dl,%cl
 2e7:	75 e7                	jne    2d0 <CheckAccount+0x140>
  	    passwd[strlen(passwd)-1]  = 0;
    }

    while((num = read(fd, allWord, sizeof(allWord))) > 0){
        now = 0;
        for(int i =0;i<num;i++)
 2e9:	8d 43 02             	lea    0x2(%ebx),%eax
 2ec:	39 85 a4 fb ff ff    	cmp    %eax,-0x45c(%ebp)
 2f2:	8b b5 a0 fb ff ff    	mov    -0x460(%ebp),%esi
 2f8:	0f 8f 02 ff ff ff    	jg     200 <CheckAccount+0x70>
 2fe:	e9 d4 fe ff ff       	jmp    1d7 <CheckAccount+0x47>
            _password[now] = '\0';
            if(i>=num){
                printf(1, "Login:Account File have error\n");
                break;
            }
            if(!strcmp(user,_user) && !strcmp(passwd,_password)){
 303:	8d 95 ca fb ff ff    	lea    -0x436(%ebp),%edx
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	52                   	push   %edx
 30d:	ff 75 10             	pushl  0x10(%ebp)
 310:	e8 bb 00 00 00       	call   3d0 <strcmp>
 315:	83 c4 10             	add    $0x10,%esp
 318:	85 c0                	test   %eax,%eax
 31a:	75 9e                	jne    2ba <CheckAccount+0x12a>
                char * dirToCreate = "/home/";
                strcpy(dirToCreate + strlen(dirToCreate), user);
 31c:	83 ec 0c             	sub    $0xc,%esp
 31f:	68 dc 0a 00 00       	push   $0xadc
 324:	e8 f7 00 00 00       	call   420 <strlen>
 329:	5a                   	pop    %edx
 32a:	59                   	pop    %ecx
 32b:	05 dc 0a 00 00       	add    $0xadc,%eax
 330:	ff 75 0c             	pushl  0xc(%ebp)
 333:	50                   	push   %eax
 334:	e8 67 00 00 00       	call   3a0 <strcpy>
                //printf(1,"%s\n", dirToCreate);
                mkdir(dirToCreate);
 339:	c7 04 24 dc 0a 00 00 	movl   $0xadc,(%esp)
 340:	e8 05 03 00 00       	call   64a <mkdir>
                return 1;
 345:	83 c4 10             	add    $0x10,%esp
 348:	b8 01 00 00 00       	mov    $0x1,%eax
            }
            while(i <num && allWord[i++] != '\n');
        }
    }
    return 0;
}
 34d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret    
                _user[now] = allWord[i];
            }
            i++;
            _user[now] = '\0';
            if(i>=num){
                printf(1, "Login:Account File have error\n");
 355:	83 ec 08             	sub    $0x8,%esp
 358:	68 50 0a 00 00       	push   $0xa50
 35d:	6a 01                	push   $0x1
 35f:	e8 cc 03 00 00       	call   730 <printf>
 364:	83 c4 10             	add    $0x10,%esp
 367:	e9 6b fe ff ff       	jmp    1d7 <CheckAccount+0x47>

    if(user[strlen(user)-1]  == '\n'){
  	    user[strlen(user)-1]  = 0;
    }
    if(passwd[strlen(passwd)-1]  == '\n'){
  	    passwd[strlen(passwd)-1]  = 0;
 36c:	83 ec 0c             	sub    $0xc,%esp
 36f:	57                   	push   %edi
 370:	e8 ab 00 00 00       	call   420 <strlen>
 375:	8b 7d 10             	mov    0x10(%ebp),%edi
 378:	83 c4 10             	add    $0x10,%esp
 37b:	c6 44 07 ff 00       	movb   $0x0,-0x1(%edi,%eax,1)
 380:	e9 4c fe ff ff       	jmp    1d1 <CheckAccount+0x41>
    char _user[MAXLEN];
    char _password[MAXLEN];
    int num,now = 0;

    if(user[strlen(user)-1]  == '\n'){
  	    user[strlen(user)-1]  = 0;
 385:	83 ec 0c             	sub    $0xc,%esp
 388:	57                   	push   %edi
 389:	e8 92 00 00 00       	call   420 <strlen>
 38e:	8b 7d 0c             	mov    0xc(%ebp),%edi
 391:	83 c4 10             	add    $0x10,%esp
 394:	c6 44 07 ff 00       	movb   $0x0,-0x1(%edi,%eax,1)
 399:	e9 17 fe ff ff       	jmp    1b5 <CheckAccount+0x25>
 39e:	66 90                	xchg   %ax,%ax

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3aa:	89 c2                	mov    %eax,%edx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b0:	83 c1 01             	add    $0x1,%ecx
 3b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3b7:	83 c2 01             	add    $0x1,%edx
 3ba:	84 db                	test   %bl,%bl
 3bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 3bf:	75 ef                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3c1:	5b                   	pop    %ebx
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	8b 55 08             	mov    0x8(%ebp),%edx
 3d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3db:	0f b6 02             	movzbl (%edx),%eax
 3de:	0f b6 19             	movzbl (%ecx),%ebx
 3e1:	84 c0                	test   %al,%al
 3e3:	75 1e                	jne    403 <strcmp+0x33>
 3e5:	eb 29                	jmp    410 <strcmp+0x40>
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3f0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3f6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3f9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3fd:	84 c0                	test   %al,%al
 3ff:	74 0f                	je     410 <strcmp+0x40>
 401:	89 f1                	mov    %esi,%ecx
 403:	38 d8                	cmp    %bl,%al
 405:	74 e9                	je     3f0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 407:	29 d8                	sub    %ebx,%eax
}
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 410:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 412:	29 d8                	sub    %ebx,%eax
}
 414:	5b                   	pop    %ebx
 415:	5e                   	pop    %esi
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <strlen>:

uint
strlen(const char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 426:	80 39 00             	cmpb   $0x0,(%ecx)
 429:	74 12                	je     43d <strlen+0x1d>
 42b:	31 d2                	xor    %edx,%edx
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	83 c2 01             	add    $0x1,%edx
 433:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 437:	89 d0                	mov    %edx,%eax
 439:	75 f5                	jne    430 <strlen+0x10>
    ;
  return n;
}
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 43d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    
 441:	eb 0d                	jmp    450 <memset>
 443:	90                   	nop
 444:	90                   	nop
 445:	90                   	nop
 446:	90                   	nop
 447:	90                   	nop
 448:	90                   	nop
 449:	90                   	nop
 44a:	90                   	nop
 44b:	90                   	nop
 44c:	90                   	nop
 44d:	90                   	nop
 44e:	90                   	nop
 44f:	90                   	nop

00000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 457:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 d7                	mov    %edx,%edi
 45f:	fc                   	cld    
 460:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 462:	89 d0                	mov    %edx,%eax
 464:	5f                   	pop    %edi
 465:	5d                   	pop    %ebp
 466:	c3                   	ret    
 467:	89 f6                	mov    %esi,%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 47a:	0f b6 10             	movzbl (%eax),%edx
 47d:	84 d2                	test   %dl,%dl
 47f:	74 1d                	je     49e <strchr+0x2e>
    if(*s == c)
 481:	38 d3                	cmp    %dl,%bl
 483:	89 d9                	mov    %ebx,%ecx
 485:	75 0d                	jne    494 <strchr+0x24>
 487:	eb 17                	jmp    4a0 <strchr+0x30>
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 490:	38 ca                	cmp    %cl,%dl
 492:	74 0c                	je     4a0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 494:	83 c0 01             	add    $0x1,%eax
 497:	0f b6 10             	movzbl (%eax),%edx
 49a:	84 d2                	test   %dl,%dl
 49c:	75 f2                	jne    490 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 49e:	31 c0                	xor    %eax,%eax
}
 4a0:	5b                   	pop    %ebx
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <gets>:

char*
gets(char *buf, int max)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 4b8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 4bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4be:	eb 29                	jmp    4e9 <gets+0x39>
    cc = read(0, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	6a 01                	push   $0x1
 4c5:	57                   	push   %edi
 4c6:	6a 00                	push   $0x0
 4c8:	e8 2d 01 00 00       	call   5fa <read>
    if(cc < 1)
 4cd:	83 c4 10             	add    $0x10,%esp
 4d0:	85 c0                	test   %eax,%eax
 4d2:	7e 1d                	jle    4f1 <gets+0x41>
      break;
    buf[i++] = c;
 4d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4d8:	8b 55 08             	mov    0x8(%ebp),%edx
 4db:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 4dd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 4df:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4e3:	74 1b                	je     500 <gets+0x50>
 4e5:	3c 0d                	cmp    $0xd,%al
 4e7:	74 17                	je     500 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e9:	8d 5e 01             	lea    0x1(%esi),%ebx
 4ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4ef:	7c cf                	jl     4c0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fb:	5b                   	pop    %ebx
 4fc:	5e                   	pop    %esi
 4fd:	5f                   	pop    %edi
 4fe:	5d                   	pop    %ebp
 4ff:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 500:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 503:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 505:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 509:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50c:	5b                   	pop    %ebx
 50d:	5e                   	pop    %esi
 50e:	5f                   	pop    %edi
 50f:	5d                   	pop    %ebp
 510:	c3                   	ret    
 511:	eb 0d                	jmp    520 <stat>
 513:	90                   	nop
 514:	90                   	nop
 515:	90                   	nop
 516:	90                   	nop
 517:	90                   	nop
 518:	90                   	nop
 519:	90                   	nop
 51a:	90                   	nop
 51b:	90                   	nop
 51c:	90                   	nop
 51d:	90                   	nop
 51e:	90                   	nop
 51f:	90                   	nop

00000520 <stat>:

int
stat(const char *n, struct stat *st)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	83 ec 08             	sub    $0x8,%esp
 528:	6a 00                	push   $0x0
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 f0 00 00 00       	call   622 <open>
  if(fd < 0)
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
 537:	78 27                	js     560 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	ff 75 0c             	pushl  0xc(%ebp)
 53f:	89 c3                	mov    %eax,%ebx
 541:	50                   	push   %eax
 542:	e8 f3 00 00 00       	call   63a <fstat>
 547:	89 c6                	mov    %eax,%esi
  close(fd);
 549:	89 1c 24             	mov    %ebx,(%esp)
 54c:	e8 b9 00 00 00       	call   60a <close>
  return r;
 551:	83 c4 10             	add    $0x10,%esp
 554:	89 f0                	mov    %esi,%eax
}
 556:	8d 65 f8             	lea    -0x8(%ebp),%esp
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 565:	eb ef                	jmp    556 <stat+0x36>
 567:	89 f6                	mov    %esi,%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000570 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 577:	0f be 11             	movsbl (%ecx),%edx
 57a:	8d 42 d0             	lea    -0x30(%edx),%eax
 57d:	3c 09                	cmp    $0x9,%al
 57f:	b8 00 00 00 00       	mov    $0x0,%eax
 584:	77 1f                	ja     5a5 <atoi+0x35>
 586:	8d 76 00             	lea    0x0(%esi),%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 590:	8d 04 80             	lea    (%eax,%eax,4),%eax
 593:	83 c1 01             	add    $0x1,%ecx
 596:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 59a:	0f be 11             	movsbl (%ecx),%edx
 59d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5a0:	80 fb 09             	cmp    $0x9,%bl
 5a3:	76 eb                	jbe    590 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 5a5:	5b                   	pop    %ebx
 5a6:	5d                   	pop    %ebp
 5a7:	c3                   	ret    
 5a8:	90                   	nop
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	56                   	push   %esi
 5b4:	53                   	push   %ebx
 5b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5be:	85 db                	test   %ebx,%ebx
 5c0:	7e 14                	jle    5d6 <memmove+0x26>
 5c2:	31 d2                	xor    %edx,%edx
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5cf:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5d2:	39 da                	cmp    %ebx,%edx
 5d4:	75 f2                	jne    5c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret    

000005da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5da:	b8 01 00 00 00       	mov    $0x1,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <exit>:
SYSCALL(exit)
 5e2:	b8 02 00 00 00       	mov    $0x2,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <wait>:
SYSCALL(wait)
 5ea:	b8 03 00 00 00       	mov    $0x3,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <pipe>:
SYSCALL(pipe)
 5f2:	b8 04 00 00 00       	mov    $0x4,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <read>:
SYSCALL(read)
 5fa:	b8 05 00 00 00       	mov    $0x5,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <write>:
SYSCALL(write)
 602:	b8 10 00 00 00       	mov    $0x10,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <close>:
SYSCALL(close)
 60a:	b8 15 00 00 00       	mov    $0x15,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <kill>:
SYSCALL(kill)
 612:	b8 06 00 00 00       	mov    $0x6,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <exec>:
SYSCALL(exec)
 61a:	b8 07 00 00 00       	mov    $0x7,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <open>:
SYSCALL(open)
 622:	b8 0f 00 00 00       	mov    $0xf,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mknod>:
SYSCALL(mknod)
 62a:	b8 11 00 00 00       	mov    $0x11,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <unlink>:
SYSCALL(unlink)
 632:	b8 12 00 00 00       	mov    $0x12,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <fstat>:
SYSCALL(fstat)
 63a:	b8 08 00 00 00       	mov    $0x8,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <link>:
SYSCALL(link)
 642:	b8 13 00 00 00       	mov    $0x13,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mkdir>:
SYSCALL(mkdir)
 64a:	b8 14 00 00 00       	mov    $0x14,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <chdir>:
SYSCALL(chdir)
 652:	b8 09 00 00 00       	mov    $0x9,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <dup>:
SYSCALL(dup)
 65a:	b8 0a 00 00 00       	mov    $0xa,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getpid>:
SYSCALL(getpid)
 662:	b8 0b 00 00 00       	mov    $0xb,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <sbrk>:
SYSCALL(sbrk)
 66a:	b8 0c 00 00 00       	mov    $0xc,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sleep>:
SYSCALL(sleep)
 672:	b8 0d 00 00 00       	mov    $0xd,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <uptime>:
SYSCALL(uptime)
 67a:	b8 0e 00 00 00       	mov    $0xe,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    
 682:	66 90                	xchg   %ax,%ax
 684:	66 90                	xchg   %ax,%ax
 686:	66 90                	xchg   %ax,%ax
 688:	66 90                	xchg   %ax,%ax
 68a:	66 90                	xchg   %ax,%ax
 68c:	66 90                	xchg   %ax,%ax
 68e:	66 90                	xchg   %ax,%ax

00000690 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	89 c6                	mov    %eax,%esi
 698:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 69e:	85 db                	test   %ebx,%ebx
 6a0:	74 7e                	je     720 <printint+0x90>
 6a2:	89 d0                	mov    %edx,%eax
 6a4:	c1 e8 1f             	shr    $0x1f,%eax
 6a7:	84 c0                	test   %al,%al
 6a9:	74 75                	je     720 <printint+0x90>
    neg = 1;
    x = -xx;
 6ab:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 6ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 6b4:	f7 d8                	neg    %eax
 6b6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6b9:	31 ff                	xor    %edi,%edi
 6bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6be:	89 ce                	mov    %ecx,%esi
 6c0:	eb 08                	jmp    6ca <printint+0x3a>
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6c8:	89 cf                	mov    %ecx,%edi
 6ca:	31 d2                	xor    %edx,%edx
 6cc:	8d 4f 01             	lea    0x1(%edi),%ecx
 6cf:	f7 f6                	div    %esi
 6d1:	0f b6 92 74 0b 00 00 	movzbl 0xb74(%edx),%edx
  }while((x /= base) != 0);
 6d8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6da:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 6dd:	75 e9                	jne    6c8 <printint+0x38>
  if(neg)
 6df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6e2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6e5:	85 c0                	test   %eax,%eax
 6e7:	74 08                	je     6f1 <printint+0x61>
    buf[i++] = '-';
 6e9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 6ee:	8d 4f 02             	lea    0x2(%edi),%ecx
 6f1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
 6f8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	83 ef 01             	sub    $0x1,%edi
 701:	6a 01                	push   $0x1
 703:	53                   	push   %ebx
 704:	56                   	push   %esi
 705:	88 45 d7             	mov    %al,-0x29(%ebp)
 708:	e8 f5 fe ff ff       	call   602 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 70d:	83 c4 10             	add    $0x10,%esp
 710:	39 df                	cmp    %ebx,%edi
 712:	75 e4                	jne    6f8 <printint+0x68>
    putc(fd, buf[i]);
}
 714:	8d 65 f4             	lea    -0xc(%ebp),%esp
 717:	5b                   	pop    %ebx
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 720:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 722:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 729:	eb 8b                	jmp    6b6 <printint+0x26>
 72b:	90                   	nop
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 736:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 739:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 73f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 742:	89 45 d0             	mov    %eax,-0x30(%ebp)
 745:	0f b6 1e             	movzbl (%esi),%ebx
 748:	83 c6 01             	add    $0x1,%esi
 74b:	84 db                	test   %bl,%bl
 74d:	0f 84 b0 00 00 00    	je     803 <printf+0xd3>
 753:	31 d2                	xor    %edx,%edx
 755:	eb 39                	jmp    790 <printf+0x60>
 757:	89 f6                	mov    %esi,%esi
 759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 760:	83 f8 25             	cmp    $0x25,%eax
 763:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 766:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 76b:	74 18                	je     785 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 76d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 776:	6a 01                	push   $0x1
 778:	50                   	push   %eax
 779:	57                   	push   %edi
 77a:	e8 83 fe ff ff       	call   602 <write>
 77f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 782:	83 c4 10             	add    $0x10,%esp
 785:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 788:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 78c:	84 db                	test   %bl,%bl
 78e:	74 73                	je     803 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 790:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 792:	0f be cb             	movsbl %bl,%ecx
 795:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 798:	74 c6                	je     760 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 79a:	83 fa 25             	cmp    $0x25,%edx
 79d:	75 e6                	jne    785 <printf+0x55>
      if(c == 'd'){
 79f:	83 f8 64             	cmp    $0x64,%eax
 7a2:	0f 84 f8 00 00 00    	je     8a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7a8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7ae:	83 f9 70             	cmp    $0x70,%ecx
 7b1:	74 5d                	je     810 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7b3:	83 f8 73             	cmp    $0x73,%eax
 7b6:	0f 84 84 00 00 00    	je     840 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bc:	83 f8 63             	cmp    $0x63,%eax
 7bf:	0f 84 ea 00 00 00    	je     8af <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7c5:	83 f8 25             	cmp    $0x25,%eax
 7c8:	0f 84 c2 00 00 00    	je     890 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7d1:	83 ec 04             	sub    $0x4,%esp
 7d4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7d8:	6a 01                	push   $0x1
 7da:	50                   	push   %eax
 7db:	57                   	push   %edi
 7dc:	e8 21 fe ff ff       	call   602 <write>
 7e1:	83 c4 0c             	add    $0xc,%esp
 7e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7e7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ea:	6a 01                	push   $0x1
 7ec:	50                   	push   %eax
 7ed:	57                   	push   %edi
 7ee:	83 c6 01             	add    $0x1,%esi
 7f1:	e8 0c fe ff ff       	call   602 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7fa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7fd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ff:	84 db                	test   %bl,%bl
 801:	75 8d                	jne    790 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 803:	8d 65 f4             	lea    -0xc(%ebp),%esp
 806:	5b                   	pop    %ebx
 807:	5e                   	pop    %esi
 808:	5f                   	pop    %edi
 809:	5d                   	pop    %ebp
 80a:	c3                   	ret    
 80b:	90                   	nop
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	b9 10 00 00 00       	mov    $0x10,%ecx
 818:	6a 00                	push   $0x0
 81a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 81d:	89 f8                	mov    %edi,%eax
 81f:	8b 13                	mov    (%ebx),%edx
 821:	e8 6a fe ff ff       	call   690 <printint>
        ap++;
 826:	89 d8                	mov    %ebx,%eax
 828:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 82b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 82d:	83 c0 04             	add    $0x4,%eax
 830:	89 45 d0             	mov    %eax,-0x30(%ebp)
 833:	e9 4d ff ff ff       	jmp    785 <printf+0x55>
 838:	90                   	nop
 839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 840:	8b 45 d0             	mov    -0x30(%ebp),%eax
 843:	8b 18                	mov    (%eax),%ebx
        ap++;
 845:	83 c0 04             	add    $0x4,%eax
 848:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 84b:	b8 6b 0b 00 00       	mov    $0xb6b,%eax
 850:	85 db                	test   %ebx,%ebx
 852:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 855:	0f b6 03             	movzbl (%ebx),%eax
 858:	84 c0                	test   %al,%al
 85a:	74 23                	je     87f <printf+0x14f>
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 860:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 863:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 866:	83 ec 04             	sub    $0x4,%esp
 869:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 86b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 86e:	50                   	push   %eax
 86f:	57                   	push   %edi
 870:	e8 8d fd ff ff       	call   602 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 875:	0f b6 03             	movzbl (%ebx),%eax
 878:	83 c4 10             	add    $0x10,%esp
 87b:	84 c0                	test   %al,%al
 87d:	75 e1                	jne    860 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 87f:	31 d2                	xor    %edx,%edx
 881:	e9 ff fe ff ff       	jmp    785 <printf+0x55>
 886:	8d 76 00             	lea    0x0(%esi),%esi
 889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 890:	83 ec 04             	sub    $0x4,%esp
 893:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 896:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 899:	6a 01                	push   $0x1
 89b:	e9 4c ff ff ff       	jmp    7ec <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8a8:	6a 01                	push   $0x1
 8aa:	e9 6b ff ff ff       	jmp    81a <printf+0xea>
 8af:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8b2:	83 ec 04             	sub    $0x4,%esp
 8b5:	8b 03                	mov    (%ebx),%eax
 8b7:	6a 01                	push   $0x1
 8b9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 8bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8bf:	50                   	push   %eax
 8c0:	57                   	push   %edi
 8c1:	e8 3c fd ff ff       	call   602 <write>
 8c6:	e9 5b ff ff ff       	jmp    826 <printf+0xf6>
 8cb:	66 90                	xchg   %ax,%ax
 8cd:	66 90                	xchg   %ax,%ax
 8cf:	90                   	nop

000008d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	a1 50 0e 00 00       	mov    0xe50,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	57                   	push   %edi
 8d9:	56                   	push   %esi
 8da:	53                   	push   %ebx
 8db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e3:	39 c8                	cmp    %ecx,%eax
 8e5:	73 19                	jae    900 <free+0x30>
 8e7:	89 f6                	mov    %esi,%esi
 8e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 8f0:	39 d1                	cmp    %edx,%ecx
 8f2:	72 1c                	jb     910 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f4:	39 d0                	cmp    %edx,%eax
 8f6:	73 18                	jae    910 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	72 f0                	jb     8f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 900:	39 d0                	cmp    %edx,%eax
 902:	72 f4                	jb     8f8 <free+0x28>
 904:	39 d1                	cmp    %edx,%ecx
 906:	73 f0                	jae    8f8 <free+0x28>
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 910:	8b 73 fc             	mov    -0x4(%ebx),%esi
 913:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 916:	39 d7                	cmp    %edx,%edi
 918:	74 19                	je     933 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 91a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 91d:	8b 50 04             	mov    0x4(%eax),%edx
 920:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 923:	39 f1                	cmp    %esi,%ecx
 925:	74 23                	je     94a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 927:	89 08                	mov    %ecx,(%eax)
  freep = p;
 929:	a3 50 0e 00 00       	mov    %eax,0xe50
}
 92e:	5b                   	pop    %ebx
 92f:	5e                   	pop    %esi
 930:	5f                   	pop    %edi
 931:	5d                   	pop    %ebp
 932:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 933:	03 72 04             	add    0x4(%edx),%esi
 936:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 939:	8b 10                	mov    (%eax),%edx
 93b:	8b 12                	mov    (%edx),%edx
 93d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 940:	8b 50 04             	mov    0x4(%eax),%edx
 943:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 946:	39 f1                	cmp    %esi,%ecx
 948:	75 dd                	jne    927 <free+0x57>
    p->s.size += bp->s.size;
 94a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 94d:	a3 50 0e 00 00       	mov    %eax,0xe50
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 952:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 955:	8b 53 f8             	mov    -0x8(%ebx),%edx
 958:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 95a:	5b                   	pop    %ebx
 95b:	5e                   	pop    %esi
 95c:	5f                   	pop    %edi
 95d:	5d                   	pop    %ebp
 95e:	c3                   	ret    
 95f:	90                   	nop

00000960 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	57                   	push   %edi
 964:	56                   	push   %esi
 965:	53                   	push   %ebx
 966:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 96c:	8b 15 50 0e 00 00    	mov    0xe50,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 972:	8d 78 07             	lea    0x7(%eax),%edi
 975:	c1 ef 03             	shr    $0x3,%edi
 978:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 97b:	85 d2                	test   %edx,%edx
 97d:	0f 84 a3 00 00 00    	je     a26 <malloc+0xc6>
 983:	8b 02                	mov    (%edx),%eax
 985:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 988:	39 cf                	cmp    %ecx,%edi
 98a:	76 74                	jbe    a00 <malloc+0xa0>
 98c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 992:	be 00 10 00 00       	mov    $0x1000,%esi
 997:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 99e:	0f 43 f7             	cmovae %edi,%esi
 9a1:	ba 00 80 00 00       	mov    $0x8000,%edx
 9a6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 9ac:	0f 46 da             	cmovbe %edx,%ebx
 9af:	eb 10                	jmp    9c1 <malloc+0x61>
 9b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9ba:	8b 48 04             	mov    0x4(%eax),%ecx
 9bd:	39 cf                	cmp    %ecx,%edi
 9bf:	76 3f                	jbe    a00 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c1:	39 05 50 0e 00 00    	cmp    %eax,0xe50
 9c7:	89 c2                	mov    %eax,%edx
 9c9:	75 ed                	jne    9b8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9cb:	83 ec 0c             	sub    $0xc,%esp
 9ce:	53                   	push   %ebx
 9cf:	e8 96 fc ff ff       	call   66a <sbrk>
  if(p == (char*)-1)
 9d4:	83 c4 10             	add    $0x10,%esp
 9d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9da:	74 1c                	je     9f8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9dc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 9df:	83 ec 0c             	sub    $0xc,%esp
 9e2:	83 c0 08             	add    $0x8,%eax
 9e5:	50                   	push   %eax
 9e6:	e8 e5 fe ff ff       	call   8d0 <free>
  return freep;
 9eb:	8b 15 50 0e 00 00    	mov    0xe50,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	85 d2                	test   %edx,%edx
 9f6:	75 c0                	jne    9b8 <malloc+0x58>
        return 0;
 9f8:	31 c0                	xor    %eax,%eax
 9fa:	eb 1c                	jmp    a18 <malloc+0xb8>
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 a00:	39 cf                	cmp    %ecx,%edi
 a02:	74 1c                	je     a20 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a04:	29 f9                	sub    %edi,%ecx
 a06:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a09:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a0c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 a0f:	89 15 50 0e 00 00    	mov    %edx,0xe50
      return (void*)(p + 1);
 a15:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a1b:	5b                   	pop    %ebx
 a1c:	5e                   	pop    %esi
 a1d:	5f                   	pop    %edi
 a1e:	5d                   	pop    %ebp
 a1f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a20:	8b 08                	mov    (%eax),%ecx
 a22:	89 0a                	mov    %ecx,(%edx)
 a24:	eb e9                	jmp    a0f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a26:	c7 05 50 0e 00 00 54 	movl   $0xe54,0xe50
 a2d:	0e 00 00 
 a30:	c7 05 54 0e 00 00 54 	movl   $0xe54,0xe54
 a37:	0e 00 00 
    base.s.size = 0;
 a3a:	b8 54 0e 00 00       	mov    $0xe54,%eax
 a3f:	c7 05 58 0e 00 00 00 	movl   $0x0,0xe58
 a46:	00 00 00 
 a49:	e9 3e ff ff ff       	jmp    98c <malloc+0x2c>
