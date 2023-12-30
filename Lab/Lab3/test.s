.data
led_data:.word 1
swt_data:.word 2
fail_data:.word 0xffff

.text
test_lw:
    lw a1, 0(x0)#test_lw
    lw a2, 4(x0)
test_sw:
    sw a2, 0(x0)#test_sw
test_jal:
    jal x0,test_beq    #test_jal
silent1:
    addi a1, x0, 0 
test_beq:
    beq x0,x0 ,test_blt  #test_beq
    jal x0, fail
silent2:
    addi a2, x0, 0 
test_blt:
    blt x0,a1,test_addi    #test_blt
test_addi:
    addi a2, x0,2   #test_addi
    addi a0,x0,2 
    beq a0,a2,test_add
    jal x0,fail
test_add:
    add a3, a1, a2    #test_add
    addi a0,x0,3
    beq a0,a3,test_sub
    jal x0,fail
test_sub:
    addi a4,x0,4
    sub a4, a4,a1    #test_sub
    addi a0,x0,3
    beq a0, a4, test_auipc   
    jal x0,fail
    
test_auipc:
    auipc t1, 0x1	#test_auipc
    auipc t0,0x1
    addi t1,t1,4  
    beq t0,t1,test_jalr
    jal x0,fail
test_jalr:
    auipc t0,0		#test_jalr
    jalr x0,t0,20
    jal x0,fail
fail:
    lw a0,8(x0)
    sw a0,0(x0)
    jal x0,exit
success:
    addi a0,x0,0	#exit	
exit:
		
	   
    
