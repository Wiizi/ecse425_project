
;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the memory arbiter. This
;# allows the developers to inspect the behavior of the memory  
;# arbiter component as it is being simulated.
proc AddWaves {} {

	;#Add the following signals to the Waves window
	add wave -position end  -radix binary sim:/memory/clk
  
  ;#These signals will be contained in a group named "Port 1"
	add wave -group "Memory"  -radix hex sim:/memory/addr\
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

;#Generates a clock of period 1 ns on the clk input pin of the memory arbiter.
proc GenerateCPUClock {} { 
	force -deposit /memory/clk 0 0 ns, 1 0.5 ns -repeat 1 ns
}

;#The following functions "place" a read or write on the inputs of the
;#selected port. However, they do not start the operations right away. This is 
;#because the user might want to place another read or write operation on the
;#other port at the same time. Once all operations have been set, use the
;#WaitForPort or WaitForPort functions to move time forward until any or
;#all the operations complete.
proc PlaceRead {addr} {
  force -deposit /memory/addr 16#$addr 0 0
  force -deposit /memory/data "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  force -deposit /memory/we 0 0
  force -deposit /memory/re 1 0
  run 0 ;#Force signals to update right away
}

proc PlaceWrite {addr data} {
  force -deposit /memory/addr 16#$addr 0
  force -deposit /memory/data 16#$data 0
  force -deposit /memory/we 1 0
  force -deposit /memory/re 0 0
  run 0 ;#Force signals to update right away
}

;#Moves time forward until either the operation on Port 1 or Port 2 is complete.
;#An operation is considered complete on a port when the port's busy signal goes low.
proc WaitForPort {} {
  ;# Only wait if there is a transaction pending
  if {[exa /memory/re] == 1 ||
      [exa /memory/we] == 1 } {
    
    run 1 ns
    
    ;# Wait for at least one port to be free 
    while {[exa /memory/busy] == 1 } {
      run 1 ns
    }
    
    ResetEnableSignalsIfReady
    run 0
  }
}


;#Function used to reset the read enable and write enable signals to low
;#once a read or write operation is complete.
proc ResetEnableSignalsIfReady {} {
  ;# Reset the re and we signals for the ports that just finished their transaction
  if {[exa /memory/busy] == 0} {
    force -deposit /memory/re 0 0
    force -deposit /memory/we 0 0
  }
}

;#Function used to reset the read enable and write enable signals to low
;#once a read or write operation is complete.
proc ResetDataIfReady {} {
  ;# Reset the re and we signals for the ports that just finished their transaction
  if {[exa /memory/busy] == 0} {
    force -deposit /memory/data "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  }
}

;#This function compiles the memory arbiter and its submodules.
;#It initializes a memory arbiter simulation session, and
;#sets up the Waves window to contain useful input/output signals
;#for debugging.
proc InitMemory {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the memory arbiter and its subcomponents
  vcom Memory_in_Byte.vhd
  vcom Main_Memory.vhd
  vcom memory_arbiter_lib.vhd
  vcom memory.vhd
  
  ;#Start a simulation session with the memory_arbiter component
  vsim -t ps memory
	
  ;#Add the memory_arbiter's input and ouput signals to the waves window
  ;#to allow inspecting the module's behavior
	AddWaves
  
  force -deposit /memory/addr 0 0
  force -deposit /memory/data "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 0
  force -deposit /memory/re 0 0
  force -deposit /memory/we 0 0
  
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
  
  set testResult [expr [ReadMemoryWord 0] == 0xFFFAFFFA]
  
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
  
  set testResult [expr [ReadMemoryWord 5] == 0xFFFAFFFF]
  
  echo [ReadMemoryWord 5]

  return $testResult
}

;# Utility function used to examine a word at a given address in main memory.
proc ReadMemoryWord {addr} {
  set wordIndex [expr $addr / 4]
  set byte0 [exa -radix unsigned /memory/main_memory/Block0/Memory($wordIndex)]
  set byte1 [exa -radix unsigned /memory/main_memory/Block1/Memory($wordIndex)]
  set byte2 [exa -radix unsigned /memory/main_memory/Block2/Memory($wordIndex)]
  set byte3 [exa -radix unsigned /memory/main_memory/Block3/Memory($wordIndex)]
  
  set word [format %u [expr ($byte3 << 24) | ($byte2 << 16) | ($byte1 << 8) | $byte0]]
  
  return $word
}