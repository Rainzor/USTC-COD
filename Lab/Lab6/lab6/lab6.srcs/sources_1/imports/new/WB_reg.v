module WB_reg(
           input clk,
           input en,
           input clear,
           input      [31: 0] IR_ME,
           output reg [31: 0] IR_WB, 
           input      [31: 0] addr,
           input      [31: 0] store_data,
           input      [3: 0] w_en,
           output wire [31: 0] load_data,
           output reg [1: 0] ld_bytes_select,
           input      [31: 0] result_ME,
           output reg [31: 0] result_WB,
           input      [4: 0] rd_ME,
           output reg [4: 0] rd_WB,
           input      [2: 0] reg_write_ME,
           output reg [2: 0] reg_write_WB,
           input      mem_to_reg_ME,
           output reg mem_to_reg_WB,
           input [31: 0] dpra,
           output[31: 0] dpo
       );
reg stall_ff;//store the last stall_WE value
reg clear_ff;
reg [31: 0] load_data_old;
wire [31: 0] load_data_new;
initial
begin
    IR_WB = 32'b0;
    ld_bytes_select = 2'b00;
    reg_write_WB = 3'b000;
    mem_to_reg_WB = 1'b0;
    result_WB = 0;
    rd_WB = 5'b0;
    stall_ff = 1'b0;
    clear_ff = 1'b0;
    load_data_old = 32'b0;
end
always@(posedge clk) begin
    if (en) begin
        IR_WB <= clear ? 32'b0 : IR_ME;
        //At DataMem, the data is stored by bytes, 
        //so for word (4 bytes) the last 2 bit of address must be 00, 
        //and for half word , the last bit of address must be 0
        ld_bytes_select <= clear ? 2'b00 :addr [1 : 0];
        reg_write_WB <= clear ? 3'b000 : reg_write_ME;
        mem_to_reg_WB <= clear ? 1'b0 : mem_to_reg_ME;
        result_WB <= clear ? 0 : result_ME;
        rd_WB <= clear ? 5'b0 : rd_ME;
    end
end

always @ (posedge clk)
begin
    stall_ff <= ~en;
    clear_ff <= clear;
    load_data_old <= load_data_new;
end

DataMem DataMem (
            .clk (clk),
            .we (w_en << addr[1: 0]),//if write w_en=1 and discriminate the type of data
            .addr (addr[9: 2]),//only useful for data of word 
            .din (store_data << (8 * addr[1: 0])),//move the byte to fill in 32'bit wide 
            .douta (load_data_new),
            .dpra (dpra[9: 2]),
            .dpo (dpo)
        );

//if stall or clear the data 
assign load_data = stall_ff ? load_data_old : (clear_ff ? 32'b0 : load_data_new );




endmodule