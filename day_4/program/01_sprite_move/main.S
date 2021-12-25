# RISC-V simple sprite move program
#
# Dmitry Smekhov, 2021
#

            .text

start:
                li   a0, 120     # X       # set initial X
                li   a1, 150     # Y       # set initial Y

                li t6, 0x000 	# Prepare for set x,y for sprite 0
                mv t5, a0	    # set X
                mv t5, a1	    # set Y (field SEL has been incremented)


# line 0  -  move on X to right
                li   a2, 1      # step  X
                li 	 a3, 0	    # step  Y
                li   a4, 400    # cnt for line
                li   a5, 2      # cnt for wait vsync

              	li t4,0     # counter line

line0_move_x:   li a6, 0    # counter vsync

line0_loop_vsync: 	
                addi t6, zero, 0x0FF
            	addi t6, zero, 0x0FF	# delay for update new value of SPRITE_NUM
            	addi t6, zero, 0x0FF
line0_wait_vsync: 	
                beq  t5, zero, line0_wait_vsync

            	addi a6, a6, 1
            	bne  a6, a5, line0_loop_vsync

#            addi t6, zero, 0x000
#            addi t5, a0, 0
#            addi t5, a1, 0

		        li t6, 0x000 	# Prepare for set x,y for sprite 0
		        mv t5, a0	    # set X
		        mv t5, a1	    # set Y (field SEL has been incremented)
			
		        add a0, a0, a2	# change X
		        add a1, a1, a3	# change Y

            	addi t4, t4, 1	            # increment counter
            	bne t4, a4, line0_move_x	# compare counter with limit

# end of line 0
                #beq zero, zero, start

## line 1 - move on Y to bottom		
#
#		
#                li   a2, 0      # step  X
#                li 	 a3, 1	    # step  Y
#                li   a4, 200    # cnt for line
#                li   a5, 1      # cnt for wait vsync
#
#
#              	li t4,0     # counter line
#
#line1_move_x:   li a6, 0    # counter vsync
#
#line1_loop_vsync: 	
#                addi t6, zero, 0x0FF
#            	addi t6, zero, 0x0FF	# delay for update new value of SPRITE_NUM
#            	addi t6, zero, 0x0FF
#line1_wait_vsync: 	
#                beq  t5, zero, line1_wait_vsync
#
#            	addi a6, a6, 1
#            	bne  a6, a5, line1_loop_vsync
#
#
#
##            addi t6, zero, 0x000
##            addi t5, a0, 0
##            addi t5, a1, 0
#
#		        li t6, 0x000 	# Prepare for set x,y for sprite 0
#		        mv t5, a0	# set X
#		        mv t5, a1	# set Y (field SEL has been incremented)
#			
#		        add a0, a0, a2	# change X
#		        add a1, a1, a3	# change Y
#
#            	addi t4, t4, 1	            # increment conter
#            	bne t4, a4, line1_move_x	# compare counter with limit
#
## end of line 1


                beq zero, zero, start
