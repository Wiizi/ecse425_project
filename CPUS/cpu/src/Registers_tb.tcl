;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the Registers module. This
;# allows the developers to inspect the behavior of the Registers  
;# arbiter component as it is being simulated.
proc AddWaves {} {

	;#Add the following signals to the Waves window
	add wave -position end  -radix binary sim:/Registers/clk
  
  ;#These signals will be contained in a group named "Registers"
	add wave -group "Registers"  
							#inputs to Registers
							-radix hex sim:/Registers/clk\
                            -radix hex sim:/Registers/regWrite \
                            -radix binary sim:/Registers/ALU_LOHI_Write \
							-radix binary sim:/Registers/readReg_0 \
                            -radix binary sim:/Registers/readReg_1 \
                            -radix binary sim:/Registers/writeReg \
							-radix binary sim:/Registers/writeData \
                            -radix binary sim:/Registers/ALU_LO_in  \
                            -radix binary sim:/Registers/ALU_HI_in   \
							
							#outputs of Registers
							-radix binary sim:/Registers/readData_0   \
							-radix binary sim:/Registers/readData_1   \
							-radix binary sim:/Registers/ALU_LO_out   \
                            -radix binary sim:/Registers/ALU_HI_out 


  ;#Set some formating options to make the Waves window more legible
	configure wave -namecolwidth 250
	WaveRestoreZoom {0 ns} {8 ns}
}

;#Generates a clock of period 1 ns on the clk input pin of the Registers arbiter.
proc GenerateCPUClock {} { 
	force -deposit /Registers/clk 0 0 ns, 1 0.5 ns -repeat 1 ns
}

;#The following function "places" a read of 2 registers on the inputs of Registers.
proc PlaceRegRead {addr0, addr1} {
  force -deposit /Registers/readReg_0 addr0 0
  force -deposit /Registers/readReg_1 addr1 0
  run 0 ;#Force signals to update right away
}

;#The following function "write" of one register on the inputs of Registers.
proc PlaceRegWrite {addr data} {
  force -deposit /Registers/writeReg addr 0
  force -deposit /Registers/writeData data 0
  force -deposit /Registers/regWrite  1 0
  run 0 ;#Force signals to update right away
}

;#This function compiles the Registers unit and its submodules.
;#It initializes a Registers unit simulation session, and
;#sets up the Waves window to contain useful input/output signals
;#for debugging.
proc InitRegisters {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the Registers unit and its subcomponents
  vcom Registers.vhd
  
  ;#Start a simulation session with the Registers component
  vsim -t ps Registers
	
  ;#Add the Registers.vhd input and ouput signals to the waves window
  ;#to allow inspecting the module's behavior
	AddWaves
  
  ;# Init inputs to 0
  force -deposit /Registers/regWrite  0 0
  force -deposit /Registers/ALU_LOHI_Write  0 0
  
  force -deposit /Registers/readReg_0   0 0
  force -deposit /Registers/readReg_1   0 0
  force -deposit /Registers/writeReg   0 0

  force -deposit /Registers/writeData    "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  force -deposit /Registers/ALU_LO_in     "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  force -deposit /Registers/ALU_HI_in     "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  
  ;#Generate a CPU clock
	GenerateCPUClock
  
  run 1 ns
}

;# This testbench verifies write operation
proc TestWrite {} {
  
  ;# Initiate a write to the same address on both ports
	PlaceWrite 0 FFFAFFFA
  
  ;# Finish operation
  WaitForPort
  run 1 ns
  
  set testResult [expr [ReadRegistersWord 0] == 0xFFFAFFFA]
  
  return $testResult
}

;# This testbench verifies read operation after write
proc TestRAW {} {
  ;# place write
  PlaceWrite 5 FFFAFFFF
  
  WaitForPort
  run 1 ns
  
  ResetDataIfReady

  ;# Start a read
  PlaceRead 5
  WaitForPort
  
  set testResult [expr [ReadRegistersWord 5] == 0xFFFAFFFF]
  
  echo [ReadRegistersWord 5]

  return $testResult
}

;# Utility function used to examine a word at a given address in main Registers.
proc ReadRegistersWord {addr} {
  set wordIndex [expr $addr / 4]
  set byte0 [exa -radix unsigned /Registers/main_Registers/Block0/Registers($wordIndex)]
  set byte1 [exa -radix unsigned /Registers/main_Registers/Block1/Registers($wordIndex)]
  set byte2 [exa -radix unsigned /Registers/main_Registers/Block2/Registers($wordIndex)]
  set byte3 [exa -radix unsigned /Registers/main_Registers/Block3/Registers($wordIndex)]
  
  set word [format %u [expr ($byte3 << 24) | ($byte2 << 16) | ($byte1 << 8) | $byte0]]
  
  return $word
}
