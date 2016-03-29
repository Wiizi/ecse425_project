puts {
	Memory Arbiter Test Script
	Author : Aidan Petit
	Creation Date : 03/29/2016
	Last Revision : 
}

proc AddWaves {} \
{
	# all relevant signals and appropriate radix's
	add wave -radix binary -position end sim:/memory_arbiter_tb/clk
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_addr
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_re
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_we
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_dataIn
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_dataOut
	add wave -radix binary -position end sim:/memory_arbiter_tb/t_busy

}

vlib work

# compile relevant files

vcom -reportprogress 300 -work work memory.vhd
vcom -reportprogress 300 -work work memory_arbiter_tb.vhd

# start simulation
vsim memory_arbiter_tb

# Add the waves
AddWaves

# generate clock
# force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

# run for an appropriate amount of time
run 2000ns;	#unsure about this