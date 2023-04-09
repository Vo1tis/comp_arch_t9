 .text
	.align 4
	.global fun
fun:	addi t0, zero, 2 # immediate 2 needed for "if(n<2)"
		bge a0, t0, elseF # if n<2 false, i.e. if n≥2 goto ELSE
		addi a0, zero, 1 # THEN: create return-value 1, place in reg. a0
		jr ra # return --this is the end of the "then" clause
elseF:	addi sp, sp, -8 # PUSH1: allocate 8 Bytes on the stack
		sw ra, 4(sp) # PUSH2: save ra into first allocated word
		sw a0, 0(sp) # PUSH3: save my argument (n) into second word
		addi a0, a0, -1 # create argument (n-1) into a0 for my child
		jal ra, fun # call my child procedure
		add t0, a0, zero # copy return value from my child into t0
		lw ra, 4(sp) # POP1: restore ra from stack
		lw a0, 0(sp) # POP2: restore a0 from stack
		addi sp, sp, 8 # POP3: dealloc the 8 B that I had allocated
		mul a0, a0, t0 # multiply my own arg a0==n times the return
jr ra