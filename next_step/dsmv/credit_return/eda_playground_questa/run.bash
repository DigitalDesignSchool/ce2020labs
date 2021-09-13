vlib work 
vlog design.sv testbench.sv  
echo "" > global.txt
vsim -batch -do "vsim -voptargs=+acc=npr work.tb -voptargs=+acc=npr +test_id=0; run -all; exit" 
vsim -batch -do "vsim -voptargs=+acc=npr work.tb -voptargs=+acc=npr +test_id=1; coverage save -onexit result.ucdb;  run -all; exit" 
vcover report -details result.ucdb
cat global.txt