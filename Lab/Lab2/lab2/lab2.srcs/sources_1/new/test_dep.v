`timescale 1ns / 1ps


module basic(
  input  clk, 
  input  rstn,
  input cpu_clk,
  input [15:0]  x,	//����1λʮ����������
  input del,		//ɾ��1λʮ����������
  input addr,		//���õ�ַ
  input data,		//�޸�����
  input chk,		//�鿴��һ��
  input run,		//��������

  output [7:0]  an,		//�������ʾλ��
  output [6:0]  seg,    //�������ʾ�洢����ַ������
  output busy,	//1-��������0-�������
  output [15:0]  cnt//����ķ�ʱ��������
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
        if(!rstn) begin //��rst=0ʱ�����á�
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
         if(!rstn) begin //��rst=0ʱ�����á�
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
