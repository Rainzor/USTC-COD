module cpu_s(
                input clk, 
                input rst,

                //IO_BUS
                output [7:0]  io_addr,	//ouput address Peripheral Devices 
                output [31:0]  io_dout,	//write data to PD
                output  io_we,		//PD we
                output  io_rd,		//pd re
                input [31:0]  io_din,	//PD write

                //Debug_BUS
                output [31:0] chk_pc, 	//pc_ID
                input [15:0] chk_addr,	
                output reg [31:0] chk_data    

    );
//instruction: 
localparam RTYPE = 3'd0;//ADD SUB AND OR XOR SLL SRL
localparam ITYPE = 3'd1;//ADDI XORI SLLI SRLI ORI ANDI LW
localparam STYPE = 3'd2;//SW
localparam BTYPE = 3'd3;//BEQ BNE BLT BEQ BLTU BGEU
localparam UTYPE = 3'd4;//LUI AUIPC
localparam JTYPE = 3'd5;//JAL JALR

localparam NOBRANCH = 3'd0;
localparam BEQ = 3'd1;
localparam BNE = 3'd2;
localparam BLT = 3'd3;
localparam BLTU = 3'd4;
localparam BGE = 3'd5;
localparam BGEU = 3'd6; 

localparam ADD = 4'd0;
localparam SUB = 4'd1;
localparam AND = 4'd2;
localparam OR = 4'd3;
localparam XOR = 4'd4;
localparam SLL = 4'd5;
localparam SRL = 4'd6;
localparam LUI = 4'd7; 

localparam NOREGWRITE = 3'b0;	
localparam LB  = 3'd1;			
localparam LH  = 3'd2;		
localparam LW  = 3'd3;	
localparam LBU = 3'd4;			
localparam LHU = 3'd5;            


//debug
wire[31: 0 ] r_data, m_data;

//instruction 
wire[31: 0] instruction, IR_IF, IR_ID, IR_EX, IR_ME, IR_WB;
wire[6: 0] fn7_ID, op_ID;
wire[2: 0] fn3_ID;

//JUMP and BRANCH conctrol
wire jal_ID, jalr_ID, jalr_EX;//JAL and JALR signal
wire ld_nextpc_ID, ld_nextpc_EX, ld_nextpc_ME;//the signal (depended on J-Type) decides whether the WB_result is pc+4 or ALUout
wire[2: 0] branch_type_ID,branch_type_EX;//branch type: BEQ, BNE, BLT...
wire branch_EX;
wire branch_predict_update;
wire branch_predict_miss;
reg[31:0] total_branch_count, miss_branch_predict_count ;


//Register Files
wire [2: 0] reg_write_en_ID, reg_write_en_EX, reg_write_en_ME, reg_write_en_WB;//regfile Write Enable
wire [2: 0] load_type_ID, load_type_EX, load_tpye_ME;
wire[1: 0] reg_read_ID, reg_read_EX;//Read Enable
wire[4: 0] rs1_ID, rs2_ID, rd_ID;
wire[4: 0] rs1_EX, rs2_EX, rd_EX;
wire[4: 0] rd_ME, rd_WB;
wire[31: 0] reg_out1_ID, reg_out2_ID;
wire[31: 0] reg_out1_EX, reg_out2_EX;
wire[31: 0] result_ME ,result_WB, reg_write_data;//the result data written back in register files


//Program Counter
wire[31: 0] pc_IF, pc_ID, pc_EX, pc_ME;
wire[31: 0] branch_nextpc, jal_nextpc;
wire[31: 0] NPC,NPC_pred;



//immediate number
wire[2: 0] imm_type;
reg[31: 0] imm_ID;
wire[31: 0] imm_EX;

//ALU
wire  alu_src1_ID, alu_src1_EX;
wire[1:0] alu_src2_ID, alu_src2_EX;
wire[3: 0] alu_f_ID, alu_f_EX;
wire[31: 0] alu_a, alu_b;
wire[31: 0] alu_out_EX, alu_out_ME;

//Hazard:
wire[1:0] forward1_EX, forward2_EX;//Forwarding signal:00,01,10
wire[31: 0] forward_data1, forward_data2, mux_data;//Forwarding data
wire stall_IF, stall_ID, stall_EX, stall_ME, stall_WB;//Stall
wire flush_IF, flush_ID, flush_EX, flush_ME, flush_WB;//Flush

//DATA MEMORY
wire  mem_to_reg_ID, mem_to_reg_EX,mem_to_reg_ME, mem_to_reg_WB;//LOAD signal
wire[3: 0] mem_write_ID, mem_write_EX, mem_write_ME;//STORE signal
wire[31: 0] store_data_ME, data_addr_ME;//The data for memory store
wire[31: 0] datamem_read_data, datamem_read_data_ext;//date read in dataMemory 





