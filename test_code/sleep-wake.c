#include <stdio.h>
#include "last_cpu.h"
#include "time-measure.h"

#define ITER 999999
#define HITER 100

int main(int argc, char **argv)
{
	int i, j, pid;
	int sum = 0;
	int sleeptime = 1;
	int iter = ITER;
	int util = 50;
	struct timeval start, end;
	double tval = 0, tmp, total;

	if(argc > 1)
		util = atoi(argv[1]);

	pid = getpid();

	for(;;)
	{
		printf("%d runs on cpu %d\n", pid, last_cpu_scheduled());
		gettimeofday(&start, NULL);
		for(j = 0;j < HITER; j++)
			for(i = 0;i < iter; i++)
				sum += i; 
		gettimeofday(&end, NULL);

		tval = timediff(end, start);
		tmp = tval * 100 / util;
		usleep((int)tmp - tval); 
		total = tmp + tmp - tval;
		printf("compute %lf sleep %lf\n", (tval/total), ((tmp-tval)/total));
		sum = 0;
	}
	return 0;
}
