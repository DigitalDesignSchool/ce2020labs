echo ALL PROBLEMS > log.txt

for %%f in (*.v) do (
    \iverilog\bin\iverilog -g2005-sv %%f >> log.txt 2>&1
    \iverilog\bin\vvp a.out >> log.txt 2>&1
    rem \iverilog\gtkwave\bin\gtkwave dump.vcd
)

del /q a.out

findstr PASS  log.txt
findstr FAIL  log.txt
findstr error log.txt
