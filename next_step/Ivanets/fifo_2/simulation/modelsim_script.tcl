
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../testbench.v ../../fifo_1.v 

# open the testbench module for simulation
vsim -novopt work.testbench

# add all testbench signals to time diagram
#add wave sim:/testbench/*

add wave -radix bin sim:/testbench/clk_tb
add wave -radix bin sim:/testbench/rst_n_tb
add wave -radix bin sim:/testbench/write_tb
add wave -radix bin sim:/testbench/read_tb
add wave -radix hex sim:/testbench/write_data_tb
add wave -radix hex sim:/testbench/read_data_tb
add wave -radix bin sim:/testbench/empty_tb
add wave -radix bin sim:/testbench/full_tb

# run the simulation
run -all

# expand the signals time diagram
wave zoom full
