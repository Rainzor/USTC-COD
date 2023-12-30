`timescale 1ns / 1ps
module testbench_sort();
reg  clk,rstn,del,addr,data,chk,run;


reg [15:0]  x;	//输入1位十六进制数字


wire [7:0]  an;	//数码管显示位置
wire [6:0]  seg;    //数码管显示存储器地址和数据
wire busy;//1-正在排序，0-排序结束
wire [15:0]  cnt;//排序耗费时钟周期数

data_sort sort(
  clk, 
  rstn, 

   x,	//输入1位十六进制数字
   del,		//删除1位十六进制数字
   addr,		//设置地址
   data,		//修改数据
   chk,		//查看下一项
   run,		//启动排序

 an,		//数码管显示位置
 seg,    //数码管显示存储器地址和数据
 busy,	//1-正在排序，0-排序结束
 cnt//排序耗费时钟周期数
    );
     parameter CLK='d1;  

initial begin
        clk=0;

        repeat(1000000000) #CLK clk=~clk;
        $finish;
end
initial begin
    rstn=0;
    #(CLK*2) rstn=1;
end
initial begin
    x=16'b0;
    del=0;
    chk=0;
    run=0;
    data=0;
    addr=0;
    #8
    chk=1;
    #8
    chk=0;
    #8
    chk=1;
    #8
    chk=0;
    #8
    chk=1;
    #8
    chk=0;
    x=16'b0000_0000_0000_0010;
    #8
    x=16'b1000_0000_0000_0010;
    #8
    data=1;
    #8
    data=0;
    #8
    del=1;
    #8
    del=0;
    #8
    x=16'b1001_0000_0000_0010;
    #8
    addr=1;
    #8
    addr=0;
    #8
    x=16'b1001_0000_0000_0000;
    #8
    run=1;
    #8
    run=0;
    
    end
    
endmodule