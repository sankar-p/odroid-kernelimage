#include <stdio.h>
#include "last_cpu.h"

#define ITER 999999

int main()
{
	int i, pid;
	int sum = 0;

	pid = getpid();

	for(;;)
	{
		printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		for(i = 0;i < ITER; i++)
			sum += i; 
		printf("sum %d", sum);
		usleep(500000); 
		sum = 0;
	}
	return 0;
}
