onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Instr_Mem_quick_opt

do {wave.do}

view wave
view structure
view signals

do {Instr_Mem_quick.udo}

run -all

quit -force
