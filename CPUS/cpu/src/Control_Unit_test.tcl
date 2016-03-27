puts {
	Control Unit Test 
	Author : Aidan Petit
	Creation Date : 03/27/2016
	Last Revision : 
}

proc AddWaves {} \
{
	# all relevant signals and appropriate radix's
	add wave -position end sim:/Control_Unit_tb/clk
	add wave -radix binary -position end sim:/Control_Unit_tb/t_opCode
	add wave -radix binary -position end sim:/Control_Unit_tb/t_ALUOpCode
	add wave -radix binary -position end sim:/Control_Unit_tb/t_funct

}

vlib work

# compile ALU and testbench

vcom -reportprogress 300 -work work Control_Unit.vhd
vcom -reportprogress 300 -work work Control_Unit_tb.vhd

# start simulation
vsim Control_Unit_tb

# Add the waves
AddWaves

# generate clock
# force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

# run for an appropriate amount of time
run 8000ns