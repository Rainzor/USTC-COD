module WB_reg1(
            input clk,
            input en,
            input clear,
            input      [31: 0] IR_ME,
            output reg [31: 0] IR_WB, 
            input      [31: 0] load_data_ME,
            output reg[31: 0]load_data_WB,
            input      [31: 0] result_ME,
            output reg [31: 0] result_WB,
            input      [4: 0] rd_ME,
            output reg [4: 0] rd_WB,
            input      [2: 0] reg_write_ME,
            output reg [2: 0] reg_write_WB,
            input      mem_to_reg_ME,
            output reg mem_to_reg_WB

       );
initial
begin
    IR_WB = 32'b0;
    load_data_WB=32'b0;
    result_WB = 0;
    rd_WB = 5'b0;
    reg_write_WB = 3'b000;
    mem_to_reg_WB = 1'b0;
end
always@(posedge clk) begin
    if (en) begin
        IR_WB <= clear ? 32'b0 : IR_ME;
        reg_write_WB <= clear ? 3'b000 : reg_write_ME;
        mem_to_reg_WB <= clear ? 1'b0 : mem_to_reg_ME;
        result_WB <= clear ? 0 : result_ME;
        rd_WB <= clear ? 5'b0 : rd_ME;
        load_data_WB<=clear? 5'b0 : load_data_ME;
    end
end





endmodule