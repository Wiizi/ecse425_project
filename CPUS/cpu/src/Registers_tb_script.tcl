puts {
	Registers Test Script 
	Author : Aidan Petit
	Creation Date : 03/27/2016
	Last Revision : 03/29/2016
}

proc AddWaves {} \
{
 
	#inputs to Registers
	add wave -radix hex sim:/Registers_tb/clk
        add wave -radix hex sim:/Registers_tb/t_regWrite 
	add wave -radix binary sim:/Registers_tb/t_ALU_LOHI_Write 
	add wave -radix binary sim:/Registers_tb/t_readReg_0 
	add wave -radix binary sim:/Registers_tb/t_readReg_1 
	add wave -radix binary sim:/Registers_tb/t_writeReg 
	add wave -radix binary sim:/Registers_tb/t_writeData 
	add wave -radix binary sim:/Registers_tb/t_ALU_LO_in  
	add wave -radix binary sim:/Registers_tb/t_ALU_HI_in
					
	#outputs of Registers
	add wave -radix binary sim:/Registers_tb/t_readData_0   
	add wave -radix binary sim:/Registers_tb/t_readData_1   
	add wave -radix binary sim:/Registers_tb/t_ALU_LO_out   
	add wave -radix binary sim:/Registers_tb/t_ALU_HI_out 


  	#Set some formating options to make the Waves window more legible
	configure wave -namecolwidth 250
	WaveRestoreZoom {0 ns} {8 ns}
}

vlib work
  
#Compile the Registers and testbench 
vcom -reportprogress 300 -work work Registers.vhd
vcom -reportprogress 300 -work work Registers_tb.vhd
  
#Start a simulation session with the Registers_tb 
vsim Registers_tb
	
#Add waves
AddWaves
  
# run for an appropriate amount of time
run 500ns; #check this
