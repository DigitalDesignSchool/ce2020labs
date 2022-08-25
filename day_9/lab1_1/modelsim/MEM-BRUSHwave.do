onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MEM_BRUSH_TestBench/clk
add wave -noupdate /MEM_BRUSH_TestBench/reset_n
add wave -noupdate /MEM_BRUSH_TestBench/rgb
add wave -noupdate /MEM_BRUSH_TestBench/key_sw
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/N_MIXER_PIPE_STAGES
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/HPOS_WIDTH
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/VPOS_WIDTH
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_DISPLAY
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_FRONT
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_SYNC
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_BACK
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_DISPLAY
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_BOTTOM
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_SYNC
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_TOP
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_SYNC_START
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_SYNC_END
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/H_MAX
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_SYNC_START
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_SYNC_END
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/V_MAX
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/clk
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/reset
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/enable
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/hsync
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/vsync
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/display_on
add wave -noupdate -group VGA -radix unsigned /MEM_BRUSH_TestBench/i_vga/hpos
add wave -noupdate -group VGA -radix unsigned /MEM_BRUSH_TestBench/i_vga/vpos
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/d_hpos
add wave -noupdate -group VGA /MEM_BRUSH_TestBench/i_vga/d_vpos
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/DEBOUNCE_TIMER
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/clk
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/reset
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/RAW_BTN
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/BTN
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/BTN_POSEDGE
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/BTN_NEGEDGE
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/states_of_button_0
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/states_of_button_1
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/states_of_button_2
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/states_of_button_3
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/counter
add wave -noupdate -group DEBOUNCE /MEM_BRUSH_TestBench/Debouncer/state_changed
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/SLOWNESS
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/RESOLUTION_H
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/RESOLUTION_V
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/VPOS_WIDTH
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/HPOS_WIDTH
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/BRUSH_COLOR
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/BRUSH_BASE_SIZE
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/BRUSH_MAX_SIZE
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/INIT_XPOS
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/INIT_YPOS
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/SIZE_WIDTH
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/clk
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/reset
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/BTN
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/BTN_POSEDGE
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/display_on
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/fifofull
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/hpos
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/vpos
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/FB_RGB
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/memenable
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/rgb
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/writergb
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/fifopush
add wave -noupdate -expand -group BRUSH -radix unsigned /MEM_BRUSH_TestBench/Painting_Brush/writecounter_x
add wave -noupdate -expand -group BRUSH -radix unsigned /MEM_BRUSH_TestBench/Painting_Brush/writecounter_y
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/writestate
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/brush_size
add wave -noupdate -expand -group BRUSH -radix unsigned /MEM_BRUSH_TestBench/Painting_Brush/cursor_xpos
add wave -noupdate -expand -group BRUSH -radix unsigned /MEM_BRUSH_TestBench/Painting_Brush/cursor_ypos
add wave -noupdate -expand -group BRUSH /MEM_BRUSH_TestBench/Painting_Brush/counterclk
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/RESOLUTION_H
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/RESOLUTION_V
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/V_BOTTOM
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/V_SYNC
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/V_TOP
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/H_FRONT
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/H_SYNC
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/H_BACK
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_WIDTH
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/VPOS_WIDTH
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/FIFODEPTH
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/clk
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/rst
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/push
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/toppop
add wave -noupdate -group FIFO -radix unsigned /MEM_BRUSH_TestBench/FIFO/hpos_write
add wave -noupdate -group FIFO -radix unsigned /MEM_BRUSH_TestBench/FIFO/vpos_write
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/RGB_write
add wave -noupdate -group FIFO -radix unsigned /MEM_BRUSH_TestBench/FIFO/hpos_read
add wave -noupdate -group FIFO -radix unsigned /MEM_BRUSH_TestBench/FIFO/vpos_read
add wave -noupdate -group FIFO -radix unsigned /MEM_BRUSH_TestBench/FIFO/RGB_read
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/empty
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/full
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/counter
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/pop
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/hposempty
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/vposempty
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/RGBempty
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/hposfull
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/vposfull
add wave -noupdate -group FIFO /MEM_BRUSH_TestBench/FIFO/RGBfull
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/width
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/depth
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/pointer_width
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/counter_width
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/max_ptr
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/clk
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/rst
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/push
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/pop
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/write_data
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/read_data
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/empty
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/full
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/wr_ptr
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/rd_ptr
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/cnt
add wave -noupdate -group FIFO -expand -group HPOS_FIFO /MEM_BRUSH_TestBench/FIFO/HPOS_FIFO/data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/RAMLENGTH
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/DATA_WIDTH
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/V_BOTTOM
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/V_SYNC
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/V_TOP
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/H_FRONT
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/H_SYNC
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/H_BACK
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/RESOLUTION_H
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/RESOLUTION_V
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/X_WIRE_WIDTH
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/Y_WIRE_WIDTH
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/ADDR_WIDTH
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/display_on
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/clk
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/memreset
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/reset_n
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/resetcnt
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/RGBin
add wave -noupdate -expand -group MEM -radix unsigned /MEM_BRUSH_TestBench/FrameBuffer/hpos
add wave -noupdate -expand -group MEM -radix unsigned /MEM_BRUSH_TestBench/FrameBuffer/vpos
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/fifoempty
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/RGB
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/writeR_data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/writeG_data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/writeB_data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/R_data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/G_data
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/B_data
add wave -noupdate -expand -group MEM -radix unsigned /MEM_BRUSH_TestBench/FrameBuffer/addrbuf_wire
add wave -noupdate -expand -group MEM /MEM_BRUSH_TestBench/FrameBuffer/we
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/addr_r
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/addr_w
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/Rdatabuf
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/Gdatabuf
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/Bdatabuf
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/dataselect
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/dataselect_r
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/dataselect_w
add wave -noupdate -expand -group MEM -expand -group CODEC /MEM_BRUSH_TestBench/FrameBuffer/FBCODEC/w_state
add wave -noupdate -expand -group MEM -group G_BLOCK /MEM_BRUSH_TestBench/FrameBuffer/G_MEMORY/ramblock
add wave -noupdate -expand -group MEM -group G_BLOCK /MEM_BRUSH_TestBench/FrameBuffer/G_MEMORY/addr_x
add wave -noupdate -expand -group MEM -group G_BLOCK /MEM_BRUSH_TestBench/FrameBuffer/G_MEMORY/data_x
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/ADDR_WIDTH
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/RAMLENGTH
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/clk
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/memreset
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/resetcnt
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/memenable
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/stp
add wave -noupdate -group MEMRST /MEM_BRUSH_TestBench/memsyncreset/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2430975 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 387
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
WaveRestoreZoom {2005465 ns} {2786222 ns}
