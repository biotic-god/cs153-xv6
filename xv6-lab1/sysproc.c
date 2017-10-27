#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

// cs 153
int
sys_exit(void) // m
{
  int st;
  argint(0, &st);
  exit(st);
  return 0;  // not reached
}

int
sys_wait(void) // m
{
  int *st;
  argptr(0, (char **)&st, 8);
  return wait(st);
}

int
sys_waitpid() // m
{
  int *st;
  int pid;
  int op;
  argint(0, &pid);
  argptr(0, (char **)&st, 8);
  argint(0, &op);
  return waitpid(pid, st, op);
}
int sys_setprio() // m
{
  int prio;
  argint(0,&prio);
  setprio(prio);
  return 0;
}
int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
