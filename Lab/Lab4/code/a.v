module alu #(
    parameter WIDTH=32
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [2:0] f,
    output reg [WIDTH-1:0] y,
    output [1:0]z
);

parameter A_ADD = 3'b000;
parameter A_SUB = 3'b001;
parameter A_AND = 3'b010;
parameter A_OR = 3'b011;
parameter A_XOR = 3'b100;
parameter A_SRL = 3'b101;
parameter A_SRA = 3'b111;
parameter A_SLL = 3'b110;

always@(*)
begin
    case (f)
        A_ADD:begin
            y = a + b;
        end
        A_SUB:begin
            y = a - b;
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
        A_SLL:begin
            y = a<<b;
        end
        A_SRL:y=a>>b;
        A_SRA:y=a>>>b;
        default: begin
            y = 0;
        end
    endcase
end

assign z=(y==32'd0)?(2'b01):((a<b)?2'b10:2'b00);
endmodule
