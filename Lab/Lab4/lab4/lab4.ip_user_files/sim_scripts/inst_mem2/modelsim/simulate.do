onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.inst_mem2 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {inst_mem2.udo}

run -all

quit -force
