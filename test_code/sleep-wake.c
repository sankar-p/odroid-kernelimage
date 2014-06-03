#include <stdio.h>
#include "last_cpu.h"

#define ITER 999999

int main(int argc, char **argv)
{
	int i, pid;
	int sum = 0;
	int sleeptime = 1;
	int iter = ITER;

	if(argc > 1)
		sleeptime = atoi(argv[1]);

	if(argc > 2)
		iter = atoi(argv[2]);

	pid = getpid();

	for(;;)
	{
		printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		for(i = 0;i < iter; i++)
			sum += i; 
		//printf("sum %d\n", sum);
		sleep(sleeptime); 
		sum = 0;
	}
	return 0;
}
