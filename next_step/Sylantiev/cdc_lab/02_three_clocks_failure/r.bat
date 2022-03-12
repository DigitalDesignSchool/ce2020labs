rd /s /q sim
md sim
cd sim

\iverilog\bin\iverilog -g2005 ../*.v
\iverilog\bin\vvp a.out > a.lst
type a.lst
\iverilog\gtkwave\bin\gtkwave.exe dump.vcd -S ../gtkwave.tcl
