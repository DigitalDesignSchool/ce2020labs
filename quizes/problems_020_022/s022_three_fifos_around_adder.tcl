# gtkwave::loadFile "dump.vcd"

set all_signals [list]

lappend all_signals testbench.clk
lappend all_signals testbench.rst
lappend all_signals testbench.can_push_a
lappend all_signals testbench.push_a
lappend all_signals testbench.a
lappend all_signals testbench.can_push_b
lappend all_signals testbench.push_b
lappend all_signals testbench.b
lappend all_signals testbench.can_pop_sum
lappend all_signals testbench.pop_sum
lappend all_signals testbench.sum

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
