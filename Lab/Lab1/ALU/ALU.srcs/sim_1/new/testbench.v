`timescale 1ns / 1ps
module testbench;
    parameter WIDTH = 6 ;
    reg clk;
    reg[2:0] s;
    reg[WIDTH-1:0] a,b;
    wire[2:0] f;
    wire[WIDTH-1:0] y;
    always begin
        #10;clk=1;
        #10;clk=0;
    end
    initial begin
        a=6'b111100;
        b=6'b000010;
        s=3'b000;
        repeat(7) begin
            #30;
            s=s+1;
        end
        
   end
    main main(
    .SW ({s,1'b0,a,b}),
    .en (1'b1),
    .clk (clk),
    .rstn (1'b1),
    .LED (y),
    .ledf (f)
    );
    
   
    initial begin
        forever begin
            #10;
            if($time>500) $finish;
        end
    end
    
endmodule
