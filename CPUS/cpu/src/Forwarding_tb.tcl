puts {
	Forward Unit Test Script
	Author : Aidan Petit
	Creation Date : 03/27/2016
	Last Revision : 
}

proc AddWaves {} \
{
	# all relevant signals and appropriate radix's
	add wave -radix binary -position end sim:/Forwarding_tb/t_EX_MEM_RegWrite
	add wave -radix binary -position end sim:/Forwarding_tb/t_MEM_WB_RegWrite 
	add wave -radix binary -position end sim:/Forwarding_tb/t_ID_EX_Rs
	add wave -radix binary -position end sim:/Forwarding_tb/t_ID_EX_Rt 
	add wave -radix binary -position end sim:/Forwarding_tb/t_EX_MEM_Rd 
	add wave -radix binary -position end sim:/Forwarding_tb/t_MEM_WB_Rd 
	add wave -radix binary -position end sim:/Forwarding_tb/t_F0_EX 
	add wave -radix binary -position end sim:/Forwarding_tb/t_F1_EX 

}

vlib work

# compile ALU and testbench

vcom -reportprogress 300 -work work Forwarding.vhd
vcom -reportprogress 300 -work work Forwarding_tb.vhd

# start simulation
vsim Forwarding_tb

# Add the waves
AddWaves

# generate clock
# force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

# run for an appropriate amount of time
run 250ns
