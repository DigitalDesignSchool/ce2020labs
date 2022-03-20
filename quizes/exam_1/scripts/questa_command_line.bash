#!/bin/bash

source ../scripts/questa_setup.bash
"$vsim" -c -do ../scripts/questa_command_line.tcl
