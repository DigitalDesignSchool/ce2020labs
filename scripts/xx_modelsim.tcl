vlib work
vlog ../../common/*.v
vlog +incdir+../../common ../../game/*.v
vlog +incdir+../../common ../*.v
vsim -novopt work.testbench
add wave -radix bin sim:/testbench/i_top/*
run -all
wave zoom full
