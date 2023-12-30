.data
Keyboard_state: .eqv keyboard_state,0x7f00
Keyboard_data: .eqv keyboard_data,0x7f04
Display_data: .eqv display_data,0x7f0c
Display_state: .eqv display_state,0x7f08
Ascii_to_hex: .eqv  ascii_to_hex,0x0061   #a的ascii码
Hex_to_ascii: .eqv  hex_to_ascii,0x000a   #a的hex码
.eqv and_3,0xf000
.eqv and_2,0x0f00
.eqv and_1,0x00f0
.eqv and_0,0x000f

.text
Main:
li s1,ascii_to_hex             #s1存a的ascii码
jal ra,READIN
jal ra,SORT
jal ra,PRINT
ret

READIN:
mv a1,ra 
jal ra,GET_NUMBER
mv s3,s0                         #s3为数组长度
mv s4,s3
mv s5,zero

READ_ARRAY:
jal ra,GET_NUMBER
addi s5,s5,1                     #s5为读入数组并存储的循环变量
sw s0,0(sp)
addi sp,sp,-4                    #sp为数据指针
blt s5,s4,READ_ARRAY
mv ra,a1
ret

GET_NUMBER:
add s0,x0,x0                   #s0清零，保存读入的数据
li t1,keyboard_data
CIR_1:lw t0,keyboard_state
beq t0,zero,CIR_1
lw t2,0(t1)                      #t2存入字符数据
blt t2,s1,STORE_1                       #读入的数比a大
addi t2,t2,-39
STORE_1:addi t2,t2,-48
add s0,s0,t2

CIR_2:lw t0,keyboard_state
beq t0,zero,CIR_2
lw t2,0(t1)                      #t2存入字符数据
blt t2,s1,STORE_2                       #读入的数比a大
addi t2,t2,-39
STORE_2: addi t2,t2,-48
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,t2

CIR_3:lw t0,keyboard_state
beq t0,zero,CIR_3
lw t2,0(t1)                      #t2存入字符数据
blt t2,s1,STORE_3                       #读入的数比a大
addi t2,t2,-39
STORE_3: addi t2,t2,-48
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,t2

CIR_4:lw t0,keyboard_state
beq t0,zero,CIR_4
lw t2,0(t1)                      #t2存入字符数据
blt t2,s1,STORE_4                       #读入的数比a大
addi t2,t2,-39
STORE_4: addi t2,t2,-48
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,s0
add s0,s0,t2

CIR_:lw t0,keyboard_state     #读入回车
beq t0,zero,CIR_
lw t2,0(t1)        
ret

SORT:
addi t3,s3,1
addi s5,zero,1           #循环变量count到s3截止
addi s6,zero,2
addi s4,sp,4         #与sp相对的另一地址指针
START:lw t0,0(sp)
lw t1,0(s4)         #两个临时变量比较
blt t0,t1,NEXT
sw t1,0(sp)
sw t0,0(s4)
NEXT:
addi,s6,s6,1
addi s4,s4,4
blt s6,t3,CONTINUE
addi s5,s5,1
addi s6,s5,1
addi sp,sp,4
addi s4,sp,4
blt s5,t3,START
ret
CONTINUE:
beq zero,zero,START

PRINT:
mv a1,ra              #保存返回地址
addi s5,zero,0        #s5作为循环变量,sp记录数据指针
li a4,and_3
li a5,and_2
li a6,and_1
li a7,and_0
PRINT_NEXT:
jal ra,OUTPUT_NUMBER
addi s5,s5,1
addi sp,sp,-4
blt s5,s3,PRINT_NEXT
mv ra,a1
ret

OUTPUT_NUMBER:
li s11,display_data
li s1,hex_to_ascii
lw t0,0(sp)
and t1,t0,a4
srai t1,t1,12
blt t1,s1,OUT_1
addi t1,t1,39
OUT_1:addi t1,t1,48
CIR_5:lw t2,display_state
beq t2,zero,CIR_5
sw t1,0(s11)

and t1,t0,a5
srai t1,t1,8
blt t1,s1,OUT_2
addi t1,t1,39
OUT_2:addi t1,t1,48
CIR_6:lw t2,display_state
beq t2,zero,CIR_6
sw t1,0(s11)

and t1,t0,a6
srai t1,t1,4
blt t1,s1,OUT_3
addi t1,t1,39
OUT_3:addi t1,t1,48
CIR_7:lw t2,display_state
beq t2,zero,CIR_7
sw t1,0(s11)

and t1,t0,a7
blt t1,s1,OUT_4
addi t1,t1,39
OUT_4:addi t1,t1,48
CIR_8:lw t2,display_state
beq t2,zero,CIR_8
sw t1,0(s11)

li t3,0x000a
CIR_9:lw t2,display_state
beq t2,zero,CIR_9
sw t3,0(s11)
ret
