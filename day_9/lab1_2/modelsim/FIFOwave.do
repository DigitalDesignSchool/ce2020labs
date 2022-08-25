onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FIFOTestBench/clk
add wave -noupdate /FIFOTestBench/reset_n
add wave -noupdate /FIFOTestBench/push
add wave -noupdate /FIFOTestBench/pop
add wave -noupdate /FIFOTestBench/empty
add wave -noupdate /FIFOTestBench/full
add wave -noupdate -radix unsigned /FIFOTestBench/hpos
add wave -noupdate -radix unsigned /FIFOTestBench/hpos_read
add wave -noupdate -radix unsigned /FIFOTestBench/vpos
add wave -noupdate -radix unsigned /FIFOTestBench/vpos_read
add wave -noupdate /FIFOTestBench/RGBin
add wave -noupdate /FIFOTestBench/RGB
add wave -noupdate /FIFOTestBench/DUT/HPOS_FIFO/max_ptr
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/push
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/pop
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/write_data
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/read_data
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/empty
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/full
add wave -noupdate -expand -group HPOS_FIFO /FIFOTestBench/DUT/HPOS_FIFO/data
add wave -noupdate -expand -group HPOS_FIFO -radix unsigned /FIFOTestBench/DUT/HPOS_FIFO/wr_ptr
add wave -noupdate -expand -group HPOS_FIFO -radix unsigned /FIFOTestBench/DUT/HPOS_FIFO/rd_ptr
add wave -noupdate -expand -group HPOS_FIFO -radix unsigned /FIFOTestBench/DUT/HPOS_FIFO/cnt
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/push
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/pop
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/write_data
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/read_data
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/empty
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/full
add wave -noupdate -expand -group VPOS_FIFO /FIFOTestBench/DUT/VPOS_FIFO/data
add wave -noupdate -expand -group VPOS_FIFO -radix unsigned /FIFOTestBench/DUT/VPOS_FIFO/wr_ptr
add wave -noupdate -expand -group VPOS_FIFO -radix unsigned /FIFOTestBench/DUT/VPOS_FIFO/rd_ptr
add wave -noupdate -expand -group VPOS_FIFO -radix unsigned /FIFOTestBench/DUT/VPOS_FIFO/cnt
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/push
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/pop
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/write_data
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/read_data
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/empty
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/full
add wave -noupdate -expand -group RGB_FIFO /FIFOTestBench/DUT/RGB_FIFO/data
add wave -noupdate -expand -group RGB_FIFO -radix unsigned /FIFOTestBench/DUT/RGB_FIFO/wr_ptr
add wave -noupdate -expand -group RGB_FIFO -radix unsigned /FIFOTestBench/DUT/RGB_FIFO/rd_ptr
add wave -noupdate -expand -group RGB_FIFO -radix unsigned /FIFOTestBench/DUT/RGB_FIFO/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 288
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
WaveRestoreZoom {0 ns} {279 ns}
