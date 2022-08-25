onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Top_FB_TestBench/clk
add wave -noupdate /Top_FB_TestBench/reset_n
add wave -noupdate /Top_FB_TestBench/DUT/display_on
add wave -noupdate /Top_FB_TestBench/DUT/fifopop
add wave -noupdate /Top_FB_TestBench/DUT/fifopush
add wave -noupdate /Top_FB_TestBench/DUT/enable
add wave -noupdate -expand -group VGA /Top_FB_TestBench/DUT/hsync
add wave -noupdate -expand -group VGA /Top_FB_TestBench/DUT/vsync
add wave -noupdate -expand -group VGA -radix unsigned /Top_FB_TestBench/DUT/hpos
add wave -noupdate -expand -group VGA -radix unsigned /Top_FB_TestBench/DUT/vpos
add wave -noupdate -expand -group VGA /Top_FB_TestBench/DUT/rgb
add wave -noupdate -expand -group ROM /Top_FB_TestBench/DUT/fifofull
add wave -noupdate -expand -group ROM /Top_FB_TestBench/DUT/ROM_RGB
add wave -noupdate -expand -group ROM -radix unsigned /Top_FB_TestBench/DUT/ROM_hpos
add wave -noupdate -expand -group ROM -radix unsigned /Top_FB_TestBench/DUT/ROM_vpos
add wave -noupdate /Top_FB_TestBench/DUT/ROM/enable
add wave -noupdate /Top_FB_TestBench/DUT/ROM/display_on
add wave -noupdate /Top_FB_TestBench/DUT/ROM/ROMready
add wave -noupdate -radix unsigned /Top_FB_TestBench/DUT/ROM/counter
add wave -noupdate -expand -group FIFO -expand -group HPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/write_data
add wave -noupdate -expand -group FIFO -expand -group HPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/read_data
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/push
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/pop
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/wr_ptr
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/rd_ptr
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/cnt
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/full
add wave -noupdate -expand -group FIFO -expand -group HPOS_data /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/empty
add wave -noupdate -expand -group FIFO -expand -group HPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/HPOS_FIFO/data
add wave -noupdate -expand -group FIFO -expand -group VPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/write_data
add wave -noupdate -expand -group FIFO -expand -group VPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/read_data
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/push
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/pop
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/wr_ptr
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/rd_ptr
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/cnt
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/empty
add wave -noupdate -expand -group FIFO -expand -group VPOS_data /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/full
add wave -noupdate -expand -group FIFO -expand -group VPOS_data -radix unsigned /Top_FB_TestBench/DUT/FIFO/VPOS_FIFO/data
add wave -noupdate -expand -group FIFO -expand -group RGB_data -radix binary /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/write_data
add wave -noupdate -expand -group FIFO -expand -group RGB_data -radix binary /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/read_data
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/push
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/pop
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/wr_ptr
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/rd_ptr
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/cnt
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/full
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/empty
add wave -noupdate -expand -group FIFO -expand -group RGB_data /Top_FB_TestBench/DUT/FIFO/RGB_FIFO/data
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/fifoempty
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/fifopush
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/fifopop
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/RGBfifo
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/hposfifo
add wave -noupdate -expand -group FIFO /Top_FB_TestBench/DUT/vposfifo
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/hpos_to_fb
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/vpos_to_fb
add wave -noupdate -expand -group FRAMEBUFFER -radix unsigned /Top_FB_TestBench/DUT/resetcnt
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/R_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/G_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/B_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/writeR_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/writeG_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/writeB_data
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/addrbuf_wire
add wave -noupdate -expand -group FRAMEBUFFER /Top_FB_TestBench/DUT/FrameBuffer/we
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/RESOLUTION_H
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/MEMORY_H
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/DATA_WIDTH
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/X_WIDTH
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Y_WIDTH
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/ADDR_WIDTH
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/RES_MULT
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/REGS_IN_ROW
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/DATASELECT_WIDTH
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC -radix unsigned /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/hpos
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/vpos
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/datafromR
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/datafromG
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/datafromB
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/RGBin
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/display_on
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/memenable
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/we
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/RGB
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Rdatatomem
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Gdatatomem
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Bdatatomem
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/addr
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Rdatabuf
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Gdatabuf
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/Bdatabuf
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/dataselect
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/dataselect_r
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/dataselect_w
add wave -noupdate -expand -group FRAMEBUFFER -expand -group CODEC /Top_FB_TestBench/DUT/FrameBuffer/FBCODEC/w_state
add wave -noupdate -expand -group FRAMEBUFFER -expand -group R /Top_FB_TestBench/DUT/FrameBuffer/R_MEMORY/ramblock
add wave -noupdate -expand -group FRAMEBUFFER -expand -group G /Top_FB_TestBench/DUT/FrameBuffer/G_MEMORY/ramblock
add wave -noupdate -expand -group FRAMEBUFFER -expand -group B /Top_FB_TestBench/DUT/FrameBuffer/B_MEMORY/ramblock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8320 ns} 0} {{Cursor 2} {22862 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 422
configure wave -valuecolwidth 78
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
configure wave -timelineunits ps
update
WaveRestoreZoom {8191 ns} {8555 ns}
