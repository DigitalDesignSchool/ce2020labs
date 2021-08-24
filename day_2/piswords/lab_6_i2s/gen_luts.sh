#!/usr/bin/bash

WIDTH=${1:-16}

rm -f luts.vh

for note in C Cs D Ds E F Fs G Gs A As B; do
    echo "Generating LUT for $note, $WIDTH-bit..."
    python3 gen.py --note $note $WIDTH >> luts.vh
done

