`timescale 1ns / 1ps

module ID_reg(
           input clk,
           input clear,
           input en,
           input [31: 0] instr_IF,
           output reg [31: 0] instr_ID,
           input [31: 0] pc_IF,
           output reg [31: 0] pc_ID
       );

reg [31: 0] instr_old;

wire stall_ff;
wire clear_ff;
assign stall_ff = ~en;
assign clear_ff = clear;

initial begin 
    pc_ID = 0;
    instr_old = 32'b0;
end

always@(posedge clk) begin
    if (en)
        pc_ID <= clear ? 0 : pc_IF;
end

always @ (posedge clk)
begin
    instr_old <= instr_IF;
    instr_ID <= stall_ff ? instr_old : (clear_ff ? 32'b0 : instr_IF );

end

endmodule
