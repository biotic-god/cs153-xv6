#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

int main(){
    int i;
    int start = getpid();
    int pid = fork();
    if(pid > 0){
        for(i = 0; i < 15 && pid > 0; i++){
            pid = fork();
        }
        if (pid == 0){
            int j = 0;
            if(getpid() == start + 5){
                printf(1," pid = %d, high priority\n\n",getpid());
                setprio(2);
            }
            if(getpid() == start + 10){
                printf(1," pid = %d, low priority\n\n",getpid());
                setprio(0);
            }
            while(j++ < 30000000);
            exit(0);
        }
    }else if(pid == 0){
        int j = 0;
        while(j++ < 30000000);
        exit(0);
    }
    int ki = 1;
    int status;
    while(ki >= 0){
        ki = wait(&status);
        if(ki == start+5)
            printf(1," [%d] done first\n",ki);
        else if(ki == start+10)
            printf(1," [%d] done last\n",ki);
        else
            printf(1," [%d] done runing\n",ki);

    }
    exit(0);
    return 0;
}
