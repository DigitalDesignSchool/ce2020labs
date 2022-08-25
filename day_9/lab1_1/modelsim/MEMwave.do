onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TestBench/clk
add wave -noupdate /TestBench/memreset
add wave -noupdate /TestBench/reset_n
add wave -noupdate -radix unsigned /TestBench/resetcnt
add wave -noupdate -radix unsigned /TestBench/hpos
add wave -noupdate -radix unsigned /TestBench/vpos
add wave -noupdate -radix binary /TestBench/RGBin
add wave -noupdate /TestBench/RGB
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/writeR_data
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/writeG_data
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/writeB_data
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/R_data
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/G_data
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/B_data
add wave -noupdate -expand -group Debug -expand -group DUT -radix unsigned /TestBench/FrameBuffer/addrbuf_wire
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/we
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/fifoempty
add wave -noupdate -expand -group Debug -expand -group DUT /TestBench/FrameBuffer/display_on
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/RESOLUTION_H
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/MEMORY_H
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/DATA_WIDTH
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/X_WIDTH
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Y_WIDTH
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/ADDR_WIDTH
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/RES_MULT
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/REGS_IN_ROW
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/DATASELECT_WIDTH
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/clk
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/reset
add wave -noupdate -expand -group Debug -expand -group FBCODEC -radix unsigned /TestBench/FrameBuffer/FBCODEC/hpos
add wave -noupdate -expand -group Debug -expand -group FBCODEC -radix unsigned /TestBench/FrameBuffer/FBCODEC/vpos
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/datafromR
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/datafromG
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/datafromB
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/RGBin
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/display_on
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/memenable
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/fifoempty
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/we
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/RGB
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Rdatatomem
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Gdatatomem
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Bdatatomem
add wave -noupdate -expand -group Debug -expand -group FBCODEC -radix unsigned /TestBench/FrameBuffer/FBCODEC/addr
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/addr_r
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/addr_w
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Rdatabuf
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Gdatabuf
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/Bdatabuf
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/dataselect
add wave -noupdate -expand -group Debug -expand -group FBCODEC -radix unsigned /TestBench/FrameBuffer/FBCODEC/dataselect_r
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/dataselect_w
add wave -noupdate -expand -group Debug -expand -group FBCODEC /TestBench/FrameBuffer/FBCODEC/w_state
add wave -noupdate -expand -group Debug /TestBench/FrameBuffer/R_MEMORY/ramblock
add wave -noupdate -expand -group Debug /TestBench/FrameBuffer/G_MEMORY/ramblock
add wave -noupdate -expand -group Debug /TestBench/FrameBuffer/B_MEMORY/ramblock
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/RAMLENGTH
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/DATA_WIDTH
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/ADDR_WIDTH
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/data
add wave -noupdate -expand -group Debug -group R_BLOCK -radix unsigned /TestBench/FrameBuffer/R_MEMORY/addr
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/we
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/clk
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/memenable
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/resetcnt
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/q
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/ramblock
add wave -noupdate -expand -group Debug -group R_BLOCK -radix unsigned /TestBench/FrameBuffer/R_MEMORY/addr_x
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/data_x
add wave -noupdate -expand -group Debug -group R_BLOCK /TestBench/FrameBuffer/R_MEMORY/we_x
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/RAMLENGTH
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/DATA_WIDTH
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/ADDR_WIDTH
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/data
add wave -noupdate -expand -group Debug -group G_BLOCK -radix unsigned /TestBench/FrameBuffer/G_MEMORY/addr
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/we
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/clk
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/memenable
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/resetcnt
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/q
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/ramblock
add wave -noupdate -expand -group Debug -group G_BLOCK -radix unsigned /TestBench/FrameBuffer/G_MEMORY/addr_x
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/data_x
add wave -noupdate -expand -group Debug -group G_BLOCK /TestBench/FrameBuffer/G_MEMORY/we_x
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/RAMLENGTH
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/DATA_WIDTH
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/ADDR_WIDTH
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/data
add wave -noupdate -expand -group Debug -group B_BLOCK -radix unsigned /TestBench/FrameBuffer/B_MEMORY/addr
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/we
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/clk
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/memenable
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/resetcnt
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/q
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/ramblock
add wave -noupdate -expand -group Debug -group B_BLOCK -radix unsigned /TestBench/FrameBuffer/B_MEMORY/addr_x
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/data_x
add wave -noupdate -expand -group Debug -group B_BLOCK /TestBench/FrameBuffer/B_MEMORY/we_x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9075 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 335
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
WaveRestoreZoom {7795 ns} {10679 ns}
