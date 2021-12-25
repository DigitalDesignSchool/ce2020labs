#vlib work
vlog -O0 +acc=mnprt ../../../common/*.v ../../../../common/*.v
#vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../../*.sv
vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../../*.v
vlog -O0 +acc=mnprt +incdir+../../../common +incdir+../../../../common ../*.v
