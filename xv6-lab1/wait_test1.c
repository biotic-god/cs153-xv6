#include "types.h"
#include "user.h"

int main(void)
{
	printf(1, "Parent no child, start waiting\n");
	printf(1, "wait %d\n", wait(0));
	printf(1, "Parent no child finished\n");
	printf(1, "********************************\n");
	int pid = fork();
	if(pid > 0){
		printf(1, "Parent has child, start waiting\n");
		printf(1, "wait %d\n", wait(0));
		printf(1, "Parent has child finished\n");
	}
	else if(pid == 0){
		printf(1, "Child, start sleeping\n");
		sleep(300);
		printf(1, "Child finished\n");
	}
	exit(0);
}

