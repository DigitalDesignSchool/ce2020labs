vlog '-timescale' '1ns/1ns' -sv -f systemverilog.txt | grep Error
echo "" > global.txt
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=5
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=6
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=7
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=8
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=9
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=10
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=11
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=12
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=13
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=14
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=15
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=16
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=17
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=18
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=19
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=20
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=21
vsim -batch work.tb -g test_id=0 -do "run -all" -g DEPTH=22
cat global.txt