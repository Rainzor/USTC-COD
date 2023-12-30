`timescale 1ns / 1ps


module DEP
    (
    input clk,
    input [15:0] x,

    output [3:0] h,
    output  p
    );
    reg[15:0] temp_h=16'b0;
    reg[15:0] curx=16'b0;
    reg[3:0] curh=4'b0;

    reg[31:0] count=32'b0;
    wire flag;
    reg real_flag=0,temp=0;
    assign h=curh,p=temp;
    assign flag = (curx!=x)? 1'b1 : 1'b0;
    always@(posedge clk )begin
        if(flag==1)begin
            count <= count + 1'b1;
        end else begin
            count <= 32'b0;
            temp <= 0;
            curh<=curh;
        end
        if(count=='d10000000)begin
            real_flag <= 1'b1;
            temp_h <= (curx ^ x);
            curx <= x;
        end
        if(real_flag==1)begin
           case(temp_h)
                16'b0000_0000_0000_0001:curh<=4'h0;
                16'b0000_0000_0000_0010:curh<=4'h1;
                16'b0000_0000_0000_0100:curh<=4'h2;
                16'b0000_0000_0000_1000:curh<=4'h3;
                16'b0000_0000_0001_0000:curh<=4'h4;
                16'b0000_0000_0010_0000:curh<=4'h5;
                16'b0000_0000_0100_0000:curh<=4'h6;
                16'b0000_0000_1000_0000:curh<=4'h7;
                16'b0000_0001_0000_0000:curh<=4'h8;
                16'b0000_0010_0000_0000:curh<=4'h9;
                16'b0000_0100_0000_0000:curh<=4'ha;
                16'b0000_1000_0000_0000:curh<=4'hb;
                16'b0001_0000_0000_0000:curh<=4'hc;
                16'b0010_0000_0000_0000:curh<=4'hd;
                16'b0100_0000_0000_0000:curh<=4'he;
                16'b1000_0000_0000_0000:curh<=4'hf;
           endcase
           real_flag<=0;
           temp<=1;
        end
    end
    
    
endmodule
