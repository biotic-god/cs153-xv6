#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

int test(int n)
{
   test(n+1);
   return n;
}
int main(int argc, char *argv[])
{
   int pid=0;
   pid=fork();
	 
   if(pid==0){
   int x=1;
   printf(1, "address %x\n", &x);
   test(x);
   exit();
   }
   wait();
   exit();
}
