#!/bin/bash

rm -rf sim
mkdir  sim
cd     sim

vsim -c -do ../questa_script.tcl
