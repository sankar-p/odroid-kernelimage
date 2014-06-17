#include <stdio.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include "last_cpu.h"
#include "time-measure.h"
#include <signal.h>
#include <stdlib.h>

#define ITER 999999
#define HITER 10

typedef int bool;
#define true 1
#define false 0
FILE *fp;

void sig_handler(int signo)
{
	if (signo == SIGINT || signo == SIGKILL || signo == SIGTERM)
	{
		printf("closing signal received");
		fflush(fp);
		fclose(fp);
		exit(0);
	}
	return;
}

int main(int argc, char **argv)
{
	int i, j, pid;
	int sum = 0;
	int sleeptime = 1;
	int iter = ITER;
	int util = 50;
	struct timeval start, end;
	double tval = 0, tmp, t1, t2;
	unsigned int mask;
	int iter_ctr = 0;
	bool filewrite = false;

	if(argc > 1)
		util = atoi(argv[1]);

	if(argc > 2)
	{
		int cpu = atoi(argv[2]);
		mask = 1 << cpu;
		syscall(__NR_sched_setaffinity, 0, sizeof(unsigned int), &mask);
	}

	if(argc > 3)
	{
		fp = fopen(argv[3], "w");
		printf("log file opened\n");
		if(fp != NULL)
			filewrite = true;
	}

	pid = getpid();
	if (signal(SIGINT, sig_handler) == SIG_ERR)
		printf("\ncan't catch SIGINT\n");

	for(;;)
	{
		//printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		gettimeofday(&start, NULL);
		for(j = 0;j < HITER; j++)
			for(i = 0;i < iter; i++)
				sum += i; 
		gettimeofday(&end, NULL);

		tval = timediff(end, start);
		tmp = tval * 100 / util;
		usleep((int)tmp - tval); 
		t1 = tval/tmp;
		t2 = (tmp-tval)/tmp;
		//printf("compute %lf sleep %lf\n", t1, t2);
		//printf("compute %lf sleep %d\n", tval, (int)(tmp-tval));
		if(filewrite == true)
			fprintf(fp, "%d ", ++iter_ctr);
		sum = 0;
	}
	return 0;
}
