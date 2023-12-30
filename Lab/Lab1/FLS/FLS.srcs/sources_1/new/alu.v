`timescale 1ns / 1ns
module alu #(
    parameter WIDTH=16
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [2:0] s,
    output reg [WIDTH-1:0] y
);

parameter A_SUB = 3'b000;
parameter A_ADD = 3'b001;
parameter A_AND = 3'b010;
parameter A_OR = 3'b011;
parameter A_XOR = 3'b100;
always@(*)
begin
    case (s)
        A_SUB:begin
            y = a - b;
        end
        A_ADD:begin
            y = a + b;
        end
        A_AND:begin
            y = a & b;
        end
        A_OR:begin
            y = a | b;
        end
        A_XOR:begin
            y = a ^ b;
        end
        default: begin
            y = 0;
        end
    endcase
end
endmodule
