create_clock -period "50.0 MHz" [get_ports max10_clk1_50]

derive_clock_uncertainty

set_false_path -from [get_ports {key[*]}]  -to [all_clocks]
set_false_path -from [get_ports {sw[*]}]   -to [all_clocks]
set_false_path -from [get_ports {gpio[*]}] -to [all_clocks]

set_false_path -from * -to [get_ports {led[*]}]

set_false_path -from * -to hex0
set_false_path -from * -to hex1
set_false_path -from * -to hex2
set_false_path -from * -to hex3
set_false_path -from * -to hex4
set_false_path -from * -to hex5

set_false_path -from * -to vga_hs
set_false_path -from * -to vga_vs
set_false_path -from * -to [get_ports {vga_r[*]}]
set_false_path -from * -to [get_ports {vga_g[*]}]
set_false_path -from * -to [get_ports {vga_b[*]}]

set_false_path -from * -to [get_ports {gpio[*]}]
