# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.clk
lappend all_signals tb.rst
lappend all_signals tb.data
lappend all_signals tb.en
lappend all_signals tb.f_clk
lappend all_signals tb.f_en
lappend all_signals tb.f_expected
lappend all_signals tb.f_failure
lappend all_signals tb.s_clk
lappend all_signals tb.s_en
lappend all_signals tb.s_expected
lappend all_signals tb.s_failure

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
