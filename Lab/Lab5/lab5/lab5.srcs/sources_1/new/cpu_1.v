module cpu_1(
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
wire jal_ID,jal_EX, jalr_ID, jalr_EX;//JAL and JALR signal
wire ld_nextpc_ID, ld_nextpc_EX, ld_nextpc_ME;//the signal (depended on J-Type) decides whether the WB_result is pc+4 or ALUout
wire[2: 0] branch_type_ID,branch_type_EX;//branch type: BEQ, BNE, BLT...
reg branch_EX;

//Register Files
wire [2: 0] reg_write_ID, reg_write_EX, reg_write_ME, reg_write_WB;//Write Enable
wire[1: 0] reg_read_ID, reg_read_EX;//Read Enable
wire[4: 0] rs1_ID, rs2_ID, rd_ID;
wire[4: 0] rs1_EX, rs2_EX, rd_EX;
wire[4: 0] rd_ME, rd_WB;
wire[31: 0] reg_out1_ID, reg_out2_ID;
wire[31: 0] reg_out1_EX, reg_out2_EX;
wire[31: 0] result_ME ,result_WB, reg_write_data;//the result data written back in register files


//Program Counter
wire[31: 0] pc_in, pc_IF, pc_ID, pc_EX, pc_ME;
wire[31: 0] branch_nextpc, jal_nextpc;
reg[31: 0] next_pc;

//immediate number
wire[2: 0] imm_type;
reg[31: 0] imm_ID;
wire[31: 0] imm_EX;

//ALU
wire  alu_src1_ID, alu_src1_EX;
wire[1:0] alu_src2_ID, alu_src2_EX;
wire[3: 0] alu_f_ID, alu_f_EX;
wire[31: 0] alu_a, alu_b, alu_a_signed, alu_b_signed;
wire[31: 0] alu_out_EX, alu_out_ME;

//Harzard:
wire[1:0] forward1_EX, forward2_EX;//Forwarding signal:00,01,10
wire[31: 0] forward_data1, forward_data2, mux_data;//Forwarding data
wire stall_IF, stall_ID, stall_EX, stall_ME, stall_WB;//Stall
wire flush_IF, flush_ID, flush_EX, flush_ME, flush_WB;//Flush

//DATA MEMORY
wire  mem_to_reg_ID, mem_to_reg_EX,mem_to_reg_ME, mem_to_reg_WB;//LOAD signal
wire[3: 0] mem_write_ID, mem_write_EX, mem_write_ME;//STORE signal
wire[31: 0] store_data_ME;//The data for memory store
wire[31: 0] load_data_ME, load_data_WB;//date read in dataMemory 
wire[1: 0] ld_bytes_select;// the last 2 bit of data memory address
reg[31: 0] load_data_old;
wire[31: 0]load_data_new;



/*IO*/
assign io_addr = alu_out_ME[7:0];
assign io_we = (alu_out_ME[15: 8] == 8'hff) & (mem_write_ME ==3'd3);
assign io_rd = (alu_out_ME[15: 8] == 8'hff) & mem_to_reg_WB;
assign io_dout = store_data_ME;


/*debug*/

assign chk_pc = pc_ID;

always@(*)begin
    case(chk_addr[13:12])
      2'b00:begin
        case(chk_addr[4:0])
            5'h0: chk_data = pc_in;
            5'h1: chk_data = pc_IF;
            5'h2: chk_data = pc_ID;
            5'h3: chk_data = IR_ID;    
            5'h4: chk_data = {jal_ID, jalr_ID, 
                              reg_read_ID, alu_f_ID,
                              alu_src1_ID, alu_src2_ID, branch_type_ID,
                              mem_to_reg_ID, mem_write_ID, 
                              reg_write_ID, ld_nextpc_ID};
            5'h5: chk_data = pc_EX;
            5'h6: chk_data = alu_a;
            5'h7: chk_data = alu_b;
            5'h8: chk_data = imm_ID;
            5'h9: chk_data = IR_EX;
            5'hA: chk_data = {
                              mem_to_reg_ME, mem_write_ME, 
                              reg_write_ME,ld_nextpc_ME};
            5'hB: chk_data = alu_out_EX;
            5'hC: chk_data = store_data_ME;
            5'hD: chk_data = IR_ME;
            5'hE: chk_data = {mem_write_ME, reg_write_WB,mem_to_reg_WB};
            5'hF: chk_data = load_data_ME;
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

//At every state, harzard situation can occur depending on the some special signal
//Combine Forwarding and Harzard unit
Hazard_unit_1 hazard_unit(
                //input
                .rst(rst),
                .branch_EX(branch_EX),
                .jalr_EX(jalr_EX),
                .jal_ID(jal_ID),
                .jal_EX(jal_EX),
                .rs1_ID(rs1_ID),
                .rs2_ID(rs2_ID),
                .rs1_EX(rs1_EX),
                .rs2_EX(rs2_EX),
                .reg_read_EX(reg_read_EX),
                .mem_to_reg_EX(mem_to_reg_EX),
                .rd_EX(rd_EX),
                .rd_ME(rd_ME),
                .reg_write_ME(reg_write_ME),
                .rd_WB(rd_WB),
                .reg_write_WB(reg_write_WB),
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
                .pc_in(pc_in),
                .pc_IF(pc_IF)//get the next pc depend on en and clear
            );  
