onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TestBench_brush/clk
add wave -noupdate /TestBench_brush/reset_n
add wave -noupdate /TestBench_brush/enable
add wave -noupdate /TestBench_brush/BTN
add wave -noupdate -radix unsigned /TestBench_brush/hpos
add wave -noupdate -radix unsigned /TestBench_brush/vpos
add wave -noupdate /TestBench_brush/FB_RGB
add wave -noupdate /TestBench_brush/Painting_Brush/rgb
add wave -noupdate -radix unsigned /TestBench_brush/Painting_Brush/counterclk
add wave -noupdate -radix unsigned /TestBench_brush/Painting_Brush/cursor_xpos
add wave -noupdate -radix unsigned /TestBench_brush/Painting_Brush/cursor_ypos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {0 ns} {145 ns}
