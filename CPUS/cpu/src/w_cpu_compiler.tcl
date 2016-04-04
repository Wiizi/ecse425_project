
;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the memory module. This
;# allows the developers to inspect the behavior of the memory  
;# arbiter component as it is being simulated.
proc AddWaves {} {

  ;#Add the following signals to the Waves window
  add wave -group "CLOCKS" -position end -radix binary sim:/w_cpu/clk\
                                          -radix binary sim:/w_cpu/clk_mem
  
  ;#These signals will be contained in a group
  ;# add wave -group "SIGNALS" -radix hex sim:/memory/addr\

  add wave -group "SIGNALS"   -position end -radix unsigned sim:/w_cpu/PC_addr_out

  add wave -group "INSTMEM"   -position end -radix unsigned sim:/w_cpu/InstMem_counter\
                              -radix binary sim:/w_cpu/Imem_inst_in

  add wave -group "INSTR RUN"   -position end -radix binary sim:/w_cpu/IF_ID_Imem_inst_in

  add wave -group "DATAMEM"   -position end -radix unsigned sim:/w_cpu/DataMem_addr\
                              -radix binary sim:/w_cpu/DataMem_re\
                              -radix binary sim:/w_cpu/DataMem_we\
                              -radix binary sim:/w_cpu/MEM_WB_data\
                              -radix binary sim:/w_cpu/DataMem_data\
                              -radix binary sim:/w_cpu/DataMem_busy

  add wave -group "RegIn"     -position end -radix unsigned sim:/w_cpu/rs\
                              -radix unsigned sim:/w_cpu/rt\
                              -radix unsigned sim:/w_cpu/Rd_W\
                              -radix unsigned sim:/w_cpu/MEM_WB_RegWrite\
                              -radix unsigned sim:/w_cpu/Result_W\
                              -radix unsigned sim:/w_cpu/ALU_LO\
                              -radix unsigned sim:/w_cpu/ALU_HI\
                              -radix unsigned sim:/w_cpu/data0\
                              -radix unsigned sim:/w_cpu/data1\
                              -radix unsigned sim:/w_cpu/ALU_LO_out\
                              -radix unsigned sim:/w_cpu/ALU_HI_out

  add wave -group "Registers" -position end -radix unsigned sim:/w_cpu/r0\
                              -radix unsigned sim:/w_cpu/r1\
                              -radix unsigned sim:/w_cpu/r2\
                              -radix unsigned sim:/w_cpu/r3\
                              -radix unsigned sim:/w_cpu/r4\
                              -radix unsigned sim:/w_cpu/r5\
                              -radix unsigned sim:/w_cpu/r6\
                              -radix unsigned sim:/w_cpu/r7\
                              -radix unsigned sim:/w_cpu/r8\
                              -radix unsigned sim:/w_cpu/r9\
                              -radix unsigned sim:/w_cpu/r10\
                              -radix unsigned sim:/w_cpu/r11\
                              -radix unsigned sim:/w_cpu/r12\
                              -radix unsigned sim:/w_cpu/r13\
                              -radix unsigned sim:/w_cpu/r14\
                              -radix unsigned sim:/w_cpu/r15\
                              -radix unsigned sim:/w_cpu/r16\
                              -radix unsigned sim:/w_cpu/r17\
                              -radix unsigned sim:/w_cpu/r18\
                              -radix unsigned sim:/w_cpu/r19\
                              -radix unsigned sim:/w_cpu/r20\
                              -radix unsigned sim:/w_cpu/r21\
                              -radix unsigned sim:/w_cpu/r22\
                              -radix unsigned sim:/w_cpu/r23\
                              -radix unsigned sim:/w_cpu/r24\
                              -radix unsigned sim:/w_cpu/r25\
                              -radix unsigned sim:/w_cpu/r26\
                              -radix unsigned sim:/w_cpu/r27\
                              -radix unsigned sim:/w_cpu/r28\
                              -radix unsigned sim:/w_cpu/r29\
                              -radix unsigned sim:/w_cpu/r30\
                              -radix unsigned sim:/w_cpu/r31\
                              -radix unsigned sim:/w_cpu/rLo\
                              -radix unsigned sim:/w_cpu/rHi

  add wave -group "CONTROLIN" -position end -radix binary sim:/w_cpu/IF_ID_opCode\
                              -radix binary sim:/w_cpu/IF_ID_funct

  add wave -group "CONTROL"   -position end -radix binary sim:/w_cpu/ALUOpcode\
                              -radix binary sim:/w_cpu/RegDest\
                              -radix binary sim:/w_cpu/Branch\
                              -radix binary sim:/w_cpu/ALUSrc\
                              -radix binary sim:/w_cpu/BNE\
                              -radix binary sim:/w_cpu/Jump\
                              -radix binary sim:/w_cpu/LUI\
                              -radix binary sim:/w_cpu/ALU_LOHI_Write\
                              -radix binary sim:/w_cpu/ALU_LOHI_Read\
                              -radix binary sim:/w_cpu/MemWrite\
                              -radix binary sim:/w_cpu/MemRead\
                              -radix binary sim:/w_cpu/MemtoReg\
                              -radix binary sim:/w_cpu/CPU_stall\
                              -radix binary sim:/w_cpu/regWrite

  add wave -group "HAZMUX"   -position end -radix binary sim:/w_cpu/regWrite\
                              -radix binary sim:/w_cpu/RegDest\
                              -radix binary sim:/w_cpu/Branch\
                              -radix binary sim:/w_cpu/BNE\
                              -radix binary sim:/w_cpu/Jump\
                              -radix binary sim:/w_cpu/MemWrite\
                              -radix binary sim:/w_cpu/MemRead\
                              -radix binary sim:/w_cpu/MemtoReg\
                              -radix binary sim:/w_cpu/ALUSrc\
                              -radix binary sim:/w_cpu/ALUOpcode\
                              -radix binary sim:/w_cpu/IF_ID_regWrite\
                              -radix binary sim:/w_cpu/IF_ID_RegDest\
                              -radix binary sim:/w_cpu/IF_ID_Branch\
                              -radix binary sim:/w_cpu/IF_ID_BNE\
                              -radix binary sim:/w_cpu/IF_ID_Jump\
                              -radix binary sim:/w_cpu/IF_ID_MemWrite\
                              -radix binary sim:/w_cpu/IF_ID_MemRead\
                              -radix binary sim:/w_cpu/IF_ID_MemtoReg\
                              -radix binary sim:/w_cpu/IF_ID_ALUsrc\
                              -radix binary sim:/w_cpu/IF_ID_ALUOpcode

  add wave -group "ALU IN"    -position end -radix binary sim:/w_cpu/ALUOpcode\
                              -radix unsigned sim:/w_cpu/ALU_data0\
                              -radix unsigned sim:/w_cpu/ALU_data1\
                              -radix unsigned sim:/w_cpu/ALU_shamt

  add wave -group "ALU OUT"   -position end -radix unsigned sim:/w_cpu/ALU_data_out\
                              -radix unsigned sim:/w_cpu/ALU_HI\
                              -radix unsigned sim:/w_cpu/ALU_LO\
                              -radix binary sim:/w_cpu/zero

  add wave -group "Forward"   -position end -radix unsigned sim:/w_cpu/ID_EX_Rs_out\
                              -radix unsigned sim:/w_cpu/ID_EX_Rt_out\
                              -radix unsigned sim:/w_cpu/EX_MEM_RegWrite\
                              -radix unsigned sim:/w_cpu/EX_MEM_Rd\
                              -radix unsigned sim:/w_cpu/MEM_WB_RegWrite\
                              -radix unsigned sim:/w_cpu/MEM_WB_Rd\
                              -radix binary sim:/w_cpu/Forward0_EX\
                              -radix binary sim:/w_cpu/Forward1_EX

  add wave -group "Hazard"   -position end -radix unsigned sim:/w_cpu/hazard_state\
                              -radix unsigned sim:/w_cpu/IF_ID_rt\
                              -radix unsigned sim:/w_cpu/Imem_rs\
                              -radix unsigned sim:/w_cpu/Imem_rt\
                              -radix unsigned sim:/w_cpu/MemRead\
                              -radix binary sim:/w_cpu/Branch\
                              -radix binary sim:/w_cpu/haz_IF_ID_write\
                              -radix binary sim:/w_cpu/haz_PC_write\
                              -radix binary sim:/w_cpu/CPU_stall

  add wave -group "BRANCH"   -position end -radix binary sim:/w_cpu/Branch\
                              -radix unsigned sim:/w_cpu/zero\
                              -radix binary sim:/w_cpu/BNE\
                              -radix binary sim:/w_cpu/PC_Branch\
                              -radix unsigned sim:/w_cpu/Branch_addr\
                              -radix binary sim:/w_cpu/IF_ID_Jump\
                              -radix unsigned sim:/w_cpu/Jump_addr\
                              -radix unsigned sim:/w_cpu/after_Jump

  ;#Set some formating options to make the Waves window more legible
  configure wave -namecolwidth 250
  WaveRestoreZoom {0 ns} {1100 ns}
}

;#Generates a clock of period with desired ns length on the port input pin of the w_cpu
proc GenerateClock {port period} { 
  force -deposit /w_cpu/$port 0 0 ns, 1 [expr $period/2.0] ns -repeat $period ns
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
  vcom Sync.vhd
  vcom w_cpu.vhd
  
  ;#Start a simulation session with the w_cpu component
  vsim -t ps w_cpu
  
  ;#Add the w_cpu signals to the waves window
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
  
  ;#Compile the w_cpu and its subcomponents
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
  vcom Sync.vhd
  vcom w_cpu.vhd
}