#!/usr/bin/python3

from sys import argv
from math import sin, pi

if len(argv) != 2:
    exit(f"usage:\n{argv[0]} freq_in_hz")

Fs = 48000
F = int(argv[1])
w = 32
A = 2**(w - 1) - 1

N = Fs // F

ts = [t for t in range(N)]
xs = [round(A * sin(2 * pi * t / N)) for t in ts]

print("// y(t) = sin(2*pi*F*t), F={0}Hz, Fs={1}Hz".format(F, Fs))
for t in ts:
    print("{0:d}: y = {1:d}'b{2:032b};".format(t, w, xs[t] & (2**w - 1)))

# Plot

#import matplotlib.pyplot as plt

#plt.plot(ts, xs, '.', lw=2)
#plt.grid(True)
#plt.show()
