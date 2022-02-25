vcs -R \
-licqueue \
-sverilog \
-timescale=1ns/1ns \
+vcs+flush+all \
design.sv testbench.sv

urg -dir simv.vdb -format text
ls -l urgReport/*txt
cat urgReport/*txt
