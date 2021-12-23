# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

start:      li   a0, 20     # start X
            li   a1, 600    # stop  X
            li   a2, 1    # step  X

            li   a3, 226    # start Y
            li   a4, 400    # stop  Y
            li   a5, 6      # step  Y


move_x:     addi t6, zero, 0x000
            addi t5, a0, 0
            addi t5, a3, 0

            addi a6, zero, 0
            addi a7, zero, 2

loop_vsync: addi t6, zero, 0x0FF
            addi t6, zero, 0x0FF
            addi t6, zero, 0x0FF
wait_vsync0: beq  t5, zero, wait_vsync0

            addi a6, a6, 1
            bne  a6, a7, loop_vsync

            add a0, a0, a2
            bne a0, a1, move_x

            beq zero, zero, start

#            addi t6, zero, 0x000
#            addi t5, zero, 0x10   # X
#            addi t5, zero, 0x21   # Y

