#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"
#define MAXLEN 30
char *argv[] = { "sh", 0 };

int
CheckAccount(int fd , char *user , char *passwd)
{
    char allWord[1024];
    char _user[MAXLEN];
    char _password[MAXLEN];
    int num,now = 0;

    if(user[strlen(user)-1]  == '\n'){
  	    user[strlen(user)-1]  = 0;
    }
    if(passwd[strlen(passwd)-1]  == '\n'){
  	    passwd[strlen(passwd)-1]  = 0;
    }

    while((num = read(fd, allWord, sizeof(allWord))) > 0){
        now = 0;
        for(int i =0;i<num;i++)
        {
            for(;allWord[i]!=';'||i == num;i++,now++){
                _user[now] = allWord[i];
            }
            i++;
            _user[now] = '\0';
            if(i>=num){
                printf(1, "Login:Account File have error\n");
                break;
            }
            now =0;
            for(;allWord[i]!=';'||i == num;i++,now++){
                _password[now] = allWord[i];
            }
            i++;
            _password[now] = '\0';
            if(i>=num){
                printf(1, "Login:Account File have error\n");
                break;
            }
            if(!strcmp(user,_user) && !strcmp(passwd,_password)){
                char * dirToCreate = "/home/";
                strcpy(dirToCreate + strlen(dirToCreate), user);
                //printf(1,"%s\n", dirToCreate);
                mkdir(dirToCreate);
                return 1;
            }
            while(i <num && allWord[i++] != '\n');
        }
    }
    return 0;
}

int
main(void)
{
    int pid = 0,fd, wpid;
    char* username;
    char* password;
    while(1)
    {
        printf(1, "Username: ");
	username = gets("username", MAXLEN);
	printf(1, "Password: ");
        password = gets("password", MAXLEN);
        dup(0);  // stdout
	dup(0);  // stderr
	//printf(1, "init:
        if((fd = open("/.userpasswd", O_RDONLY)) < 0){
                printf(1, "Login: can't open Userpassword\n");
        }

        if(CheckAccount(fd,username,password)){
            printf(1, "Username %s login success.\n", username);
            pid = fork();
            if(pid < 0){
                printf(1, "login: fork failed\n");
                exit();
            }
            if(pid == 0){
                char * uname[] = {username};
                exec("sh", uname);
                printf(1, "login: exec sh failed\n");
                exit();
            }
        }
        else{
            printf(1, "you print error username or password\n");
            printf(1, "please input your account again\n");
        }

        close(fd);
        while((wpid=wait()) >= 0 && wpid != pid)
	    printf(1, "zombie!\n");
    }

    wait();
    exit();
    return 0;
}
