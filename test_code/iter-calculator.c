#include <stdio.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include "last_cpu.h"
#include "time-measure.h"
#include <signal.h>
#include <stdlib.h>

#define ITER 999999
#define HITER 10
#define OITER 25

typedef int bool;
#define true 1
#define false 0
FILE *fp;

void sig_handler(int signo)
{
	if (signo == SIGINT || signo == SIGKILL || signo == SIGTERM)
	{
		//printf("closing signal received");
		fflush(fp);
		fclose(fp);
		exit(0);
	}
	return;
}

int main(int argc, char **argv)
{
	int i, j, k, pid;
	int sum = 0;
	int sleeptime = 1;
	int util = 100;
	struct timeval start, end;
	double tval = 0, total = 0;
	unsigned int mask;
	int iter_ctr = 0;
	FILE *fp;

	if(argc > 1)
	{
		int cpu = atoi(argv[1]);
		mask = 1 << cpu;
		syscall(__NR_sched_setaffinity, 0, sizeof(unsigned int), &mask);
	}

	fp = fopen("t-iter", "w");
	if(fp == NULL)
		return 0;

	pid = getpid();
	//if (signal(SIGINT, sig_handler) == SIG_ERR)
	//	printf("\ncan't catch SIGINT\n");

	for(k = 0;k < OITER; k++)
	{
		//printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		gettimeofday(&start, NULL);
		for(j = 0;j < HITER; j++)
			for(i = 0;i < ITER; i++)
				sum += i; 
		gettimeofday(&end, NULL);

		tval = timediff(end, start);
		total += tval;
		sum = 0;
		//printf("iteration over\n");
	}

	fprintf(fp, "%d\n", (int)total/OITER);
	fclose(fp);
	return 0;
}
