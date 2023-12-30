.data
Keyboard_state: .eqv keyboard_state,0x7f00
Keyboard_data: .eqv keyboard_data,0x7f04

.text
li t3,keyboard_data
target:li t0,keyboard_state
lw t1,0(t0)
beq t1,zero,target
lw gp,0(t3)
lw gp,0(t3)
lw gp,0(t3)
lw gp,0(t3)
lw gp,0(t3)