#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/wait.h>

int executecmd(char **args)
 {
 	int pid, wpid, status;
 	pid = fork();
	// Child process
 	if (pid == 0) {
 		if (execvp(args[0], args) == -1) {
 			perror("error during child process");
 		}
 		exit(EXIT_FAILURE);
 	} 
 	// error handling
 	else if (pid < 0) {
 		perror("error during forking");
 	} 
	// parent process
 	else if (pid > 0){
 		// wait on the process
 		do {
 			wpid = waitpid(pid, &status, WUNTRACED);
 		} 
 		while (!WIFEXITED(status) && !WIFSIGNALED(status));
 	}
 	return 1;
 }

 int main(int argc, char **argv)
 {
 	if (argc < 2)
 		exit(EXIT_FAILURE);
 	char* args[3];
 	// compile Driver.java
 	args[0] = "javac";
 	args[1] = "Driver.java";
 	args[2] = NULL;
	executecmd(args);
	// run Driver for the Assembler
 	args[0] = "java";
 	args[1] = "Driver";
 	args[2] = argv[1];
	executecmd(args);
 	return 1;
 }