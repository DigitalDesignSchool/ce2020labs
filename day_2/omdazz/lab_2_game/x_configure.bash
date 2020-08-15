#!/bin/bash
# x_configure.bash

. ./x_setup.bash

[ -d "$SYN_DIR" ] ||  \
    error 1 "synthesis directory $SYN_DIR does not exist. Run synthesis first."

guarded cd $SYN_DIR

is_command_available_or_error quartus_pgm " from Intel FPGA Quartus II package"

guarded quartus_pgm -l &> cable_list

CABLE_NAME_1=$(grep "1) " cable_list | sed 's/1) //')
CABLE_NAME_2=$(grep "2) " cable_list | sed 's/2) //')

if [ "$CABLE_NAME_1" ]
then
    if [ "$CABLE_NAME_2" ]
    then
        warning "more than one cable is connected: $CABLE_NAME_1 and $CABLE_NAME_2"
    fi

    info "using cable $CABLE_NAME_1"
    # quartus_pgm --no_banner -c "$CABLE_NAME_1" --mode=jtag -o "P;top.sof"
    guarded quartus_pgm --no_banner -c \""$CABLE_NAME_1"\" --mode=jtag -o \""P;top.sof"\"
else
    error 1 "cannot detect a USB-Blaster cable connected"
fi

exit 0
