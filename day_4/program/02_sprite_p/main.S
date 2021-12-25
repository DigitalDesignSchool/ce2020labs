# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

start:
            li   a0, 320     # X       # set initial X
            li   a1, 240     # Y       # set initial Y

            li t6, 0x000 	# Prepare for set x,y for sprite 0
            mv t5, a0	# set X
            mv t5, a1	# set Y (field SEL has been incremented)

            #beq zero, zero, line3


            li   a2, 0      # step  X
            li 	 a3, 0	    # step  Y





line0_loop_vsync: 	
                addi t6, zero, 0x0FF
            	addi t6, zero, 0x0FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x0FF
line0_wait_vsync: 	
                beq  t5, zero, line0_wait_vsync

                li a2, 0
                li a3, 0

check_key0:     addi t6, zero, 0x1FF
            	addi t6, zero, 0x1FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x1FF

                beq t5, zero, check_key1
                li a2, 1

check_key1:     addi t6, zero, 0x2FF
            	addi t6, zero, 0x2FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x2FF

                beq t5, zero, check_key2
                li a2, -1

check_key2:     addi t6, zero, 0x3FF
            	addi t6, zero, 0x3FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x3FF

                beq t5, zero, check_key3
                li a3, 1

check_key3:     addi t6, zero, 0x4FF
            	addi t6, zero, 0x4FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x4FF

                beq t5, zero, change_xy
                li a3, -1

change_xy:      add a0, a0, a2	# change X
		        add a1, a1, a3	# change Y

		        li t6, 0x000 	# Prepare for set x,y for sprite 0
		        mv t5, a0	# set X
		        mv t5, a1	# set Y (field SEL has been incremented)
                

                beq zero, zero, line0_loop_vsync
