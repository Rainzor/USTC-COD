`timescale 10ns / 1ns
module fls#(
parameter WIDTH=16)(
    input clk,rst,en,
    input [WIDTH-1:0] d,
    output reg[WIDTH-1:0] f
    );
   reg lock=0;
   reg [31:0] cnt;
   reg[WIDTH-1:0] f0,f1,nextf;//��Զ��nextf����f
   wire[WIDTH-1:0] f2;
   reg[1:0] curState,nextState; //curState nextState����״̬��������
   
   alu  alu(.a(f0),.b(f1),.s(3'b001),.y(f2));
   
   //��ʼ��
   initial begin
        nextState <= 2'b00;
        curState<=2'b00;
        f1<=16'b0;
        f0<=16'b0;
        cnt <= 0;
        f<=0;
   end
   //���ڿ���ʱ��Ƶ��
  always @(posedge clk) begin
        if (cnt == 'd80000000) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
    end 
   //ÿ�������ֵ rst,en�����ı�ʱ����Ӧ�ò������Ӧ�ı仯
   //ֻ����nextState nextf
   always@(*)begin 
        if(!rst) begin //��rst=0ʱ�����á�
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
             nextf=f;   //˵����rst=0, en=0ʱ������f��ֵ���䣻
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
                        curState<=nextState;//curState�ı�Ϊ��һ״̬
                    end
                    2'b01:begin
                         f1<=nextf;
                         f<=nextf;
                         curState<=nextState;
                    end
                    default:begin
                        f0<=f1;//쳲�����������ֵ���� 
                        f1<=nextf;
                        f<=nextf; //��֤ÿ��f������ֵ��nextf������
                    end
                endcase
            end else f<=nextf;
            end
      end
    
endmodule
