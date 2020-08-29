# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals testbench.clk
lappend all_signals testbench.key
lappend all_signals testbench.sw
lappend all_signals testbench.led
lappend all_signals testbench.abcdefgh
lappend all_signals testbench.digit
lappend all_signals testbench.buzzer
lappend all_signals testbench.vsync
lappend all_signals testbench.hsync
lappend all_signals testbench.rgb

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
