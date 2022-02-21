#!/bin/bash

rm -rf run
mkdir  run
cd     run

vsim -c -do ../questa_script.tcl