/*IO*/
assign io_addr = data_addr_ME[7:0];
assign io_we = (data_addr_ME[15: 8] == 8'hff) & (mem_write_ME ==3'd3);//cpu store(write) data to outside device
assign io_rd = (data_addr_ME[15: 8] == 8'hff) & mem_to_reg_WB;//cpu load(read) data from outside device
assign io_dout = store_data_ME;


/*debug*/

assign chk_pc = pc_ID;

always@(*)begin
    case(chk_addr[13:12])
      2'b00:begin
        case(chk_addr[4:0])
            5'h0: chk_data = NPC;
            5'h1: chk_data = pc_IF;
            5'h2: chk_data = pc_ID;
            5'h3: chk_data = IR_ID;    
            5'h4: chk_data = {jal_ID, jalr_ID, 
                              reg_read_ID, alu_f_ID,
                              alu_src1_ID, alu_src2_ID, branch_type_ID,
                              mem_to_reg_ID, mem_write_ID, 
                              reg_write_en_ID, ld_nextpc_ID};
            5'h5: chk_data = pc_EX;
            5'h6: chk_data = alu_a;
            5'h7: chk_data = alu_b;
            5'h8: chk_data = imm_ID;
            5'h9: chk_data = IR_EX;
            5'hA: chk_data = {
                              mem_to_reg_ME, mem_write_ME, 
                              reg_write_en_ME,ld_nextpc_ME};
            5'hB: chk_data = alu_out_EX;
            5'hC: chk_data = store_data_ME;
            5'hD: chk_data = IR_ME;
            5'hE: chk_data = {mem_write_ME, reg_write_en_WB,mem_to_reg_WB};
            5'hF: chk_data = datamem_read_data;
            5'h10: chk_data = reg_write_data;
            5'h11: chk_data = IR_WB;
        endcase
      end
      
      2'b01:begin
        chk_data = r_data;  
      end
      2'b10:begin
        chk_data = m_data;
      end
    endcase
end



/*CPU*/

// At every state, harzard situation can occur depending on the some special signal
// Combine Forwarding and Harzard unit
Hazard_unit Hazard_unit(
                //input
                .rst(rst),
                .branch_predict_miss(branch_predict_miss),
                .jalr_EX(jalr_EX),
                .jal_ID(jal_ID),
                .rs1_ID(rs1_ID),
                .rs2_ID(rs2_ID),
                .rs1_EX(rs1_EX),
                .rs2_EX(rs2_EX),
                .reg_read_EX(reg_read_EX),
                .mem_to_reg_EX(mem_to_reg_EX),
                .rd_EX(rd_EX),
                .rd_ME(rd_ME),
                .reg_write_ME(reg_write_en_ME),
                .rd_WB(rd_WB),
                .reg_write_WB(reg_write_en_WB),
                //output
                .stall_IF(stall_IF),
                .flush_IF(flush_IF),
                .stall_ID(stall_ID),
                .flush_ID(flush_ID),
                .stall_EX(stall_EX),
                .flush_EX(flush_EX),
                .stall_ME(stall_ME),
                .flush_ME(flush_ME),
                .stall_WB(stall_WB),
                .flush_WB(flush_WB),
                .forward1_EX(forward1_EX),
                .forward2_EX(forward2_EX)
            );



//IF and IFreg:renew PC and get instruction

IF_reg IF_reg(//IF
                .clk(clk),
                .en(~stall_IF),
                .clear(flush_IF),
                .pc_in(NPC),
                .pc_IF(pc_IF)//get the next pc depend on en and clear
            );  

//NPC_Generator NPC_Generator(
//        .PC(pc_IF+4),
//        .jal_target(jal_nextpc),
//        .jalr_target(alu_out_EX),
//        .br_target(branch_nextpc),
//        .jal(jal_ID),
//        .jalr(jalr_EX),
//        .br(branch_EX),
//        .NPC(NPC)
//    );
//assign branch_predict_miss = branch_EX;
//always @ (negedge clk or posedge rst) begin
//        if (rst) begin
//            total_branch_count <= 32'b0;
//            miss_branch_predict_count <= 32'b0;
//        end else begin
//            if (branch_type_EX!= 0) begin
//                total_branch_count <= total_branch_count + 1;
//            end
//            if (branch_EX) begin
//                miss_branch_predict_count <= miss_branch_predict_count + 1;
//            end
//        end
//end

 NPC_Generator NPC_Generator(
         .PC(NPC_pred),
         .jal_target(jal_nextpc),
         .jalr_target(alu_out_EX),
         .br_target(branch_nextpc),
         .jal(jal_ID),
         .jalr(jalr_EX),
         .br(branch_EX),
         .NPC(NPC)
     );

 assign branch_predict_update = (branch_type_EX == NOBRANCH) ? 1'b0 : 1'b1;

 always @ (negedge clk or posedge rst) begin
         if (rst) begin
             total_branch_count <= 32'b0;
             miss_branch_predict_count <= 32'b0;
         end else begin
             if (branch_type_EX!= 0) begin
                 total_branch_count <= total_branch_count + 1;
             end
             if (branch_predict_miss) begin
                 miss_branch_predict_count <= miss_branch_predict_count + 1;
             end
         end
 end

