This project includes a MIPS assembler written in Java which produces binary instructions from an .asm input file.
The assembler implements all required instructions (29 MIPS instructions + 3 testing instructions (asrt, asrti, halt)) according to the MIKA testing suite README documentation (although the assembler does not directly work with MIKA). The assembler also handles multiple error cases and exceptions, and prints relevant error messages to command line if errors occur.

In order to create a binary output from a given .asm file, follow these steps:

Requirements:
1. UNIX or Windows environment
2. The project folder hierarchy must be maintained:
	Assembler source files: CPUS/cpu/bin
	.asm files: CPUS/cpu/tests

Steps:
	1. Compile the assembler:
		javac Driver.java
	2. Run the compiled Java program using the following syntax:
		java Driver filename.asm
		filename.asm must be a valid .asm file placed at CPUS/cpu/tests

The output filename.dat will be placed in CPUS/cpu/tests folder.

To use the produced .dat file, rename filename.dat to Init.dat and place it in CPUS/cpu/src folder, after which the cpu_compiler.tcl script can be run.