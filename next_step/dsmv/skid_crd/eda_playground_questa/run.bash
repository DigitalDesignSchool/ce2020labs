vlib work 
vlog -writetoplevels questa.tops '-timescale' '1ns/1ns' design.sv testbench.sv  
echo "" > global.txt
vsim -f questa.tops  -batch -do "vsim -voptargs=+acc=npr ; run -all; exit" -voptargs=+acc=npr +test_id=0
vsim -f questa.tops  -batch -do "vsim -voptargs=+acc=npr ; run -all; exit" -voptargs=+acc=npr +test_id=1
cat global.txt