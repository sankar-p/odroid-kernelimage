# include <sys/stat.h>
# include <stdio.h>
# include <fcntl.h>

#define BUFSIZE 256
#define LASTCPUINDEX 39

int main()
{
	static int file = 0;
	static char filename[64];
	static int pid = -1;
	char buffer[BUFSIZE];
	char *pch;
	int ret;
	int moving_index = 0;

	if(pid == -1)
	{
		pid = getpid();
		sprintf(filename, "/proc/%d/stat", pid);	
		printf("%s\n", filename);
		file = open(filename, O_RDONLY);		
		if(file == -1)
			return -1;
	}

	ret = read(file, buffer, BUFSIZE); 	
	if(ret == -1)
		return -1;

	pch = strtok(buffer, " ");
	moving_index++;
	while (pch != NULL)
	{
		if(moving_index >= LASTCPUINDEX)
			break;
		pch = strtok(NULL, " ");	
		moving_index++;
	}

	printf("cpu %d\n", atoi(pch));
	return 0;
}
