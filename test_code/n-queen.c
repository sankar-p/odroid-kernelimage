# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <sched.h>
# include <math.h>
# include <sys/resource.h>
# include <sys/syscall.h>
# include "last_cpu.h"
	
int **chessboard = NULL;
int nqueen_soln = 0;

double converttodouble(struct timeval t)
{
	double dtime = 0;
	dtime = t.tv_sec;
	dtime += (t.tv_usec * pow(10,-6));
	return dtime;
}

int check(int row, int col, int n)
{
	int i, j;

	/* left upper diagonal */
	for(i = row-1, j = col-1; i >= 0 && j >= 0; i--, j--)
		if(chessboard[i][j] != 0)
			return 0;
	
	/* right upper diagonal */
	for(i = row-1, j = col+1; i >= 0 && j < n; i--, j++)
		if(chessboard[i][j] != 0)
			return 0;

	/* left lower diagonal */
	for(i = row+1, j = col-1; i < n && j >= 0; i++, j--)
		if(chessboard[i][j] != 0)
			return 0;

	/* right lower diagonal */
	for(i = row+1, j = col+1; i < n && j < n; i++, j++)
		if(chessboard[i][j] != 0)
			return 0;

	/* check each row same column */
	for(i = 0;i < n;i++)
		if(chessboard[i][col] != 0 && i != row)
			return 0;

	/* check same row each col */
	for(i = 0;i < n;i++)
		if(chessboard[row][i] != 0 && i != col)	
			return 0;

	return 1;
}

void print_board(int n)
{
	int i, j;
	for(i = 0;i < n;i++)
	{
		for(j = 0;j < n;j++)
		{
			printf("%d ", chessboard[i][j]);
		}
		printf("\n");
	}
	printf("\n\n");
}

void simulate(int row, int queens_placed, int n)
{
	int col, i;
	
	/* Try the placing the queen in each columns */
	for(col = 0;col < n; col++)
	{
		/* Search for vacancy */
		if(check(row, col, n))
		{
			chessboard[row][col] = 1;
			queens_placed++;
			if(row < n)			
				simulate(row + 1, queens_placed, n);
		}
		else
			continue;

		if(queens_placed == n)
		{
			nqueen_soln++;
			//print_board(n);
		}

		chessboard[row][col] = 0;
		queens_placed--;
	}
}

int main(int argc, char **argv)
{
	int n, i;
	int cpu;
	unsigned int mask;
	struct timeval start, end;
	char command[100];
	FILE *fp;
	int pid = 0;
	int pri = 100;

	printf("syscall return : %d\n", syscall(349));

	
	/* Default for 8 rows and 8 columns */
	if(argc < 2)
		n = 8; 
	/* Get the number of rows and columns */
	else
		n = atoi(argv[1]);	

	if(argc < 3)
		cpu = 0;
	else
	{
		cpu = atoi(argv[2]);
		mask = 1 << cpu;
		syscall(__NR_sched_setaffinity, 0, sizeof(unsigned int), &mask);
	}
	
	chessboard = (int **)malloc(sizeof(int *) * n);
	if(chessboard == NULL)
	{
		printf(" *** No mem *** ");
		return 0;
	}

	for(i = 0;i < n; i++)
	{
		chessboard[i] = (int *)malloc(sizeof(int) * n);
		if(chessboard[i] == NULL)
		{
			printf(" *** No mem ***");
			return 0;
		}
	}

	gettimeofday(&start, NULL);
	simulate(0, 0, n);
	gettimeofday(&end, NULL);

	printf("normal Solution : %d\n", nqueen_soln);
	printf("\ntime - %lf\n", converttodouble(end) - converttodouble(start)); 

	return 0;
}
