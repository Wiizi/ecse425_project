This project includes a MIPS assembler written in Java which produces binary instructions from an .asm input file.
The assembler handles multiple error cases and exceptions, and prints relevant error messages to command line if errors occur.

In order to create a binary output from a given .asm file, follow these steps:

*************************************************************

OPTION 1 (IntelliJ):

Steps:
	1. Compile and run project using IntelliJ (Java 1.8) 

*************************************************************

OPTION 2 (Manual, UNIX):

Requirements:
1. UNIX environment
2. The project folder hierarchy must be maintained:
	Assembler source files: CPUS/cpu/bin
	.asm files: CPUS/cpu/tests

Steps:
	1. Compile the assembler:
		javac Driver.java
	2. Run the compiled Java program using the following syntax:
		java Driver filename.asm
		filename.asm must be a valid .asm file

*************************************************************

OPTION 3 (Use Assembler.exe):

Requirements:
1. UNIX environment
2. The project folder hierarchy must be maintained:
	Assembler.exe: CPUS/cpu/bin
	Assembler.c : CPUS/cpu/bin
	Assembler source files: CPUS/cpu/bin
	.asm files: CPUS/cpu/tests

Steps:
	0. (optional) Compile Assembler.c to create Assembler.exe using:
		gcc Assembler.c -o Assembler.exe
	1. run Assembler.exe using the following syntax:
		./Assembler.exe filename.asm


The assembler implements all instructions (29 required MIPS instructions + 3 testing instructions (asrt, asrti, halt)) according to the MIKA testing suite README documentation (although the assembler does not directly work with MIKA). 
Current Assembler.exe is intended to run only on UNIX environment.