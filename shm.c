#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id = -1;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_create(int table_id) {
	int page_id;
	char* memory;
	struct proc *curproc = myproc();
	if(table_id < 0 || table_id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == -1) break;
	if(page_id == MAXPPP){
		cprintf("Proc: %d, process is full\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[table_id].refcnt != 0){
		cprintf("Proc: %d, id %d already exits\n",curproc->pid, table_id);
		release(&(shm_table.lock));
		return -1;
	}
	if((memory = kalloc())==0){
		cprintf("Proc: %d, allocation error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[table_id].id = table_id;
	shm_table.shm_pages[table_id].refcnt++;
	memset(memory, 0, PGSIZE);
	shm_table.shm_pages[table_id].frame = memory;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = table_id;
	return page_id;
}
int shm_open(int id, char **pointer) {
	int page_id = -1;
	uint address;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if (shm_table.shm_pages[id].refcnt == 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, id %d is not created\n",curproc->pid, id);
		if((page_id = shm_create(id))==-1){
			cprintf("Proc: %d, id %d cannot be created\n",curproc->pid, id);
			return -1;
		}
		acquire(&(shm_table.lock));
	}
	if(page_id == -1){
		for(page_id = 0; page_id < MAXPPP; page_id++)  
			if(curproc->pages[page_id].id  == id) break;
		if(page_id == MAXPPP){
			for(page_id = 0; page_id < MAXPPP; page_id++)  
				if(curproc->pages[page_id].id == -1) break;
			if(page_id == MAXPPP){
      	release(&(shm_table.lock));
      	cprintf("Proc: %d, process is full\n",curproc->pid);
				return -1; 
    	}
			curproc->pages[page_id].id = id;
			curproc->pages[page_id].vaddr = 0;
			shm_table.shm_pages[id].refcnt++;
  	} 
	}
	if(curproc->pages[page_id].vaddr == 0){
    if((address = allocshm(curproc->pgdir,shm_table.shm_pages[id].frame)) == -1){
			release(&(shm_table.lock));
			cprintf("Proc: %d, allocshm error\n",curproc->pid);
			return -1;
		}
		curproc->pages[page_id].vaddr = (char*) address;
  }
	release(&(shm_table.lock));
	*pointer = curproc->pages[page_id].vaddr;
	return 0;
}


int shm_close(int id) {
	int page_id;
	int flag = 0;
	struct proc *curproc = myproc();
	if(id < 0 || id >= 64){
		cprintf("Proc: %d, invalid id\n",curproc->pid);
		return -1;
	}
  for(page_id = 0; page_id < MAXPPP; page_id++)
		if(curproc->pages[page_id].id == id) break;
	if (page_id == MAXPPP){
		cprintf("Proc: %d, not held by current process\n",curproc->pid);
		return -1;
	}
	acquire(&(shm_table.lock));
	if(shm_table.shm_pages[id].refcnt <= 0){
		release(&(shm_table.lock));
		cprintf("Proc: %d, empty entry in table\n",curproc->pid);
		return -1;
	}
	shm_table.shm_pages[id].refcnt--;
  if(curproc->pgdir == 0) {
		cprintf("Proc: %d, pgdir nonexist error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	if(shm_table.shm_pages[id].refcnt <= 0){
		flag = 1;
		shm_table.shm_pages[id].id = -1;
	}
	if(removeshm(curproc->pgdir, shm_table.shm_pages[id].frame, flag) < 0){
		shm_table.shm_pages[id].frame = 0;
		cprintf("Proc: %d, remove page error\n",curproc->pid);
		release(&(shm_table.lock));
		return -1;
	}
	shm_table.shm_pages[id].frame = 0;
	release(&(shm_table.lock));
	curproc->pages[page_id].id = -1;
	curproc->pages[page_id].vaddr = 0;
	return 1;
}
