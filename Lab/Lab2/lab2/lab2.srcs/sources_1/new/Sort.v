`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/26 20:53:24
// Design Name: 
// Module Name: data_sort
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


module SORT(
  input  clk, 
  input  rstn,

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
   
  reg[2:0] state,nextState;
  reg[15:0] d,nextd,Din;
  reg[7:0] a,nexta,Ain;
  reg[7:0] tem_dpra;
  reg s;
  reg we;
  reg busy2=0;
  reg[1:0] lock=0;
  reg flag=0;
  
  wire chk_p;
  wire del_p;
  wire data_p;
  wire addr_p;
  wire p;
  wire[3:0] h;
  wire [15 : 0] spo;
  wire[15:0] dpo;
  wire[7:0] dpra;

  reg[15:0] ram[7:0];
  reg[7:0] count1=8'b0;
  reg[7:0] count2=8'b0;
  reg[7:0] count3=8'b0;
  reg[15:0] count=16'b0;
  reg[31:0] number=32'b0;
  wire[7:0] index1;
  wire[7:0] index2;
  wire[7:0] index3;
  
  parameter InitState=3'b000,
            InState=3'b001,
            DelState=3'b010,
            DataState=3'b011,
            AddrState=3'b100,
            ChkState=3'b101, 
            RunState=3'b110;


  assign busy=busy2; 
  assign dpra=tem_dpra; 
  assign index1 = count1; 
  assign index2 = count2;
  assign index3 = count3; 
  assign cnt = count; 

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
  
  DP dp(clk,chk,del,data,addr,run,chk_p,del_p,data_p,addr_p,run_p);
  
  DEP dep(clk,x,h,p);
  
  dist_mem_gen_1 dmem (
  .a(Ain),        // input wire [7 : 0] a
  .d(Din),        // input wire [15 : 0] d
  .dpra(dpra),  // input wire [7 : 0] dpra
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
   .spo(spo),  
  .dpo(dpo)    // output wire [15 : 0] dpo
);

  always@(*)begin 
        if(!rstn) begin //当rst=0时，重置。
            s=1;
            nextState = InitState;
            nexta=8'b0;
            nextd=16'b0;
        end else begin
            case(state)
                InitState:begin
                    if(busy2==0)begin
                        nextd=d;
                        nexta=a;
                        if(p==1)
                            nextState=InState;
                        else if(chk_p==1)begin
                            nextState=ChkState;
                        end else if(del_p==1)begin
                            nextState=DelState;
                        end else if(data_p==1)begin
                            nextState=DataState;
                        end else if(addr_p==1)begin
                            nextState=AddrState;
                        end else if(run_p==1)begin
                            nextState=RunState;
                        end
                        else   nextState=InitState;  
                    end  
                end
                InState:begin
                        nextd={d[11:0],h};
                        nexta=a;
                        s=1;
                        nextState=InitState;
                    end
                ChkState:begin
                        tem_dpra=a+1'b1;
                        nexta=a+1'b1;
                        s=0;
                        nextState=InitState;
                    end
                DelState:begin
                        tem_dpra=a;
                        nexta=a;
                        nextd={4'b0000,d[15:4]};
                        s=1;
                        nextState=InitState;
                    end
                DataState:begin
                        tem_dpra=a+1'b1;
                        nexta=a+1'b1;
                        s=0;
                        nextState=InitState;
                    end
                 AddrState:begin
                         nexta=d[7:0];
                         tem_dpra=d[7:0];
                        s=0;
                        nextState=InitState;
                    end
                  RunState:begin
                            s=0;
                            nexta=8'b0;
                            nextd=16'b0;
                            tem_dpra=8'b0;
                    end
             endcase
        end
  end
  always@(posedge clk )begin
        if(!rstn)begin
            busy2<=0;
            state<=InitState;
        end
       if(busy2==0)begin
            if(s==0)begin
                d<=dpo;
            end else begin
                d<=nextd;
            end
            a<=nexta;
            state<=nextState;
            case(state)
                InitState:begin
                     we<=0;   
                end
                InState:begin
                   
                end
                ChkState:begin
                    
                end
                DelState:begin
               
                end
                DataState:begin
                    Ain<=a;
                    Din<=d;
                    we<=1;
                end
                AddrState:begin
                   
                end
                RunState:begin
                     we<=0;
                     Ain<=0;
                     busy2<=1;
                     count<=0;
                     number<=0;
                     count1<=0;
                     count2<=0;
                     count3<=0;
                    
              end
            endcase         
           end else begin
                   if(number=='d1000_0000)
                   count<=count+1'b1;
                   else number<=number+1;
                    case(lock)
                        2'b00:begin
                             if(count1==8'b11111111)begin
                                ram[index1]<=dpo;
                                Ain<=0;
                                count1<=0;
                                lock<=2'b01;
                            end else begin
                                count1<=count1+1'b1;
                                Ain<=count1+1'b1;
                                ram[index1]<=spo;
                            end 
                        end
                        2'b01:begin
                             if(count2==8'b11111111)begin
                                count2<=0;
                                flag<=1;
                                if(flag==1)begin
                                    lock<=2'b10;
                                    we<=1;
                                end
                            end else begin
                                count2<=count2+1'b1;                        
                                if(ram[index2]<ram[index2+1])begin
                                    flag<=0;
                                    ram[index2] <= ram[index2+1];
                                    ram[index2+1] <= ram[index2];
                                end 
                             end
                        end
                        3'b10:begin
                             if(count3==8'b11111111)begin
                                    Ain<=0;
                                    count3<=0;
                                    Din<=ram[index3];
                                    lock<=2'b11;
                                    we<=0;
                                    busy2<=0;
                                    state<=InitState;
                             end else begin
                                    count3<=count3+1'b1;
                                    Ain<=count3+1'b1;
                                    Din<=ram[index3];
                             end
                        end
                        default:begin
                            busy2<=0;
                            state<=InitState;
                        end
                    endcase
                end   
  end
endmodule
