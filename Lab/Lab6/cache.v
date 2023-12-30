`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/19 12:16:00
// Design Name: 
// Module Name: cache
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cache #(
    parameter group=4,
    parameter way=2,
    parameter width=32
)
(
    input clk,
    input [31:0] address,// cpu中 EXMEM_alu_out>>2地址，与访问 data memory完全相同
    input if_write,//是否为写操作
    input if_read,//是否为读操作
    output reg if_miss
    );
integer i,j;
reg [way-1:0] valid [group-1:0];//用于标记此组此位是否有效
                              //初始时均为无效（0），调入即为有效（1）
reg [31:0] addr_cache [group-1:0][way-1:0];//共8路，每路都有地址，进行比较
initial begin
    if_miss=0;
    for (i=0;i<4;i=i+1)
        valid[i]=0;
    for (i=0;i<4;i=i+1)
      for (j=0;j<2;j=j+1)
        addr_cache[i][j]=0;
end
wire memory_access;//判断当前操作是否为访存操作
wire [31:0] addr_high;//共有两路，一次调入两个
wire [31:0] addr_low;

assign addr_high=(address>(address^1))?address:(address^1);
assign addr_low=(address>(address^1))?(address^1):address;
//设想：
// 4 组；1 组 2 路；1 路 32 位
assign memory_access=if_write|if_read;

wire [group-1:0] which_group;//判断哪组
assign which_group=address[2:1];

wire which_way;//判断哪路
assign which_way=(address>(address^1))?1:0;//奇数地址在1路，偶数地址在0路

always @(posedge clk) begin
    if (memory_access==1)
    begin
        if (valid[which_group][which_way]==0)
        begin
            if_miss<=1;
        end
        else if (addr_cache[which_group][which_way]!=address)
        begin
            if_miss<=1;
        end
        else if_miss<=0;

        valid[which_group][which_way]<=1;
        valid[which_group][which_way^1]<=1;
        addr_cache[which_group][which_way]<=address;
        addr_cache[which_group][which_way^1]<=address^1;
    end
    else if_miss<=0;
end
endmodule