// BranchPredict_btb BranchPredict1(
//         .clk(clk),
//         .rst(rst),
//         .PC_rd_IF(pc_IF),
//         .PC_wr_EX(pc_EX),
//         .PC_br_target(branch_nextpc),
//         .br(branch_EX),
//         .write(branch_predict_update),
//         .br_predict_miss(branch_predict_miss),
//         .NPC(NPC_pred)
//     );
 BranchPredict BranchPredict(
         .clk(clk),
         .rst(rst),
         .PC_rd_IF(pc_IF),
         .PC_wr_EX(pc_EX),
         .PC_br_target(branch_nextpc),
         .br(branch_EX),
         .write(branch_predict_update),
         .br_predict_miss(branch_predict_miss),
         .NPC(NPC_pred)
     );

Instr_Mem_select InstrMem(//get instr
                    .a    (pc_IF[9: 2]),                      
                    .spo  (IR_IF)
                );



//ID and IF/ID reg: Analysis instruction create control sign and generate imm 
ID_reg ID_reg(
                .clk(clk),
                .clear(flush_ID),
                .en(~stall_ID),
                .pc_IF(pc_IF),
                .pc_ID(pc_ID),
                .instr_IF(IR_IF),
                .instr_ID(IR_ID)
            );
assign instruction=IR_ID;
assign {fn7_ID, rs2_ID, rs1_ID, fn3_ID, rd_ID, op_ID} = instruction;//Decode

assign jal_nextpc = imm_ID + pc_ID;

reg_file register_file( //read register file and may write later
                        //the clk is only relate to write date
                .clk(clk),
                .rst(rst),
                .we( |reg_write_en_WB ),
                .ra1(rs1_ID),
                .ra2(rs2_ID),
                .ra3(chk_addr[4: 0]),
                .wa(rd_WB),
                .wd(reg_write_data),
                .rf_data1(reg_out1_ID),
                .rf_data2(reg_out2_ID),
                .rf_data3(r_data)
             );
control control(//create control signal
                //input
                .instr(instruction),
                //output
                .jal_ID(jal_ID),
                .jalr_ID(jalr_ID),
                .reg_write_ID(reg_write_en_ID),
                .mem_to_reg_ID(mem_to_reg_ID),
                .mem_write_ID(mem_write_ID),
                .ld_nextpc_ID(ld_nextpc_ID),
                .reg_read_ID(reg_read_ID),
                .branch_type_ID(branch_type_ID),
                .alu_control_ID(alu_f_ID), 
                .alu_src1_ID(alu_src1_ID),
                .alu_src2_ID(alu_src2_ID),
                .imm_type(imm_type)
            );
