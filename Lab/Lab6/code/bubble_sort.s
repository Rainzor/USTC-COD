.data
data:.word 0xf, 0xe, 0xd, 0xc, 0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0

.text
sort:
	addi s0, x0,128	#n
	li a0, 0		#get address
	li s1, 0 		    #i=0

loop1:	
    	bge s1, s0, exit1 	#if(i>=n) goto exit1
    	addi s2, s0, -1	# j=n-1
loop2:  
   	bge s1,s2,exit2   	#if(i>=j) goto exit2
	slli a2, s2, 2     	#a2=j*4
	addi a2,a2,-4		#a2=(j-1)*4
	add a2, a0, a2     	#a2= data_address+j*4 
	lw t1, 0(a2)     	    #get data,data[j-1]
	lw t2, 4(a2)    	    #get data,data[j]
	bge t1, t2 , swap     #if(data[j-1]>=data[j]) swap
	jal x0 ,next 
swap:	
	sw t1, 4(a2)		    #swap 
	sw t2, 0(a2)
next:	
    	addi s2, s2, -1	    #j--
	jal x0,	loop2		    #goto loop2
	
	
exit2:	
	addi s1, s1, 1		#i++
	jal x0, loop1		#goto loop1
exit1:
     addi x0, x0, 1
    
