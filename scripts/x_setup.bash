#!/bin/bash
# x_setup.bash

set +e  # Don't exit immediately if a command exits with a non-zero status

#-----------------------------------------------------------------------------

readonly script=$(basename "$0")

#-----------------------------------------------------------------------------

export MODELSIM_ROOTDIR="$HOME/intelFPGA_lite/18.1/modelsim_ase"
export PATH="${PATH}:$MODELSIM_ROOTDIR/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$MODELSIM_ROOTDIR/lib32"

#export QUARTUS_ROOTDIR=${HOME}/altera/13.0sp1/quartus
export QUARTUS_ROOTDIR=${HOME}/intelFPGA_lite/18.1/quartus
export PATH=${PATH}:${QUARTUS_ROOTDIR}/bin

SIM_DIR=${PWD}/sim
SYN_DIR=${PWD}/syn

#-----------------------------------------------------------------------------

error ()
{
    ec=$1
    shift

    [ $ec != 0 ] || return

    printf "$script: error: $*" 1>&2
    
    if [ $ec != 1 ]
    then
        printf ". Exiting with code $ec." 1>&2
    fi
    
    printf "\n" 1>&2
    exit $ec
}

#-----------------------------------------------------------------------------

warning ()
{
    printf "$script: warning: $*\n" 1>&2
}

#-----------------------------------------------------------------------------

info ()
{
    printf "$script: $*\n" 1>&2
}

#-----------------------------------------------------------------------------

is_command_available ()
{
    command -v $1 &> /dev/null
}

#-----------------------------------------------------------------------------

is_command_available_or_error ()
{
    is_command_available $1 ||  \
        error 1 "program $1$2 is not in the path or cannot be run"
}

#-----------------------------------------------------------------------------

guarded ()
{
    is_command_available_or_error $1
    eval "$*" || error $? "cannot $*"
}
