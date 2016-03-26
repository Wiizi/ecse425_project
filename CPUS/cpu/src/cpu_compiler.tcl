
;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the memory module. This
;# allows the developers to inspect the behavior of the memory  
;# arbiter component as it is being simulated.
proc AddWaves {} {

	;#Add the following signals to the Waves window
	add wave -group "CLOCKS" -position end -radix binary sim:/cpu/clk
                                          -radix binary sim:/cpu/clk_mem
  
  ;#These signals will be contained in a group named "Port 1"
	add wave -group "SIGNALS" -radix hex sim:/memory/addr\
                            -radix hex sim:/memory/data\
                            -radix binary sim:/memory/re\
                            -radix binary sim:/memory/we\
                            -radix binary sim:/memory/busy\
                            -radix binary sim:/memory/mm_rd_ready\
                            -radix binary sim:/memory/mm_wr_done

  add wave -group "REGISTERS"  -radix hex sim:/memory/addr\
                               -radix hex sim:/memory/data\
                               -radix binary sim:/memory/re\
                               -radix binary sim:/memory/we\
                               -radix binary sim:/memory/busy\
                               -radix binary sim:/memory/mm_rd_ready\
                               -radix binary sim:/memory/mm_wr_done

  ;#Set some formating options to make the Waves window more legible
	configure wave -namecolwidth 250
	WaveRestoreZoom {0 ns} {8 ns}
}

;#Generates a clock of period with desired ns length on the port input pin of the cpu
proc GenerateClock {port , period} { 
  force -deposit /memory/$port 0 0 ns, 1 [expr $period/2] ns -repeat $period ns
}

;#This function compiles the memory unit and its submodules.
;#It initializes a memory unit simulation session, and
;#sets up the Waves window to contain useful input/output signals
;#for debugging.
proc CompileAndSimulate {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the memory unit and its subcomponents
  vcom Memory_in_Byte.vhd
  vcom Main_Memory.vhd
  vcom memory_arbiter_lib.vhd
  vcom memory.vhd
  vcom ALU
  vcom Control_Unit
  vcom EX_MEM
  vcom HazardDetectionControl
  vcom IF_EX
  vcom IF_ID
  vcom Mux_2to1
  vcom Mux_3to1
  vcom PC
  vcom Registers
  vcom cpu
  
  ;#Start a simulation session with the memory component
  vsim -t ps memory
	
  ;#Add the memory_arbiter's input and ouput signals to the waves window
  ;#to allow inspecting the module's behavior
	AddWaves
  
  force -deposit /memory/addr 0 0
  force -deposit /memory/data "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  force -deposit /memory/re 0 0
  force -deposit /memory/we 0 0
  
  ;#Generate a CPU clock
	GenerateClock clk 20
  GenerateClock clk_mem 4

  run 0;
}

proc CompileOnly {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the memory unit and its subcomponents
  vcom Memory_in_Byte.vhd
  vcom Main_Memory.vhd
  vcom memory_arbiter_lib.vhd
  vcom memory.vhd
  vcom ALU.vhd
  vcom Control_Unit.vhd
  vcom EX_MEM.vhd
  vcom HazardDetectionControl.vhd
  vcom ID_EX.vhd
  vcom IF_ID.vhd
  vcom Mux_2to1.vhd
  vcom Mux_3to1.vhd
  vcom PC.vhd
  vcom Registers.vhd
  vcom cpu.vhd
}
