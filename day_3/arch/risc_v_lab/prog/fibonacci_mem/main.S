            .text

start:      li    t4, 0x10010000
            li    t2, 10
            li    t0, 1
            li    t1, 1
            sw	  t0, (t4)
            addi  t4, t4, 0x4
            sw	  t1, (t4)

fibonacci:  mv    a0, t1
            add   t1, t0, t1
            mv    t0, a0
            addi  t2, t2, -1
            addi  t4, t4, 0x4
            sw	  t1, (t4)
            bnez  t2,  fibonacci
