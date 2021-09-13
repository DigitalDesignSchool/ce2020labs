vlib work 
vlog '-timescale' '1ns/1ns' design.sv testbench.sv  
echo "" > global.txt
vsim -batch -do "vsim -voptargs=+acc=npr -g test_id=0; run -all; exit" 
vsim -batch -do "vsim -voptargs=+acc=npr -g test_id=1; run -all; exit" 
cat global.txt