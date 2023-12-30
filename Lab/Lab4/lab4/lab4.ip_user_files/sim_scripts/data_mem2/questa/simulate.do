onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib data_mem2_opt

do {wave.do}

view wave
view structure
view signals

do {data_mem2.udo}

run -all

quit -force
