module Hazard_unit (
            input rst,
            input branch_predict_miss, 
            input jalr_EX, 
            input jal_ID,
            input jal_EX,
            input [4: 0] rs1_ID, rs2_ID, 
            input [4: 0] rs1_EX, rs2_EX, 
            input [4: 0] rd_EX, rd_ME, rd_WB,
            input [1: 0] reg_read_EX,
            input mem_to_reg_EX,
            input [2: 0] reg_write_ME, reg_write_WB,
            output reg stall_IF, flush_IF,
            output reg stall_ID, flush_ID,
            output reg stall_EX, flush_EX,
            output reg stall_ME, flush_ME,
            output reg stall_WB, flush_WB,
            output reg [1: 0] forward1_EX, forward2_EX
);
localparam FORWARD_EX = 2'b10;
localparam FORWARD_ME = 2'b01;
localparam NOFORWARD = 2'b00;
//forwarding decision
always @(*) begin
    if( (reg_read_EX[1] == 1))begin
        if((reg_write_ME != 3'b0) && (rd_ME == rs1_EX) && (rd_ME != 5'b0) ) 
            forward1_EX = FORWARD_EX;//if the rs1 address' target value is 
                                    //alu_out_result in forwarding EX/MEM state     
        else if((reg_write_WB != 3'b0) && (rd_WB == rs1_EX) && (rd_WB != 5'b0))
            forward1_EX = FORWARD_ME; //if the rs1 address' target value is 
                                    //the value ready to write back in MEM/WB state        
        else forward1_EX = NOFORWARD;
    end else forward1_EX = NOFORWARD;        
end

always @(*) begin
    if( (reg_read_EX[0] == 1))begin
        if((reg_write_ME != 3'b0) && (rd_ME == rs2_EX) && (rd_ME != 5'b0) ) 
            forward2_EX = FORWARD_EX;//if the rs2 address' target value is 
                                    //alu_out_result in forwarding EX/MEM state     
        else if((reg_write_WB != 3'b0) && (rd_WB == rs2_EX) && (rd_WB != 5'b0))
            forward2_EX = FORWARD_ME; //if the rs2 address' target value is 
                                    //the value ready to write back in MEM/WB state        
        else forward2_EX = NOFORWARD;
    end else forward2_EX = NOFORWARD;
end

//stall and flush decision
always @ ( * ) begin
    if (rst)
        {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b0101010101;

    //At EX state, the pc is ready to jump, so the state before MEM need to flush and IF should renew PC
    else if (branch_predict_miss | jalr_EX)
        {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b0001010000;

    //For Load instruction, the behind state need a vaule, but the value is not loaded now! So the pipeline should stall.
    else if (mem_to_reg_EX & ((rd_EX == rs1_ID) || (rd_EX == rs2_ID)) )
        {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b1010010000;

    //At lD state, the pc is ready to jump    
    else if (jal_ID)
        {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b0001000000;
    // else if (jal_EX)
    //     {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b0001000000;
    else
        {stall_IF, flush_IF, stall_ID, flush_ID, stall_EX, flush_EX, stall_ME, flush_ME, stall_WB, flush_WB} <= 10'b0000000000;
end

endmodule