always @(*) begin//gen imm   
    case (imm_type)
        ITYPE:
            imm_ID = {{21{instruction[31]}}, instruction[30: 20] };
        STYPE:
            imm_ID = {{21{instruction[31]}}, instruction[30: 25], instruction[11: 7]};
        BTYPE:
            imm_ID = {{20{instruction[31]}}, instruction[7], instruction[30: 25], instruction[11: 8], 1'b0};
        UTYPE:
            imm_ID = {instruction[31: 12], 12'b0};
        JTYPE:
            imm_ID = {{12{instruction[31]}}, instruction[19: 12], instruction[20], instruction[30: 21], 1'b0};                                  
        default:
            imm_ID = 0;
    endcase
end


//EX and ID/EX reg: Calculate or Compare the numbers and Make Branch Decision

EX_reg EX_reg( // the ID registers' value delivered to EX
                .clk(clk),
                .en(~stall_EX),
                .clear(flush_EX),
                .IR_ID(IR_ID),
                .IR_EX(IR_EX),
                .pc_ID(pc_ID),//in
                .pc_EX(pc_EX),//out
                .jal_nextpc(jal_nextpc),//in
                .branch_nextpc(branch_nextpc),//out At Execute State the Branch result is equal to Jal
                .imm_ID(imm_ID),//in
                .imm_EX(imm_EX),//out
                .rd_ID(rd_ID),//in
                .rd_EX(rd_EX),//out
                .rs1_ID(rs1_ID),//in
                .rs1_EX(rs1_EX),//out
                .rs2_ID(rs2_ID),//in
                .rs2_EX(rs2_EX),//out
                .reg_out1_ID(reg_out1_ID),//in
                .reg_out1_EX(reg_out1_EX),//out
                .reg_out2_ID(reg_out2_ID),//in
                .reg_out2_EX(reg_out2_EX),//out
                .jal_ID(jal_ID),
                .jalr_ID(jalr_ID),//in
                .jalr_EX(jalr_EX),//out
                .reg_write_ID(reg_write_en_ID),//in
                .reg_write_EX(reg_write_en_EX),//out
                .mem_to_reg_ID(mem_to_reg_ID),//in
                .mem_to_reg_EX(mem_to_reg_EX),//out
                .mem_write_ID(mem_write_ID),//in
                .mem_write_EX(mem_write_EX),//out
                .ld_nextpc_ID(ld_nextpc_ID),//in
                .ld_nextpc_EX(ld_nextpc_EX),//out
                .reg_read_ID(reg_read_ID),//in
                .reg_read_EX(reg_read_EX),//out
                .branch_type_ID(branch_type_ID),//in
                .branch_type_EX(branch_type_EX),//out
                .alu_f_ID(alu_f_ID),//in
                .alu_f_EX(alu_f_EX),//out
                .alu_src1_ID(alu_src1_ID),//in
                .alu_src1_EX(alu_src1_EX),//out
                .alu_src2_ID(alu_src2_ID),//in
                .alu_src2_EX(alu_src2_EX)//out
         );

BranchDecision BranchDecision1(
        .reg1(alu_a),
        .reg2(alu_b),
        .br_type(branch_type_EX),
        .br(branch_EX)
    );

//Alu and Forward
assign forward_data1 = forward1_EX[1] ? (alu_out_ME) : ( forward1_EX[0] ? reg_write_data : reg_out1_EX );
assign forward_data2 = forward2_EX[1] ? alu_out_ME : ( forward2_EX[0] ? reg_write_data : reg_out2_EX );
assign mux_data = (alu_out_EX[15: 8]==8'hff) ? io_din : forward_data2;
assign alu_a = alu_src1_EX ? pc_EX : forward_data1;
assign alu_b = alu_src2_EX[1] ? (imm_EX) : ( alu_src2_EX[0] ? rs2_EX : forward_data2 );



alu alu(//ALU
        .a(alu_a),
        .b(alu_b),
        .f(alu_f_EX),
        .y(alu_out_EX)
    );


//MEM and EX/MEM_reg: decide one of ALUresults (not include load process)
ME_reg ME_reg(
                .clk(clk),
                .en(~stall_ME),
                .clear(flush_ME),
                .IR_EX(IR_EX),
                .IR_ME(IR_ME),
                .alu_out_EX(alu_out_EX),//in
                .alu_out_ME(alu_out_ME),//out
                .forward_data2(forward_data2),//in forward_data2
                .store_data_ME(store_data_ME),///out
                .rd_EX(rd_EX),//in
                .rd_ME(rd_ME),//out
                .pc_EX(pc_EX),//in
                .pc_ME(pc_ME),//out
                .reg_write_EX(reg_write_en_EX),//in
                .reg_write_ME(reg_write_en_ME),//out
                .mem_to_reg_EX(mem_to_reg_EX),//in
                .mem_to_reg_ME(mem_to_reg_ME),//out
                .mem_write_EX(mem_write_EX),//in
                .mem_write_ME(mem_write_ME),//out
                .ld_nextpc_EX(ld_nextpc_EX),//in
                .ld_nextpc_ME(ld_nextpc_ME)//out
          );

assign result_ME = ld_nextpc_ME ? (pc_ME + 4) : alu_out_ME;//for J-TYPE
assign data_addr_ME = alu_out_ME;

//WB and MEM/WB_reg: load or store data decide the date written into Register Files
WB_reg WB_reg(
                .clk(clk),
                .en(~stall_WB),
                .clear(flush_WB),
                .IR_ME(IR_ME),
                .IR_WB(IR_WB),
                .addr(data_addr_ME),
                .io_din(io_din),
                .store_data(store_data_ME),
                .dpra({22'b0,chk_addr[7:0],2'b0}),
                .dpo(m_data),
                .mem_write_en(mem_write_ME),
                .load_data_ext(datamem_read_data),
                .result_ME(result_ME),
                .result_WB(result_WB),
                .rd_ME(rd_ME),
                .rd_WB(rd_WB),
                .reg_write_ME(reg_write_en_ME),
                .reg_write_WB(reg_write_en_WB),
                .mem_to_reg_ME(mem_to_reg_ME),
                .mem_to_reg_WB(mem_to_reg_WB)
         );

assign reg_write_data = ~mem_to_reg_WB ? result_WB : datamem_read_data;



endmodule