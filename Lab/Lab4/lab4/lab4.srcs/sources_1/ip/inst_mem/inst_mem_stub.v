// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed Apr 20 21:00:12 2022
// Host        : Sky running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/ComputerScience/cs_COD_Spring_2022/Lab4/lab4/lab4.srcs/sources_1/ip/inst_mem/inst_mem_stub.v
// Design      : inst_mem
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2019.2" *)
module inst_mem(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],spo[31:0]" */;
  input [7:0]a;
  output [31:0]spo;
endmodule
