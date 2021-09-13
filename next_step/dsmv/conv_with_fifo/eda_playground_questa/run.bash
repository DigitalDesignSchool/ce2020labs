vlib work 
vlog design.sv testbench.sv  
echo "" > global.txt
vsim -batch -do "vsim -voptargs=+acc=npr work.tb -voptargs=+acc=npr +test_id=0; run -all; exit" 
vsim -batch -do "vsim -voptargs=+acc=npr work.tb -voptargs=+acc=npr +test_id=1; run -all; exit" 
cat global.txt