#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

int main(void){
    
	int start = getpid();
	int i, pid = fork();
	int status;
	if(pid > 0){
		for(i = 0; i < 15 && pid > 0; i++){
			pid = fork();
		}
		if (pid == 0){
			int j = 0;
			while(j++ < 1000);
			if(getpid() == start+4) sleep(80);
			printf(1,"pid = %d\n",getpid());
			if(getpid() == start+8){
				printf(1,"pid %d waiting for %d\n",start+8,start+4);
				int wpid = waitpid(start+4,&status,0);
				printf(1,"success clean %d\n",wpid);
			}
			if(getpid() == start+12){
				printf(1,"pid %d waiting for %d\n",start+12,start+4);
				int wpid = waitpid(start+4,&status,0);
				if(wpid == -1) printf(1,"no more waiting for %d\n",start+4);
			}
			if(getpid() == start+4) exit(1);
			exit(0);
		}
    	}else{
        	int j = 0;
        	while(j++ < 1000);
        	exit(0);
    	}
	int going = 1;
	while(going >= 0){
		going = wait(&status);
		printf(1,"kill %d process\n",going);
	};
	exit(0);
	return 0;
}
