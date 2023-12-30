# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 4
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.cache/wt [current_project]
set_property parent.project_path D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/testIns_text.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/testIns_data.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/nh_text_sim.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/no_hazard_data.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/nh_data_sim.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/h_text_sim.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/h_data_sim.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sort_text.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sort_data.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/test.coe
add_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/no_hazard_text.coe
add_files d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/quick_sort_text.coe
read_verilog -library xil_defaultlib {
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/ID_reg.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/imports/Lab5/pdu-v1.1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/cpu.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/EX_reg.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/DataMem.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/reg_file.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/IF_reg.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/MEM_reg.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/alu.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/WB_reg.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/control_unit.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/data_ext.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/cpu_1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/WB_reg1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/control1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/main.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/NPC_Generator.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/BranchDecision.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/hazard_unit.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/BranchPredict.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/BTB.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/hazard_1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/ID_reg1.v
  D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/new/BHT.v
}
read_ip -quiet D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/Data_Mem/Data_Mem.xci
set_property used_in_implementation false [get_files -all d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/Data_Mem/Data_Mem_ooc.xdc]

read_ip -quiet D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/Instr_Mem/Instr_Mem.xci
set_property used_in_implementation false [get_files -all d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/Instr_Mem/Instr_Mem_ooc.xdc]

read_ip -quiet d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/InstrMem_quick/InstrMem_quick.xci
set_property used_in_implementation false [get_files -all d:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/sources_1/ip/InstrMem_quick/InstrMem_quick_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/constrs_1/imports/Lab简介/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files D:/ComputerScience/cs_COD_Spring_2022/Lab5/lab5/lab5.srcs/constrs_1/imports/Lab简介/Nexys4DDR_Master.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top main -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef main.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file main_utilization_synth.rpt -pb main_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]