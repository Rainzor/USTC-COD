onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Data_Mem_opt

do {wave.do}

view wave
view structure
view signals

do {Data_Mem.udo}

run -all

quit -force
