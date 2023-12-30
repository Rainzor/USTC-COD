.data
size:.word 16
data:.word 0xf, 0xe, 0xd, 0xc, 0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0

.text
sort:
	lw s0, size		#n=16
	la s1,data	
	li s2, 0 		#i=0
loop1:	
    	bge s2, s0, exit1 		#if(i>=n) goto exit1
	addi s3, s2, 1    	# j=i+1
	addi s4, s2 ,0 	# min=i
loop2:  
    bge s3,s0,swap    	#if(j>=n) goto exit2
	
	slli a3, s3, 2     	#a3=j*4
	add a3, s1,a3    	#a3= data_address+j*4 
	lw t3, 0(a3)     	# j
	slli a4, s4, 2     	#a4 = min*4
	add a4, s1,a4    	#a4 = data_address+min*4 
	lw t4, 0(a4)    	#min
	ble t3, t4 , select_min    #if(data[j]<data[min]) select_min
	jal x0 ,next 
select_min:
	mv s4, s3
	
next:	
    addi s3, s3, 1		#j++
	jal x0,	loop2		#goto loop2
	
swap:	
	beq s2, s4, exit2    	#if(i==min) next loop1
	slli a2, s2, 2     	#a2=i*4
	add a2, s1, a2    	#a2 = data_address+i*4 
	lw t2, 0(a2)    	# i
	slli a4, s4, 2     	#t0=min*4
	add a4, s1, a4    	#t0= data_address+min*4 
	lw t4, 0(a4)    	# min
	sw t2, 0(a4)		#
	sw t4, 0(a2)
	
exit2:	addi s2, s2, 1		#i++
	jal x0, loop1		#goto loop2
exit1:
	li a0, 0x7f08
	li s2, 0 		#i=0
	li s3, 9
loop3:   	
    	bge s2, s0, exit3	
    	
    	slli a2, s2, 2     	#a2=i*4
	add a2, s1, a2    	#a2 = data_address+i*4 
	lw t2,0(a2)
	ble t2,s3,case1
	jal x0, case2
case1:
	addi t2,t2,48
	
	sw t2,4(a0)
	jal x0,forever
case2:
  	addi t2, t2,55
  	
  	sw t2,4(a0)
  	
forever:
	lw t0,0(a0)
	beq t0,x0,forever
		
    	addi s2, s2, 1		#i++
	jal x0,	loop3		#goto loop3
exit3:
	nop