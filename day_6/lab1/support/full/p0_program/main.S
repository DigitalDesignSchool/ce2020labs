# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

            li a0, 0

            li a1, 0   # write address
            li a2, 0   # read address
            li a3, 1   # write data

            li t6, 2  # REG_KEY0
            li t5, 0
            li t6, 3  # REG_KEY1
            li t5, 0

            li t6, 1  # REG_HEX
            li t5, 0xF


start:      li t6, 2  # REG_KEY0
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, check_key1  # key not pressed
            li t5, 0  # reset key0
            beq zero, zero, cycle_write

check_key1:
            li t6, 3  # REG_KEY1
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, start  # key not pressed
            li t5, 0  # reset key1
            beq zero, zero, cycle_read

cycle_write:
            

            li t6, 8 # REG_MODE_ADR
            mv t5, a1

            li t6, 9 # REG_MODE_DATA
            mv t5, a3

            li t6, 10 # REG_MODE_CNT
            li t5, 4

            li t6, 0x100  # START WRITE

check_w_done:
            li t6, 4  # REG_W_DONE
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, check_w_done  # w_done==0
            
            addi a1, a1, 4
            addi a3, a3, 1

            beq zero, zero, start



cycle_read:
            

            li t6, 8 # REG_MODE_ADR
            mv t5, a2

            li t6, 10 # REG_MODE_CNT
            li t5, 4

            li t6, 0x200  # START READ

check_r_done:
            li t6, 5  # REG_R_DONE
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            beq t5, zero, check_r_done  # r_done==0
            
            addi a2, a2, 4

            li t6, 6  # REG_CALCULATE
            addi a0, a0, 0     
            addi a0, a0, 0     
            addi a0, a0, 0     
            mv a0, t5

            li t6, 1  # REG_HEX
            mv t5, a0               # show result

            beq zero, zero, start            

            




            
 
