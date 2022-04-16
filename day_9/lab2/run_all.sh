vlog '-timescale' '1ns/1ns' -sv -f systemverilog.txt | grep Errork
echo "" > global.txt
vsim -batch work.tb -g test_id=0 -do "run -all"
echo ""
cat global.txt
echo ""
echo ""