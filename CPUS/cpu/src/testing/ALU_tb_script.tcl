puts {
	ALU Test 
	Author : Aidan Petit
	Creation Date : 03/27/2016
	Last Revision : 
}

proc AddWaves {} \
{
	# all relevant signals and appropriate radix's
	add wave -position end sim:/ALU_tb/clk
	add wave -radix binary -position end sim:/ALU_tb/t_opCode
	add wave -radix binary -position end sim:/ALU_tb/t_data0
	add wave -radix binary -position end sim:/ALU_tb/t_data1
	add wave -radix binary -position end sim:/ALU_tb/t_data_out
	add wave -radix decimal -position end sim:/ALU_tb/t_HI
	add wave -radix decimal -position end sim:/ALU_tb/t_LO
	add wave -radix decimal -position end sim:/ALU_tb/t_zero
}

vlib work

# compile ALU and testbench

#vcom ALU.vhd
#vcom ALU_tb.vhd

# start simulation
vsim ALU_tb

# Add the waves
AddWaves

# generate clock
# force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

# run for an appropriate amount of time
run 3000ns
