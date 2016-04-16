
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

  add wave -group "SIGNALS"   -position end -radix unsigned sim:/cpu/PC_addr_out

  add wave -group "INSTMEM"   -position end -radix unsigned sim:/cpu/InstMem_address\
                              -radix binary sim:/cpu/InstMem_re\
                              -radix binary sim:/cpu/inst_re_control\
                              -radix unsigned sim:/cpu/pc_in\
                              -radix unsigned sim:/cpu/after_Jump\
                              -radix unsigned sim:/cpu/InstMem_busy\
                              -radix binary sim:/cpu/Imem_inst_in

  add wave -group "INSTR RUN"   -position end -radix binary sim:/cpu/IF_ID_Imem_inst_in

  add wave -group "DATAMEM"   -position end -radix unsigned sim:/cpu/DataMem_addr\
                              -radix binary sim:/cpu/re_control\
                              -radix binary sim:/cpu/we_control\
                              -radix binary sim:/cpu/data_we_control\
                              -radix binary sim:/cpu/data_re_control\
                              -radix binary sim:/cpu/DataMem_re\
                              -radix binary sim:/cpu/DataMem_we\
                              -radix unsigned sim:/cpu/datamem_datain\
                              -radix unsigned sim:/cpu/datamem_dataout\
                              -radix binary sim:/cpu/DataMem_busy\
                              -radix unsigned sim:/cpu/mem_data_state\
                              -radix unsigned sim:/cpu/wrd\
                              -radix unsigned sim:/cpu/rdr

  add wave -group "RegIn"     -position end -radix unsigned sim:/cpu/rs\
                              -radix unsigned sim:/cpu/rt\
                              -radix unsigned sim:/cpu/Rd_W_in\
                              -radix unsigned sim:/cpu/reg_write_control\
                              -radix unsigned sim:/cpu/lohi_write_control\
                              -radix unsigned sim:/cpu/ALU_LOHI_Read_delayed\
                              -radix unsigned sim:/cpu/MEM_WB_MemtoReg\
                              -radix unsigned sim:/cpu/Result_W_in\
                              -radix unsigned sim:/cpu/ALU_LO\
                              -radix unsigned sim:/cpu/ALU_HI\
                              -radix unsigned sim:/cpu/data0\
                              -radix unsigned sim:/cpu/data1\
                              -radix unsigned sim:/cpu/ALU_LO_out\
                              -radix unsigned sim:/cpu/ALU_HI_out

  add wave -group "Registers" -position end -radix unsigned sim:/cpu/r0\
                              -radix unsigned sim:/cpu/r1\
                              -radix unsigned sim:/cpu/r2\
                              -radix unsigned sim:/cpu/r3\
                              -radix unsigned sim:/cpu/r4\
                              -radix unsigned sim:/cpu/r5\
                              -radix unsigned sim:/cpu/r6\
                              -radix unsigned sim:/cpu/r7\
                              -radix unsigned sim:/cpu/r8\
                              -radix unsigned sim:/cpu/r9\
                              -radix unsigned sim:/cpu/r10\
                              -radix unsigned sim:/cpu/r11\
                              -radix unsigned sim:/cpu/r12\
                              -radix unsigned sim:/cpu/r13\
                              -radix unsigned sim:/cpu/r14\
                              -radix unsigned sim:/cpu/r15\
                              -radix unsigned sim:/cpu/r16\
                              -radix unsigned sim:/cpu/r17\
                              -radix unsigned sim:/cpu/r18\
                              -radix unsigned sim:/cpu/r19\
                              -radix unsigned sim:/cpu/r20\
                              -radix unsigned sim:/cpu/r21\
                              -radix unsigned sim:/cpu/r22\
                              -radix unsigned sim:/cpu/r23\
                              -radix unsigned sim:/cpu/r24\
                              -radix unsigned sim:/cpu/r25\
                              -radix unsigned sim:/cpu/r26\
                              -radix unsigned sim:/cpu/r27\
                              -radix unsigned sim:/cpu/r28\
                              -radix unsigned sim:/cpu/r29\
                              -radix unsigned sim:/cpu/r30\
                              -radix unsigned sim:/cpu/r31\
                              -radix unsigned sim:/cpu/rLo\
                              -radix unsigned sim:/cpu/rHi

  add wave -group "CONTROLIN" -position end -radix binary sim:/cpu/IF_ID_opCode\
                              -radix binary sim:/cpu/IF_ID_funct

  add wave -group "CONTROL"   -position end -radix binary sim:/cpu/ALUOpcode\
                              -radix binary sim:/cpu/RegDest\
                              -radix binary sim:/cpu/Branch\
                              -radix binary sim:/cpu/ALUSrc\
                              -radix binary sim:/cpu/BNE\
                              -radix binary sim:/cpu/Jump\
                              -radix binary sim:/cpu/JR\
                              -radix binary sim:/cpu/LUI\
                              -radix binary sim:/cpu/ALU_LOHI_Write\
                              -radix binary sim:/cpu/ALU_LOHI_Read\
                              -radix binary sim:/cpu/MemWrite\
                              -radix binary sim:/cpu/MemRead\
                              -radix binary sim:/cpu/MemtoReg\
                              -radix binary sim:/cpu/CPU_stall\
                              -radix binary sim:/cpu/regWrite

  add wave -group "ALU IN"    -position end -radix binary sim:/cpu/ALUOpcode\
                              -radix unsigned sim:/cpu/ALU_data0\
                              -radix unsigned sim:/cpu/ALU_data1\
                              -radix unsigned sim:/cpu/ALU_shamt

  add wave -group "ALU OUT"   -position end -radix unsigned sim:/cpu/ALU_data_out\
                              -radix unsigned sim:/cpu/ALU_data_out_fast\
                              -radix unsigned sim:/cpu/ALU_HI\
                              -radix unsigned sim:/cpu/ALU_LO\
                              -radix binary sim:/cpu/zero

  add wave -group "Forward"   -position end -radix unsigned sim:/cpu/ID_EX_Rs_out\
                              -radix unsigned sim:/cpu/ID_EX_Rt_out\
                              -radix unsigned sim:/cpu/EX_MEM_RegWrite\
                              -radix unsigned sim:/cpu/EX_MEM_Rd\
                              -radix unsigned sim:/cpu/MEM_WB_RegWrite\
                              -radix unsigned sim:/cpu/Rd_W\
                              -radix binary sim:/cpu/Forward0_EX\
                              -radix binary sim:/cpu/Forward1_EX

  add wave -group "Hazard"   -position end -radix unsigned sim:/cpu/hazard_state\
                              -radix unsigned sim:/cpu/IF_ID_rt\
                              -radix unsigned sim:/cpu/Imem_rs\
                              -radix unsigned sim:/cpu/Imem_rt\
                              -radix unsigned sim:/cpu/MemRead\
                              -radix binary sim:/cpu/Branch\
                              -radix binary sim:/cpu/CPU_stall\
                              -radix binary sim:/cpu/Stall_selector

  add wave -group "Branch&J"   -position end -radix binary sim:/cpu/Branch_Signal\
                              -radix binary sim:/cpu/Branch\
                              -radix unsigned sim:/cpu/Branch_data0\
                              -radix unsigned sim:/cpu/Branch_data1\
                              -radix unsigned sim:/cpu/Early_Zero\
                              -radix unsigned sim:/cpu/zero\
                              -radix binary sim:/cpu/BNE_Signal\
                              -radix binary sim:/cpu/BNE\
                              -radix binary sim:/cpu/PC_Branch\
                              -radix unsigned sim:/cpu/Branch_addr_delayed\
                              -radix binary sim:/cpu/IF_ID_Jump\
                              -radix unsigned sim:/cpu/Jump_addr_delayed\
                              -radix unsigned sim:/cpu/after_Jump\
                              -radix unsigned sim:/cpu/ID_EX_Jal\
                              -radix unsigned sim:/cpu/Jal_to_Reg\
                              -radix unsigned sim:/cpu/jal_addr\
                              -radix unsigned sim:/cpu/Branch_taken\
                              -radix unsigned sim:/cpu/Flush_state


  add wave -group "Early_B"   -position end -radix binary sim:/cpu/Branch_Signal\
                              -radix binary sim:/cpu/ID_EX_RegWrite\
                              -radix binary sim:/cpu/EX_MEM_RegWrite\
                              -radix unsigned sim:/cpu/rs\
                              -radix unsigned sim:/cpu/rt\
                              -radix unsigned sim:/cpu/EX_MEM_Rd\
                              -radix unsigned sim:/cpu/Rd_W\
                              -radix binary sim:/cpu/Forward0_Branch\
                              -radix binary sim:/cpu/Forward1_Branch\
                              -radix unsigned sim:/cpu/ALU_data_out_fast\
                              -radix unsigned sim:/cpu/EX_ALU_result\
                              -radix unsigned sim:/cpu/Result_W

  add wave -group "JR"   -position end -radix binary sim:/cpu/JR\
                              -radix binary sim:/cpu/JR_delayed\
                              -radix unsigned sim:/cpu/JR_addr\
                              -radix unsigned sim:/cpu/J_addr

  add wave -group "Predictor" -position end -radix binary sim:/cpu/PC_Branch\
                              -radix binary sim:/cpu/Branch_Signal\
                              -radix binary sim:/cpu/branch_outcome\
                              -radix unsigned sim:/cpu/last_prediction\
                              -radix unsigned sim:/cpu/pred_validate

  add wave -group "Pred_addr" -position end -radix binary sim:/cpu/branch_op\
                              -radix unsigned sim:/cpu/predict_addr\
                              -radix unsigned sim:/cpu/InstMem_counterVector\
                              -radix unsigned sim:/cpu/after_Branch\
                              -radix unsigned sim:/cpu/predict_untaken_addr\
                              -radix unsigned sim:/cpu/predict_target\
                              -radix unsigned sim:/cpu/predict_target_correct

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
  ;#Compile the memory unit and its subcomponents
  CompileOnly
  
  ;#Start a simulation session with the cpu component
  vsim -t ps cpu
  
  ;#Add the cpu signals to the waves window
  ;#to allow inspecting the module's behavior
  AddWaves
  
  ;#Generate a CPU clock
  GenerateClock clk 20
  GenerateClock clk_mem 2

  ;#Update all signals
  run 5000 ns;

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
  vcom PC.vhd
  vcom Registers.vhd
  vcom Forwarding.vhd
  vcom MEM_WB.vhd
  vcom Earlybranching.vhd
  vcom TwoBit_Predictor.vhd
  vcom cpu.vhd
}
