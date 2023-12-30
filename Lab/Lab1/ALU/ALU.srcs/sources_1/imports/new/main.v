`timescale 10ns / 1ns
module main #(
    parameter WIDTH =6
)(
    input [15:0] SW,
    input en,
    input clk,
    input rstn,
    output reg[WIDTH-1:0] LED,
    output reg[2:0] ledf
);
    
    reg[WIDTH-1:0] ain,bin;
    reg[2:0] sin;
    wire[WIDTH-1:0] LED1;
    wire[2:0] ledf1;
    always @(posedge clk)begin
            if (!rstn) begin
                ain<=6'b0;
                bin<=6'b0;
                sin<=3'b001;
                LED<=6'b0;
                ledf<=3'b0;
            end else if(en) begin
                sin<=SW[15:13];
                ain<=SW[11:6];
                bin<=SW[5:0];
                LED<=LED1;
                ledf<=ledf1; 
            end
                      
    end 
    
    alu#(6) alu(
   .a (ain),
   .b (bin),
   .s (sin),
   .y (LED1),
   .f (ledf1)
    ); 
    
    
endmodule

