`timescale 1ns / 1ps


module testDEP(

    );    
    reg[15:0] x;
    reg clk=0;
    wire[3:0] h;
    wire p;
        
    
    DEP dep(clk,x,h,p);
    initial begin
    x=16'b0;
    #40
    x=16'b0000_0000_0000_0010;
    #40
    x=16'b1000_0000_0000_0010;
    #40
    x=16'b1001_0000_0000_0010;
    #40
    x=16'b1001_0000_0000_0000;
    end
    initial begin
        repeat(100000) #1 clk=~clk;
        $finish;
    end
    
endmodule
