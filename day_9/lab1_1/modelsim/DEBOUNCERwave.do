onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TestBench_debouncer/DUT/DEBOUNCE_TIMER
add wave -noupdate /TestBench_debouncer/DUT/clk
add wave -noupdate /TestBench_debouncer/DUT/RAW_BTN
add wave -noupdate /TestBench_debouncer/DUT/BTN
add wave -noupdate /TestBench_debouncer/DUT/BTN_POSEDGE
add wave -noupdate /TestBench_debouncer/DUT/BTN_NEGEDGE
add wave -noupdate /TestBench_debouncer/DUT/states_of_button_0
add wave -noupdate /TestBench_debouncer/DUT/states_of_button_1
add wave -noupdate /TestBench_debouncer/DUT/states_of_button_2
add wave -noupdate /TestBench_debouncer/DUT/states_of_button_3
add wave -noupdate /TestBench_debouncer/DUT/counter
add wave -noupdate /TestBench_debouncer/DUT/state_changed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 284
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
WaveRestoreZoom {0 ns} {1270 ns}
