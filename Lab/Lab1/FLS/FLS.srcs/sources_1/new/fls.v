`timescale 10ns / 1ns
module fls#(
parameter WIDTH=16)(
    input clk,rst,en,
    input [WIDTH-1:0] d,
    output reg[WIDTH-1:0] f
    );
   reg lock=0;
   reg [31:0] cnt;
   reg[WIDTH-1:0] f0,f1,nextf;//永远把nextf赋给f
   wire[WIDTH-1:0] f2;
   reg[1:0] curState,nextState; //curState nextState起到了状态机的作用
   
   alu  alu(.a(f0),.b(f1),.s(3'b001),.y(f2));
   
   //初始化
   initial begin
        nextState <= 2'b00;
        curState<=2'b00;
        f1<=16'b0;
        f0<=16'b0;
        cnt <= 0;
        f<=0;
   end
   //用于控制时间频率
  always @(posedge clk) begin
        if (cnt == 'd80000000) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end 
   //每当输入的值 rst,en有所改变时，就应该产生相对应的变化
   //只更新nextState nextf
   always@(*)begin 
        if(!rst) begin //当rst=0时，重置。
            nextState = 2'b00;
            nextf=16'b0;
            lock=1'b0;
        end else if(en)begin
             case(curState)
                2'b00:begin
                    if(lock)begin
                        nextf=d;
                        nextState=2'b01;
                        lock=0;
                    end
                end
                2'b01:begin
                    if(lock)begin
                        nextf=d;
                        nextState=2'b10;
                        lock=0;
                    end
                end
                2'b10: begin
                    nextf=f2;
                    nextState=2'b11; 
                end
             endcase
         end else begin
             lock=1;
             nextf=f;   //说明当rst=0, en=0时，保持f的值不变；
         end
    end

    always @(posedge clk)begin
    if (cnt == 16'b0) begin
            if(!rst) begin
                curState<=2'b00;
                f0<=16'b0;
                f1<=16'b0;
                f<=16'b0;
            end else if(en)begin
                case(curState)
                    2'b00:begin
                        f0<=nextf;
                        f<=nextf;
                        curState<=nextState;//curState改变为下一状态
                    end
                    2'b01:begin
                         f1<=nextf;
                         f<=nextf;
                         curState<=nextState;
                    end
                    default:begin
                        f0<=f1;//斐波那契数列数值传递 
                        f1<=nextf;
                        f<=nextf; //保证每次f的最终值由nextf决定。
                    end
                endcase
            end else f<=nextf;
            end
      end
    
endmodule
