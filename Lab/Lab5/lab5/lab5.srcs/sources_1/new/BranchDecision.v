

module BranchDecision(
    input wire [31:0] reg1, reg2,
    input wire [2:0] br_type,
    output reg br
    );
localparam NOBRANCH = 3'd0;
localparam BEQ = 3'd1;
localparam BNE = 3'd2;
localparam BLT = 3'd3;
localparam BLTU = 3'd4;
localparam BGE = 3'd5;
localparam BGEU = 3'd6; 
    wire signed [31:0] reg1_sg, reg2_sg;
    assign reg1_sg = reg1;
    assign reg2_sg = reg2;
    always @ (*)
    begin
        case(br_type)
            NOBRANCH: br = 0;
            BEQ: br = (reg1 == reg2) ? 1 : 0;
            BLTU: br = (reg1 < reg2) ? 1 : 0;

            BGEU: br = (reg1 >= reg2) ? 1 : 0;
            BLT: br = (reg1_sg < reg2_sg) ? 1 : 0;
            BGE: br = (reg1_sg >= reg2_sg) ? 1 : 0;
            BNE: br = (reg1 != reg2) ? 1 : 0;
            default: br = 0;
        endcase
    end

endmodule