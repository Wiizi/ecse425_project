
;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the memory module. This
;# allows the developers to inspect the behavior of the memory  
;# arbiter component as it is being simulated.
proc AddWaves {} {

	;#Add the following signals to the Waves window
	add wave -group "CLOCKS" -position end -radix binary sim:/cpu_test/clk\
                                          -radix binary sim:/cpu_test/clk_mem
  
  ;#These signals will be contained in a group
	;# add wave -group "SIGNALS" -radix hex sim:/memory/addr\

  add wave -group "SIGNALS"   -radix decimal sim:/cpu_test/PC_addr_out\

  add wave -group "MEMORY"  -radix decimal sim:/cpu_test/Imem_addr_in\
                              -radix binary sim:/cpu_test/InstMem_address\
                              -radix binary sim:/cpu_test/Imem_inst_in

  ;#Set some formating options to make the Waves window more legible
	configure wave -namecolwidth 250
	WaveRestoreZoom {0 ns} {1100 ns}
}

;#Generates a clock of period with desired ns length on the port input pin of the cpu
proc GenerateClock {port period} { 
  force -deposit /cpu_test/$port 0 0 ns, 1 [expr $period/2.0] ns -repeat $period ns
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
  vcom cpu_test.vhd
  vcom Forwarding.vhd
  vcom Haz_mux.vhd
  
  ;#Start a simulation session with the cpu component
  vsim -t ps cpu_test
	
  ;#Add the cpu signals to the waves window
  ;#to allow inspecting the module's behavior
	AddWaves
  
  ;#Generate a CPU clock
	GenerateClock clk 20
  GenerateClock clk_mem 4

  ;#Update all signals
  run 1000 ns;

  ;# tests pc updates
}

proc CompileOnly {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the cpu and its subcomponents
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
  vcom cpu_test.vhd
  vcom Forwarding.vhd
  vcom Haz_mux.vhd
}
