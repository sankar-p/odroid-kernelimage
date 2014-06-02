# include <sys/stat.h>
# include <stdio.h>

int main()
{
	int file;
	char filename[64];
	int pid;

	pid = getpid();
	sprintf(filename, "/proc/%d/stat", pid);	
}
