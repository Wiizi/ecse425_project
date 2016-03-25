**********************************************************
* How to DEVELOP your CPU
**********************************************************

A skeleton CPU project has been placed in CPUS\cpu\src folder.
Your CPU code must go in the cpu.vhd file at this location.
You may add new files to this folder but please do not delete
the ones that are already there.


**********************************************************
* How to COMPILE and SIMULATE your CPU
**********************************************************

Launch the LiveCPU.bat file to automatically open a ModelSim
window, compile your CPU, and simulate it. In order to profit
the most from this feature, you must be diligent and update
the CPUS\cpu\scripts\livecpulib.tcl file in the following ways:

1. When adding a new VHDL file to your CPU's implementation
   (e.g. ALU.vhd), you must add a corresponding line to the
   CompileCPU in livecpulib.tcl. In this case this would mean
   adding the following line:

   CompileComponent ALU

   The lines must be added in the proper dependency
   order. For example, if the ALU is needed by the CPU, the
   line must be placed before 'CompileComponent cpu'.

2. Add the signals you want to see in the Waves window
   to the AddWaves function in livecpulib.tcl. The waves
   added here will automatically be loaded in ModelSim
   when you open LiveCPU.bat.

IMPORTANT NOTE:

Using the LiveCPU.bat will ensure your CPU files
are compiled at the right locationn for using the MIKA
test suite described below.

**********************************************************
* How to TEST your CPU
**********************************************************

Using the MIKA.exe application is a convenient approach to
testing your CPU. MIKA is a .NET GUI application which allows
you to develop your own assembly test cases and execute them 
on a simulated version of your CPU at the click of a button. 

In order to use MIKA, however, you must
complete the following tasks:

1. Develop your assembler command line application and place it
   in the CPUS\cpu\bin folder. 

   When asked to execute a test,
   MIKA will use this assembler to assemble your test cases
   using the "machine code" format specified in class.

2. Develop your test cases and place them in the
   CPUS\cpu\tests folder.
 
   The test cases must be in individual .asm files,
   written using the assembly instruction subset used
   by the project. Two sample tests are included.

3. Make sure you have a working CPU implementation.

   Specifically, in order for MIKA to be useful,
   your CPU must support the following features:

   a) Reliably set the finished_prog output signal
      to '1' when encountering the 'halt' instruction.
      This allows MIKA to understand when a program's
      execution is over.

   b) Reliably set the 'assertion' output signal to
      '1' when an 'asrt' or 'asrti' instruction fails.
      For example, if 'asrti $1 100' is executed and
      your CPU determines that register $1's value is
      not 100, it should set the assertion signal to '1'.
      This lets MIKA know that a test case failed.

   c) Reliably set the 'assertion_pc' output signal to
      the value of the program counter corresponding to
      the assert instruction that failed. This will allow
      MIKA to tell you which assertion failed.

IMPORTANT NOTE:

MIKA does not automatically recompile your CPU before
running a test. Therefore, if you make changes to your
CPU's source code, either close ModelSim and re-run
LiveCPU.bat or execute the CompileCPU function from
within your existing ModelSim window.


