In our project directory we have included VHDL testbeds and TCL scripts to individually test the following modules:
- ALU.vhd
- Control_Unit.vhd
- Forwarding.vhd
- Registers.vhd
- memory.vhd

To run the tests for a specific module:
(1) Open ModelSim.

(2) Create a new project.

(3) Add relevant files to project. (see below)

(4) In the ModelSim terminal enter “source” followed by the filename of the TCL script you wish to run. (see below)

(5) The tests will run automatically. Assert statements and errors will be printed in the ModelSim terminal and the Waveform window can be viewed to confirm results.


Relevant Files
*****ALU*****
ALU.vhd
ALU_tb.vhd
ALU_tb_script.tcl

run command: “source ALU_tb_script.tcl”


*****Control Unit*****
Control_Unit.vhd
Control_Unit_tb.vhd
Control_Unit_tb_script.tcl

run command: “source Control_Unit_tb_script.tcl”


*****Forwarding*****
Forwarding.vhd
Forwarding_tb.vhd
Forwarding_tb_script.tcl

run command: “source Forwarding_tb_script.tcl”


*****Registers*****
Registers.vhd
Registers_tb.vhd
Registers_tb_script.tcl

run command: “source Registers_tb_script.tcl”


*****Memory*****
memory.vhd
memory_tb.vhd
memory_tb_script.tcl
memory_arbiter_lib.vhd
Main_Memory.vhd
Memory_in_Bytes.vhd

run command: “source memory_tb_script.tcl”