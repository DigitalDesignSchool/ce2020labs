# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.rst
lappend all_signals tb.s_clk
lappend all_signals tb.data
lappend all_signals tb.s_en
lappend all_signals tb.s_toggle
lappend all_signals tb.r_clk
lappend all_signals tb.r_en
lappend all_signals tb.r_toggle
lappend all_signals tb.r_expected
lappend all_signals tb.r_failure

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
