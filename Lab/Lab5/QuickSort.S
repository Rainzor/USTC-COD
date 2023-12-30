# 概述：对数组进行原地快排
.data
data:.word 0xf, 0xe, 0xd, 0xc, 0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0


#.org 0x0
  #  .global _start
.text
_start:
main:
    addi    a3, x0,128    # 指定排序问题的规规模
    
    li    sp, 4096    # 设置栈顶指针 sp=256
    
    xor    a0, zero, zero      # 准备函数参数，a0=0, 说明要排序的数组的RAM起始地址
    xor    a1, zero, zero      # 准备函数参数，a1=0，说明从0
    addi   a2, a3  , -1
    slli   a2, a2  , 2         # 准备函数参数，a2=数组，后一个元素的地址
    jal    ra  , QuickSort     #开始排序

    addi   t0, a3, 0
    addi   t1, a0, 0
    slli   t0, t0, 2
    slli   t1, t1, 2
Loop:
    lw     t2, 0(t1)
    addi   t1, t1, 4
    blt    t1, t0, Loop
infinity_loop:
    nop
    nop
    nop
    nop
    jal   zero, infinity_loop  # 排序结束，死循环

QuickSort:

        bge    a1, a2, QuickSortReturn                # if a1>=a2, end<=start, jump to return
        or     t1, a1, zero                           # t1=i=a1=start
        or     t2, a2, zero                           # t2=j=a2=end
        add    t0, a0, t1                             # 
        lw     t0, 0(t0)                               # t0=key=lst[start]

        PartationStart:          
            PartationFirstStart:                      # start of for loop
                bge    t1, t2, PartationEnd           # if i>=j, branch to next step
                add    t3, a0, t2                     # 
                lw     t3, 0(t3)                       # t3=lst[j]
                blt    t3, t0, PartationFirstEnd      # if lst[j]<key, branch to next step
                addi   t2, t2, -4                     # t2-=4  j--
                jal    zero, PartationFirstStart      # for loop
            PartationFirstEnd:                        # end of for loop
            add    t4  , a0, t1                       # t4=lst+i
            sw     t3  , 0(t4)                         # lst[i] = t3 = lst[j]
            
            PartationSecondStart:                     # start of for loop
                bge    t1, t2, PartationEnd           # if i>=j, branch to next step
                add    t3, a0, t1                     # 
                lw     t3, 0(t3)                       # t3=lst[i]
                blt    t0, t3, PartationSecondEnd     # if key<lst[i], branch to next step
                addi   t1, t1, 4                      # t1+=4  i++
                jal    zero, PartationSecondStart     # for loop
            PartationSecondEnd:                       # end of for loop 
            add    t4  , a0, t2                       # t4=lst+j
            sw     t3  , 0(t4)                         # lst[j] = t3 = lst[i]
            
            blt    t1, t2, PartationStart             # if t1<t2, branch to while start
        PartationEnd:

        add    t4  , a0, t1                           # t4=lst+i
        sw     t0  , 0(t4)                             # lst[i] = t0 = key
        
        addi   sp, sp, -4                              # sp-=4        
        sw     ra, 0(sp)                                # mem[sp] = ra # push ra to stack
        addi   sp, sp, -4                              # sp-=4
        sw     a1, 0(sp)                                # mem[sp] = a1 # push a1 to stack, save start
        addi   sp, sp, -4                              # sp-=4        
        sw     a2, 0(sp)                                # mem[sp] = a2 # push a2 to stack, save end
        addi   sp, sp, -4                              # sp-=4        
        sw     t1, 0(sp)                                # mem[sp] = t1 # push t1 to stack, save i
        addi   a2, t1, -4                              # a2 = i-4, a parameter for recursive call
        jal    ra  , QuickSort
        lw     t1, 0(sp)                                # pop i form stack 
        addi   sp, sp,  4                              # sp+=4
        lw     a2, 0(sp)                                # pop end form stack 
        addi   sp, sp,  4                              # sp+=4
        lw     a1, 0(sp)                                # pop start form stack 

        addi   sp, sp, -4                              # sp-=4        
        sw     a2, 0(sp)                                # mem[sp] = a2 # push a2 to stack, save end
        addi   sp, sp, -4                              # sp-=4        
        sw     t1, 0(sp)                                # mem[sp] = t1 # push t1 to stack, save i
        addi   a1, t1, 4                               # a1 = i+4, a parameter for recursive call
        jal    ra  , QuickSort
        lw     t1, 0(sp)                                # pop i form stack 
        addi   sp, sp,  4                              # sp+=4
        lw     a2, 0(sp)                                # pop end form stack 
        addi   sp, sp,  4                              # sp+=4
        lw     a1, 0(sp)                                # pop start form stack 
        addi   sp, sp,  4                              # sp+=4
        lw     ra, 0(sp)                                # pop ra form stack 
        addi   sp, sp,  4                              # sp+=4

    QuickSortReturn:                                   # 函数结尾
        jalr   ra                             # 返回

        


#
# QuickSort函数的等效C代码:
#   void QuickSort(int *lst, int start, int end){
#       if(end>start){
#           int i = start,j = end,key = lst[start];
#           while(i < j){
#               for (;i < j && key <= lst[j];j--);
#               lst[i] = lst[j];
#               for (;i < j && key >= lst[i];i++);
#               lst[j] = lst[i];
#           }
#           lst[i] = key;
#           QuickSort(lst, start, i - 1);
#           QuickSort(lst, i + 1, end);
#       }
#   }
#
#
        
