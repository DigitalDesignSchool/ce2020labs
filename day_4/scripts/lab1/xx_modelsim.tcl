#vlib work
vlog -O0 +acc=mnprt ../../../common/*.v ../../../../common/*.v
#vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../../*.sv
vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../../*.v
vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../*.v
vsim work.testbench



add wave -radix hex sim:/testbench/clk
add wave -radix hex sim:/testbench/reset_n
add wave -radix hex sim:/testbench/i_top.i_game_top.vcu_reg_control
add wave -radix hex sim:/testbench/i_top.i_game_top.vcu_reg_control_we
add wave -radix hex sim:/testbench/i_top.i_game_top.vcu_reg_wdata
add wave -radix hex sim:/testbench/i_top.i_game_top.vcu_reg_wdata_we
add wave -radix hex sim:/testbench/i_top.i_game_top.vcu_reg_rdata
add wave -radix hex sim:/testbench/i_top.i_game_top.vsync
add wave -radix hex sim:/testbench/i_top.i_game_top.display_on
add wave -radix hex sim:/testbench/i_top.i_game_top.rgb
add wave -radix hex sim:/testbench/i_top.i_game_top.imAddr
add wave -radix hex sim:/testbench/i_top.i_game_top.imData
add wave -radix hex sim:/testbench/i_top.i_game_top.sprite_torpedo_write_xy
add wave -radix hex sim:/testbench/i_top.i_game_top.sprite_torpedo_write_x
add wave -radix hex sim:/testbench/i_top.i_game_top.sprite_torpedo_write_y
add wave -radix hex sim:/testbench/i_top.i_game_top.sm_cpu_vc.rf.rf


run -all
wave zoom full
