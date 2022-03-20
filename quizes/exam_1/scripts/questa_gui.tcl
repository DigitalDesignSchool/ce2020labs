vlib work
vlog *.sv
vsim -voptargs=+acc +stop_instead_of_finish work.tb
add wave -radix bin sim:/tb/*
run -all
wave zoom full
