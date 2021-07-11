vlib work
vlog ../../../common/*.v ../../../../common/*.v
vlog +incdir+../../../common +incdir+../../../../common ../*.v
vsim work.testbench
add wave -radix bin sim:/testbench/i_top/*
run -all
wave zoom full
