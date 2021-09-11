#!/bin/bash
# x_simulate.bash

. ./x_setup.bash

#-----------------------------------------------------------------------------

run_iverilog=0
run_gtkwave=0
run_vsim=0

is_command_available iverilog && run_iverilog=1
is_command_available gtkwave  && run_gtkwave=1
is_command_available vsim     && run_vsim=1

#-----------------------------------------------------------------------------

if [ $run_iverilog = 1 ] && [ $run_vsim = 1 ]
then
    printf "Two Verilog simulators are available to run:"
    printf " Icarus Verilog and Mentor ModelSim\n"
    printf "Which do you want to run?\n"

    options="Icarus ModelSim Both"
    PS3="Your choice: "

    select simulator in $options
    do
        case $simulator in
        Icarus)   run_vsim=0     ; break ;;
        ModelSim) run_iverilog=0 ; break ;;
        Both)                      break ;;
        esac
    done
fi

if [ $run_iverilog = 0 ] && [ $run_gtkwave = 1 ]
then
    run_gtkwave=0
fi

[ $run_iverilog = 0 ] && [ $run_vsim = 0 ] &&  \
    error 1 "No Verilog simulator is available to run."  \
            "You need to install either Icarus Verilog"  \
            "or Mentor Questa / ModelSim."

#-----------------------------------------------------------------------------

if [ $run_iverilog = 1 ]
then
    iverilog -g2005  \
        -I ..     -I ../../../common     -I ../../../../common      \
           ../*.v    ../../../common/*.v    ../../../../common/*.v  \
        2>&1 | tee icarus.compile.log
        
    ec=$?

    if [ $ec != 0 ]
    then
        grep -i -A 5 error icarus.compile.log 2>&1
        error $ec Icarus Verilog compiler errors
    fi

    vvp a.out 2>&1 | tee icarus.simulate.log
    ec=$?

    sed -i '/^VCD info: dumpfile dump.vcd opened for output.$/d'  \
        icarus.simulate.log

    if [ $ec != 0 ]
    then
        grep -i -A 5 error icarus.simulate.log 2>&1
        tail -n 5 icarus.simulate.log 2>&1
        error $ec Icarus Verilog simulator errors
    fi

    info Icarus Verilog simulation successfull
    tail -n 5 icarus.simulate.log
fi

#-----------------------------------------------------------------------------

if [ $run_gtkwave = 1 ]
then
    ec=0

    if    [ "$OSTYPE" = "linux-gnu" ]  \
       || [ "$OSTYPE" = "cygwin"    ]  \
       || [ "$OSTYPE" = "msys"      ]
    then
        gtkwave                                 \
            --dump dump.vcd                     \
            --script xx_gtkwave.tcl  \
            2>&1 | tee waveform.log

    elif [ ${OSTYPE/[0-9]*/} = "darwin" ]
    # elif [[ "$OSTYPE" = "darwin"* ]]  # Alternative way
    then
        # For some reason the following way of opening the application
        # does not read the script file:
        #
        # open -a gtkwave dump.vcd --args --script $PWD/xx_gtkwave.tcl
        #
        # This way works:

        /Applications/gtkwave.app/Contents/MacOS/gtkwave-bin  \
            --dump dump.vcd --script xx_gtkwave.tcl           \
            2>&1 | tee waveform.log
    else
        error 1 "don't know how to run GTKWave on your OS $OSTYPE"
    fi

    ec=$?

    if [ $ec != 0 ]
    then
        grep -i -A 5 error waveform.log 2>&1
        error $ec "waveform viewer failed"
    fi
fi

#-----------------------------------------------------------------------------

if [ $run_vsim = 1 ]
then
    ec=0

    if    [ "$OSTYPE" = "linux-gnu" ]  \
       || [ "$OSTYPE" = "cygwin"    ]  \
       || [ "$OSTYPE" = "msys"      ]
    then
        vsim -gui -do xx_modelsim.tcl 2>&1 | tee modelsim.log
    else
        error 1 "don't know how to run ModelSim on your OS $OSTYPE"
    fi

    ec=$?

    if [ $ec != 0 ]
    then
        grep -i -A 5 error modelsim.log 2>&1
        error $ec "ModelSim failed"
    fi
fi

#-----------------------------------------------------------------------------

exit 0
