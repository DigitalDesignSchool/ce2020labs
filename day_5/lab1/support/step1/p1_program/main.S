# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

            li a0, 0
            li t6, 2
            li t5, 0
             
            li t6, 1
            li t5, 0 


start:      li t6, 2
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, start

            li t5, 0 

#            li t6, 3
#            addi a0, a0, 0     
#            addi a0, a0, 0     
#            addi a0, a0, 0     
#            beq t5, zero, start  # fifo is empty

#            li t6, 9
#            addi a0, a0, 0
#            addi a0, a0, 0
#            addi a0, a0, 0
#            mv  a1, t5          # receive a1 from p0_cpu

#           li t6, 5            # generate fifo_o_rd

#            li t6, 1
#            mv t5, a1          # set display digit

            addi a0, a0, 1
            li t6, 1
            mv t5, a0          # set display digit

            beq zero, zero, start
 
