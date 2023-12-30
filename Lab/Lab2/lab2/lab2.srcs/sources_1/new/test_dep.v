`timescale 1ns / 1ps


module basic(
  input  clk, 
  input  rstn,
  input cpu_clk,
  input [15:0]  x,	//输入1位十六进制数字
  input del,		//删除1位十六进制数字
  input addr,		//设置地址
  input data,		//修改数据
  input chk,		//查看下一项
  input run,		//启动排序

  output [7:0]  an,		//数码管显示位置
  output [6:0]  seg,    //数码管显示存储器地址和数据
  output busy,	//1-正在排序，0-排序结束
  output [15:0]  cnt//排序耗费时钟周期数
    );
  reg[15:0] d,nextd;
  reg[7:0] a,nexta;
  reg count=0;
  wire p;     
  wire[3:0] h;
  assign busy=0;
  segment_trans ST(
  .clock(clk),
  .reset(rstn),
  .counter7(a[7:4]),
  .counter6(a[3:0]),
  .counter5(4'b0),
  .counter4(4'b0),
  .counter3(d[15:12]),
  .counter2(d[11:8]),
  .counter1(d[7:4]),
  .counter0(d[3:0]),
  .an(an),
  .segment_out(seg)
  ); 
  
  assign cnt = d; 
  reg[1:0] state,nextState;
   
  DEP dep(clk,x,h,p);
  always@(*)begin 
        if(!rstn) begin //当rst=0时，重置。
            nextState = 2'b00;
            nexta=8'b0;
            nextd=16'b0;
        end else begin
            case(state)
                2'b00:begin
                    nexta=a;
                    nextd=d;
                    if(p==1)
                        nextState=2'b01;
                    else
                        nextState=2'b00;    
                end
                2'b01:begin
                    nexta=a+7'b1;
                    nextd={d[11:0],h};
                    nextState=2'b00;
                end
             endcase
        end
  end
  always@(posedge clk)begin
         if(!rstn) begin //当rst=0时，重置。
            state<=0;
        end else begin
            case(state)
                2'b00:begin
                    d<=nextd;
                    a<=nexta;
                    state<=nextState;
                end
                2'b01:begin
                    d<=nextd;
                    a<=nexta;
                    state<=nextState;
                end
            endcase
        end
  end


    
endmodule
