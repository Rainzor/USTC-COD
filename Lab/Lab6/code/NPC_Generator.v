module NPC_Generator(
    input wire [31:0] PC, jal_target, jalr_target, br_target,
    input wire jal, jalr, br,
    output reg [31:0] NPC
    );
    always@(*) begin
        if (br==1) begin
            NPC <= br_target;
        end
        else if (jalr==1) begin
            NPC <= jalr_target;
        end
        else if (jal==1) begin
            NPC <= jal_target;
        end
        else begin
            NPC <= PC;
        end
    end
endmodule