assign pc_in=next_pc;//PC control
always @(*) begin //npc control
    if(branch_EX)
        next_pc<= branch_nextpc;
    else if (jalr_EX)
        next_pc<= alu_out_EX;
    else if (jal_EX)//at ID state, JAL and B's destination is calculated
                      // For JAl, it will jump, so  pipelining need to be stall
        next_pc<= branch_nextpc;
    else 
        next_pc <= pc_IF + 32'h4;
end

Instr_Mem InstrMem(//get instr
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
                .we( |reg_write_WB ),
                .ra1(rs1_ID),
                .ra2(rs2_ID),
                .ra3(chk_addr[4: 0]),
                .wa(rd_WB),
                .wd(reg_write_data),
                .rf_data1(reg_out1_ID),
                .rf_data2(reg_out2_ID),
                .rf_data3(r_data)
             );
control1 control(//create control signal
                //input
                .instr(instruction),
                //output
                .jal_ID(jal_ID),
                .jalr_ID(jalr_ID),
                .reg_write_ID(reg_write_ID),
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
                .jal_EX(jal_EX),
                .jalr_ID(jalr_ID),//in
                .jalr_EX(jalr_EX),//out
                .reg_write_ID(reg_write_ID),//in
                .reg_write_EX(reg_write_EX),//out
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

always @(*) begin// branch decide
    case (branch_type_EX)
        BEQ:
            branch_EX = (alu_a == alu_b) ? 1'b1 : 1'b0;
        BNE:
            branch_EX = (alu_a == alu_b) ? 1'b0 : 1'b1;
        BLT:
            branch_EX = (alu_a_signed < alu_b_signed) ? 1'b1 : 1'b0;
        BLTU:
            branch_EX = (alu_a < alu_b) ? 1'b1 : 1'b0;
        BGE:
            branch_EX = (alu_a_signed >= alu_b_signed) ? 1'b1 : 1'b0;
        BGEU:
            branch_EX = (alu_a >= alu_b) ? 1'b1 : 1'b0;
        default:
            branch_EX = 1'b0;  
    endcase
end

//Alu and Forward
assign forward_data1 = forward1_EX[1] ? (alu_out_ME) : ( forward1_EX[0] ? reg_write_data : reg_out1_EX );
assign forward_data2 = forward2_EX[1] ? alu_out_ME : ( forward2_EX[0] ? reg_write_data : reg_out2_EX );
assign alu_a = alu_src1_EX ? pc_EX : forward_data1;
assign alu_b = alu_src2_EX[1] ? (imm_EX) : ( alu_src2_EX[0] ? rs2_EX : forward_data2 );

assign alu_a_signed = $signed(alu_a);
assign alu_b_signed = $signed(alu_b);

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
                .reg_write_EX(reg_write_EX),//in
                .reg_write_ME(reg_write_ME),//out
                .mem_to_reg_EX(mem_to_reg_EX),//in
                .mem_to_reg_ME(mem_to_reg_ME),//out
                .mem_write_EX(mem_write_EX),//in
                .mem_write_ME(mem_write_ME),//out
                .ld_nextpc_EX(ld_nextpc_EX),//in
                .ld_nextpc_ME(ld_nextpc_ME)//out
          );

assign result_ME = ld_nextpc_ME ? (pc_ME + 4) : alu_out_ME;//for J-TYPE

wire mem_we;
wire[31:0] load_data;
assign we = (alu_out_ME[15: 8] == 8'hff) ? 0 : mem_write_ME[0];

Data_Mem Data_Mem (//load and store
            .clk (clk),
            .we (mem_write_ME[0]),//if write w_en=1 and discriminate the type of data
            .a (alu_out_ME[9: 2]),//only useful for data of word 
            .d (store_data_ME),//move the byte to fill in 32'bit wide   ????
            .spo (load_data),
            .dpra(chk_addr[7:0]), 
            .dpo (m_data)
        );

assign load_data_new = (alu_out_ME[15: 8] == 8'hff) ? io_din : load_data;

always @ (posedge clk)
begin
    load_data_old <= load_data_new;
end

//if stall or clear the data 
assign load_data_ME = stall_ME ? load_data_old : (flush_ME ? 32'b0 : load_data_new );


//WB and MEM/WB_reg: load or store data decide the date written into Register Files
WB_reg1 WB_reg(
                .clk(clk),
                .en(~stall_WB),
                .clear(flush_WB),
                .IR_ME(IR_ME),
                .IR_WB(IR_WB),
                .load_data_ME(load_data_ME),
                .load_data_WB(load_data_WB),
                .result_ME(result_ME),
                .result_WB(result_WB),
                .rd_ME(rd_ME),
                .rd_WB(rd_WB),
                .reg_write_ME(reg_write_ME),
                .reg_write_WB(reg_write_WB),
                .mem_to_reg_ME(mem_to_reg_ME),
                .mem_to_reg_WB(mem_to_reg_WB)
         );

assign reg_write_data = ~mem_to_reg_WB ? result_WB : load_data_WB;


endmodule