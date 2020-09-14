# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals testbench.clk
lappend all_signals testbench.key
lappend all_signals testbench.sw
lappend all_signals testbench.i_top.led
lappend all_signals testbench.i_top.abcdefgh
lappend all_signals testbench.i_top.digit

# If this signal is not commented out and is not used, it makes annoying sound
# lappend all_signals testbench.i_top.buzzer

lappend all_signals testbench.i_top.vsync
lappend all_signals testbench.i_top.hsync
lappend all_signals testbench.i_top.rgb

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
