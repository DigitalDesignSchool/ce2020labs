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
            beq t5, zero, start  # key not pressed

            li t5, 0  # reset status 

           li t6, 4
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, start  # credit_counter==0

            li t6, 8
            addi a0, a0, 1
            mv  t5, a0          # send a0 to p1_cpu

#            addi a0, a0, 1
            li  t6, 1
            mv  t5, a0          # set display digit
            
            beq zero, zero, start
 
