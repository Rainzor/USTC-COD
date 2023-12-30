`timescale 1ns / 1ps
module testbench_sort();
reg  clk,rstn,del,addr,data,chk,run;


reg [15:0]  x;	//����1λʮ����������


wire [7:0]  an;	//�������ʾλ��
wire [6:0]  seg;    //�������ʾ�洢����ַ������
wire busy;//1-��������0-�������
wire [15:0]  cnt;//����ķ�ʱ��������

data_sort sort(
  clk, 
  rstn, 

   x,	//����1λʮ����������
   del,		//ɾ��1λʮ����������
   addr,		//���õ�ַ
   data,		//�޸�����
   chk,		//�鿴��һ��
   run,		//��������

 an,		//�������ʾλ��
 seg,    //�������ʾ�洢����ַ������
 busy,	//1-��������0-�������
 cnt//����ķ�ʱ��������
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