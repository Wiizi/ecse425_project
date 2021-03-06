
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

  add wave -group "SIGNALS"   -position end -radix decimal sim:/cpu_test/PC_addr_out\

  add wave -group "INSTMEM"   -position end -radix decimal sim:/cpu_test/InstMem_counter\
                              -radix decimal sim:/cpu_test/InstMem_IntegerAddr\
                              -radix binary sim:/cpu_test/Imem_inst_in

  add wave -group "DATAMEM"   -position end -radix decimal sim:/cpu_test/DataMem_addr\
                              -radix binary sim:/cpu_test/DataMem_re\
                              -radix binary sim:/cpu_test/DataMem_we\
                              -radix binary sim:/cpu_test/MEM_WB_data\
                              -radix binary sim:/cpu_test/DataMem_data\
                              -radix binary sim:/cpu_test/DataMem_busy
  add wave -group "RegIn"     -position end -radix decimal sim:/cpu_test/rs\
                              -radix decimal sim:/cpu_test/rt\
                              -radix decimal sim:/cpu_test/Rd_W\
                              -radix decimal sim:/cpu_test/Result_W\
                              -radix decimal sim:/cpu_test/ALU_LO\
                              -radix decimal sim:/cpu_test/ALU_HI\
                              -radix decimal sim:/cpu_test/data0\
                              -radix decimal sim:/cpu_test/data1\
                              -radix decimal sim:/cpu_test/ALU_LO_out\
                              -radix decimal sim:/cpu_test/ALU_HI_out

  add wave -group "Registers" -position end -radix decimal sim:/cpu_test/r0\
                              -radix decimal sim:/cpu_test/r1\
                              -radix decimal sim:/cpu_test/r2\
                              -radix decimal sim:/cpu_test/r3\
                              -radix decimal sim:/cpu_test/r4\
                              -radix decimal sim:/cpu_test/r5\
                              -radix decimal sim:/cpu_test/r6\
                              -radix decimal sim:/cpu_test/r7\
                              -radix decimal sim:/cpu_test/r8\
                              -radix decimal sim:/cpu_test/r9\
                              -radix decimal sim:/cpu_test/r10\
                              -radix decimal sim:/cpu_test/r11\
                              -radix decimal sim:/cpu_test/r12\
                              -radix decimal sim:/cpu_test/r13\
                              -radix decimal sim:/cpu_test/r14\
                              -radix decimal sim:/cpu_test/r15\
                              -radix decimal sim:/cpu_test/r16\
                              -radix decimal sim:/cpu_test/r17\
                              -radix decimal sim:/cpu_test/r18\
                              -radix decimal sim:/cpu_test/r19\
                              -radix decimal sim:/cpu_test/r20\
                              -radix decimal sim:/cpu_test/r21\
                              -radix decimal sim:/cpu_test/r22\
                              -radix decimal sim:/cpu_test/r23\
                              -radix decimal sim:/cpu_test/r24\
                              -radix decimal sim:/cpu_test/r25\
                              -radix decimal sim:/cpu_test/r26\
                              -radix decimal sim:/cpu_test/r27\
                              -radix decimal sim:/cpu_test/r28\
                              -radix decimal sim:/cpu_test/r29\
                              -radix decimal sim:/cpu_test/r30\
                              -radix decimal sim:/cpu_test/r31
  add wave -group "CONTROLIN" -position end -radix binary sim:/cpu_test/IF_ID_opCode\
                              -radix binary sim:/cpu_test/IF_ID_funct

  add wave -group "CONTROL"   -position end -radix binary sim:/cpu_test/ALUOpcode\
                              -radix binary sim:/cpu_test/RegDest\
                              -radix binary sim:/cpu_test/Branch\
                              -radix binary sim:/cpu_test/ALUSrc\
                              -radix binary sim:/cpu_test/BNE\
                              -radix binary sim:/cpu_test/Jump\
                              -radix binary sim:/cpu_test/LUI\
                              -radix binary sim:/cpu_test/ALU_LOHI_Write\
                              -radix binary sim:/cpu_test/ALU_LOHI_Read\
                              -radix binary sim:/cpu_test/MemWrite\
                              -radix binary sim:/cpu_test/MemRead\
                              -radix binary sim:/cpu_test/MemtoReg\
                              -radix binary sim:/cpu_test/cpu_test_stall\
                              -radix binary sim:/cpu_test/regWrite

  add wave -group "ALU IN"    -position end -radix binary sim:/cpu_test/ALUOpcode\
                              -radix decimal sim:/cpu_test/ALU_data0\
                              -radix decimal sim:/cpu_test/ALU_data1\
                              -radix decimal sim:/cpu_test/ALU_shamt

  add wave -group "ALU OUT"   -position end -radix decimal sim:/cpu_test/ALU_data_out\
                              -radix decimal sim:/cpu_test/ALU_HI\
                              -radix decimal sim:/cpu_test/ALU_LO\
                              -radix binary sim:/cpu_test/zero

  ;#Set some formating options to make the Waves window more legible
  configure wave -namecolwidth 250
  WaveRestoreZoom {0 ns} {1100 ns}
}

;#Generates a clock of period with desired ns length on the port input pin of the cpu_test
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
  vcom ALU.vhd
  vcom Memory_in_Byte.vhd
  vcom Main_Memory.vhd
  vcom memory_arbiter_lib.vhd
  vcom memory.vhd
  vcom Control_Unit.vhd
  vcom EX_MEM.vhd
  vcom HazardDetectionControl.vhd
  vcom ID_EX.vhd
  vcom IF_ID.vhd
  vcom Mux_2to1.vhd
  vcom Mux_3to1.vhd
  vcom PC.vhd
  vcom Registers.vhd
  vcom Forwarding.vhd
  vcom Haz_mux.vhd
  vcom MEM_WB.vhd
  vcom cpu_test.vhd
  
  ;#Start a simulation session with the cpu_test component
  vsim -t ps cpu_test
  
  ;#Add the cpu_test signals to the waves window
  ;#to allow inspecting the module's behavior
  AddWaves
  
  ;#Generate a cpu_test clock
  GenerateClock clk 20
  GenerateClock clk_mem 4

  ;#Update all signals
  run 1000 ns;

  ;# tests pc updates
}

proc CompileOnly {} {
  ;#Create the work library, which is the default library used by ModelSim
  vlib work
  
  ;#Compile the cpu_test and its subcomponents
  vcom ALU.vhd
  vcom Memory_in_Byte.vhd
  vcom Main_Memory.vhd
  vcom memory_arbiter_lib.vhd
  vcom memory.vhd
  vcom Control_Unit.vhd
  vcom EX_MEM.vhd
  vcom HazardDetectionControl.vhd
  vcom ID_EX.vhd
  vcom IF_ID.vhd
  vcom Mux_2to1.vhd
  vcom Mux_3to1.vhd
  vcom PC.vhd
  vcom Registers.vhd
  vcom Forwarding.vhd
  vcom Haz_mux.vhd
  vcom MEM_WB.vhd
  vcom cpu_test.vhd
}
