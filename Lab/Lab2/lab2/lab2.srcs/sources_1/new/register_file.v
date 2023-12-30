`timescale 1ns / 1ps
module  register_file  #(
    parameter AW = 5,		//��ַ���
    parameter DW = 32		//���ݿ��
)(
    input  clk,			//ʱ��
    input [AW-1:0]  ra0, ra1,	//����ַ
    output wire[DW-1:0]  rd0, rd1,	//������
    input [AW-1:0]  wa,		//д��ַ
    input [DW-1:0]  wd,		//д����
    input we			//дʹ��
);
reg [DW-1:0]  rf [0: 31]; 	//�Ĵ�����
reg [AW-1:0] ad0,ad1;
reg [DW-1:0] d0,d1;

assign rd0 = (ra0==5'b0)? (32'b0):d0;
assign rd1 = (ra1==5'b0)? (32'b0):d1;	//������

always  @(posedge  clk)
    if (we)begin
       if(wa!=5'b0)begin
            d0<= ((ra0==wa)? wd:rf[ra0]);
            d1<= ((ra1==wa)? wd:rf[ra1]);   
            rf[wa]  <=  wd;		//д����
        end else begin
            d0<=rf[ra0];
            d1<=rf[ra1];
        end
    end else begin
        d0<=rf[ra0];
        d1<=rf[ra1];
    end
    

endmodule

