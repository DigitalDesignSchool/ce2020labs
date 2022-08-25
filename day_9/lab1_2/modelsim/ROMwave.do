onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ROM_topTestBench/clk
add wave -noupdate /ROM_topTestBench/rst
add wave -noupdate /ROM_topTestBench/display_on
add wave -noupdate /ROM_topTestBench/fifofull
add wave -noupdate -radix unsigned /ROM_topTestBench/DUT/hpos
add wave -noupdate -radix unsigned /ROM_topTestBench/DUT/vpos
add wave -noupdate -radix binary /ROM_topTestBench/DUT/RGB
add wave -noupdate -radix decimal /ROM_topTestBench/DUT/counter
add wave -noupdate /ROM_topTestBench/DUT/hposROM
add wave -noupdate /ROM_topTestBench/DUT/vposROM
add wave -noupdate /ROM_topTestBench/DUT/RGBROM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 228
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {603 ns}
