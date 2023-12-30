`timescale 10ns / 1ns
module testbench(

    );
    reg clk,rst,en;
    reg [15:0]d;
    wire [15:0]f;
    fls fls(.clk(clk),.rst(rst),.en(en),.d(d),.f(f));
    initial begin
    clk=0;
    repeat(100)begin
        #2 clk=~clk;
        end
    end
    
    initial begin
    rst=0;
    #3 rst=1;
    end
    
    initial begin
        d = 16'D2;
        #13 d=16'D3;
        #8  d=d+16'D1;
        
    end
    
    initial begin
        en=1;
        #5 en=0;
        #4 en=1;
        #8 en=0;
         repeat(100)begin
            #4 en=~en;
         end
    end
endmodule
