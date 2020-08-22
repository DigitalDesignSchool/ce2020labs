#!/bin/bash
# x_synthesize.bash

. ./x_setup.bash

#-----------------------------------------------------------------------------

is_command_available_or_error quartus_sh " from Intel FPGA Quartus II package"

quartus_sh --no_banner --flow compile top 2>&1 | tee syn.log

ec=$?

if [ $ec != 0 ]
then
    grep -i -A 5 error syn.log 2>&1
    error $ec "synthesis failed"
fi

#-----------------------------------------------------------------------------

./x_configure.bash
