
;# This function is responsible for adding to the Waves window 
;# the signals that are relevant to the memory module. This
;# allows the developers to inspect the behavior of the memory  
;# arbiter component as it is being simulated.
proc AddWaves {} {

  ;#Add the following signals to the Waves window
  add wave -group "CLOCKS" -position end -radix binary sim:/cpu/clk\
                                          -radix binary sim:/cpu/clk_mem
  
  ;#These signals will be contained in a group
  ;# add wave -group "SIGNALS" -radix hex sim:/memory/addr\

  add wave -group "SIGNALS"   -position end -radix decimal sim:/cpu/PC_addr_out

  add wave -group "INSTMEM"   -position end -radix decimal sim:/cpu/InstMem_counter\
                              -radix binary sim:/cpu/Imem_inst_in

  add wave -group "DATAMEM"   -position end -radix decimal sim:/cpu/DataMem_addr\
                              -radix binary sim:/cpu/DataMem_re\
                              -radix binary sim:/cpu/DataMem_we\
                              -radix binary sim:/cpu/MEM_WB_data\
                              -radix binary sim:/cpu/DataMem_data\
                              -radix binary sim:/cpu/DataMem_busy

  add wave -group "RegIn"     -position end -radix decimal sim:/cpu/rs\
                              -radix decimal sim:/cpu/rt\
                              -radix decimal sim:/cpu/MEM_WB_Rd\
                              -radix decimal sim:/cpu/MEM_WB_RegWrite\
                              -radix decimal sim:/cpu/Result_W\
                              -radix decimal sim:/cpu/ALU_LO\
                              -radix decimal sim:/cpu/ALU_HI\
                              -radix decimal sim:/cpu/data0\
                              -radix decimal sim:/cpu/data1\
                              -radix decimal sim:/cpu/ALU_LO_out\
                              -radix decimal sim:/cpu/ALU_HI_out

  add wave -group "Registers" -position end -radix decimal sim:/cpu/r0\
                              -radix decimal sim:/cpu/r1\
                              -radix decimal sim:/cpu/r2\
                              -radix decimal sim:/cpu/r3\
                              -radix decimal sim:/cpu/r4\
                              -radix decimal sim:/cpu/r5\
                              -radix decimal sim:/cpu/r6\
                              -radix decimal sim:/cpu/r7\
                              -radix decimal sim:/cpu/r8\
                              -radix decimal sim:/cpu/r9\
                              -radix decimal sim:/cpu/r10\
                              -radix decimal sim:/cpu/r11\
                              -radix decimal sim:/cpu/r12\
                              -radix decimal sim:/cpu/r13\
                              -radix decimal sim:/cpu/r14\
                              -radix decimal sim:/cpu/r15\
                              -radix decimal sim:/cpu/r16\
                              -radix decimal sim:/cpu/r17\
                              -radix decimal sim:/cpu/r18\
                              -radix decimal sim:/cpu/r19\
                              -radix decimal sim:/cpu/r20\
                              -radix decimal sim:/cpu/r21\
                              -radix decimal sim:/cpu/r22\
                              -radix decimal sim:/cpu/r23\
                              -radix decimal sim:/cpu/r24\
                              -radix decimal sim:/cpu/r25\
                              -radix decimal sim:/cpu/r26\
                              -radix decimal sim:/cpu/r27\
                              -radix decimal sim:/cpu/r28\
                              -radix decimal sim:/cpu/r29\
                              -radix decimal sim:/cpu/r30\
                              -radix decimal sim:/cpu/r31

  add wave -group "CONTROLIN" -position end -radix binary sim:/cpu/IF_ID_opCode\
                              -radix binary sim:/cpu/IF_ID_funct

  add wave -group "CONTROL"   -position end -radix binary sim:/cpu/ALUOpcode\
                              -radix binary sim:/cpu/RegDest\
                              -radix binary sim:/cpu/Branch\
                              -radix binary sim:/cpu/ALUSrc\
                              -radix binary sim:/cpu/BNE\
                              -radix binary sim:/cpu/Jump\
                              -radix binary sim:/cpu/LUI\
                              -radix binary sim:/cpu/ALU_LOHI_Write\
                              -radix binary sim:/cpu/ALU_LOHI_Read\
                              -radix binary sim:/cpu/MemWrite\
                              -radix binary sim:/cpu/MemRead\
                              -radix binary sim:/cpu/MemtoReg\
                              -radix binary sim:/cpu/CPU_stall\
                              -radix binary sim:/cpu/regWrite

  add wave -group "ALU IN"    -position end -radix binary sim:/cpu/ALUOpcode\
                              -radix decimal sim:/cpu/ALU_data0\
                              -radix decimal sim:/cpu/ALU_data1\
                              -radix decimal sim:/cpu/ALU_shamt

  add wave -group "ALU OUT"   -position end -radix decimal sim:/cpu/ALU_data_out\
                              -radix decimal sim:/cpu/ALU_HI\
                              -radix decimal sim:/cpu/ALU_LO\
                              -radix binary sim:/cpu/zero

  add wave -group "Wr - Rd"   -position end -radix decimal sim:/cpu/ID_EX_Rd\
                              -radix decimal sim:/cpu/ID_EX_Rt_out\
                              -radix decimal sim:/cpu/EX_rd\
                              -radix decimal sim:/cpu/EX_MEM_Rd\
                              -radix binary sim:/cpu/MEM_WB_Rd

  add wave -group "Write Sign" -position end -radix decimal sim:/cpu/regWrite\
                              -radix decimal sim:/cpu/IF_ID_regWrite\
                              -radix decimal sim:/cpu/ID_EX_RegWrite\
                              -radix decimal sim:/cpu/EX_MEM_RegWrite\
                              -radix binary sim:/cpu/MEM_WB_RegWrite

  add wave -group "Result Sign" -position end -radix decimal sim:/cpu/MemtoReg\
                              -radix decimal sim:/cpu/IF_ID_MemtoReg\
                              -radix decimal sim:/cpu/ID_EX_MemtoReg\
                              -radix decimal sim:/cpu/EX_MEM_MemtoReg\
                              -radix binary sim:/cpu/MEM_WB_MemtoReg

  ;#Set some formating options to make the Waves window more legible
  configure wave -namecolwidth 250
  WaveRestoreZoom {0 ns} {1100 ns}
}

;#Generates a clock of period with desired ns length on the port input pin of the cpu
proc GenerateClock {port period} { 
  force -deposit /cpu/$port 0 0 ns, 1 [expr $period/2.0] ns -repeat $period ns
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
  vcom cpu.vhd
  
  ;#Start a simulation session with the cpu component
  vsim -t ps cpu
  
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
  vcom cpu.vhd
}
