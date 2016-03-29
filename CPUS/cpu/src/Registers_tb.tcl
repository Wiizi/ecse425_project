puts {
	Registers Test Script 
	Author : Aidan Petit
	Creation Date : 03/27/2016
	Last Revision : 03/29/2016
}

proc AddWaves {} \
{

	;#Add the following signals to the Waves window
	add wave -position end  -radix binary sim:/Registers/clk
  
  	;#These signals will be contained in a group named "Registers"
	add wave -group "Registers"  
		#inputs to Registers
		-radix hex sim:/Registers_tb/clk\
                -radix hex sim:/Registers_tb/regWrite \
		-radix binary sim:/Registers_tb/ALU_LOHI_Write \
		-radix binary sim:/Registers_tb/readReg_0 \
		-radix binary sim:/Registers_tb/readReg_1 \
		-radix binary sim:/Registers_tb/writeReg \
		-radix binary sim:/Registers_tb/writeData \
		-radix binary sim:/Registers_tb/ALU_LO_in  \
		-radix binary sim:/Registers_tb/ALU_HI_in   \
							
		#outputs of Registers
		-radix binary sim:/Registers_tb/readData_0   \
		-radix binary sim:/Registers_tb/readData_1   \
		-radix binary sim:/Registers_tb/ALU_LO_out   \
		-radix binary sim:/Registers_tb/ALU_HI_out 


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
