#include <stdio.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include "last_cpu.h"
#include "time-measure.h"
#include <signal.h>
#include <stdlib.h>

#define OITER 100
#define MITER 50
#define IITER 99999

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
	int util = 50, runtime_val;
	struct timeval start, end;
	double tval = 0, tmp, t1, t2;
	unsigned int mask;
	int iter_ctr = 0;
	bool filewrite = false, runtime = false;

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
		if(fp != NULL)
			filewrite = true;
	}

	if(argc > 4)
	{
		//printf("runtimeval %s\n", argv[4]);
		runtime_val = atoi(argv[4]);
		runtime = true;	
	}

	pid = getpid();
	if (signal(SIGINT, sig_handler) == SIG_ERR)
		printf("\ncan't catch SIGINT\n");

	for(k = 0; k < OITER; k++)
	{
		//printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		gettimeofday(&start, NULL);
		for(j = 0;j < MITER; j++)
			for(i = 0;i < IITER; i++)
				sum += i; 
		gettimeofday(&end, NULL);

		tval = timediff(end, start);
		if(runtime == true)
		{
			tmp = runtime_val * 100 / util;
		}
		else
		{
			tmp = tval * 100 / util;
		}
		
		//printf("compute %lf sleep %lf\n", t1, t2);
		//printf("compute %lf sleep %d\n", tval, (int)(tmp-tval));
		usleep((unsigned int)(tmp - tval)); 
		//printf("%f %u %d\n", tval, (unsigned int)(tmp-tval), util);
		//t1 = tval/tmp;
		//t2 = (tmp-tval)/tmp;

		if(filewrite == true)
			fprintf(fp, "%lf %lf %d\n", converttodouble(start), converttodouble(end), ++iter_ctr);
		//printf("%lf %lf %d\n", converttodouble(start), converttodouble(end), ++iter_ctr);
		sum = 0;
	}
	
	fflush(fp);
	fclose(fp);
	return 0;
}
