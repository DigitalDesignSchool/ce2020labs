vlib work
vlog *.sv
vsim -voptargs=+acc work.tb
add wave -radix bin sim:/tb/*
run -all
wave zoom full
