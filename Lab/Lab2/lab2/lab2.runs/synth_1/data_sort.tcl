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
set_param xicom.use_bs_reader 1
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.cache/wt [current_project]
set_property parent.project_path D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/ip/distributed_ip.coe
add_files D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/ip/block_ip.coe
add_files D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/ip/sort_DRAM.coe
read_verilog -library xil_defaultlib {
  D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/new/DEP.v
  D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/new/DP.v
  D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/new/segment_trans.v
  D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/new/data_sort.v
}
read_ip -quiet D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/ip/dist_mem_gen_1/dist_mem_gen_1.xci
set_property used_in_implementation false [get_files -all d:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/sources_1/ip/dist_mem_gen_1/dist_mem_gen_1_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/constrs_1/imports/Lab简介/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files D:/ComputerScience/cs_COD_Spring_2021/Lab2/lab2/lab2.srcs/constrs_1/imports/Lab简介/Nexys4DDR_Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top data_sort -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef data_sort.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file data_sort_utilization_synth.rpt -pb data_sort_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
