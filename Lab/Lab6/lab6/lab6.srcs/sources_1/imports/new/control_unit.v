module control(
            input [31:0] instr,
            output wire jal_ID,
            output wire jalr_ID,
            output reg [2: 0] reg_write_ID,
            output wire mem_to_reg_ID, 
            output reg [3: 0] mem_write_ID,
            output reg [1: 0] reg_read_ID,
            output reg [2: 0] branch_type_ID,
            output reg [3: 0] alu_control_ID,
            output wire [1: 0] alu_src2_ID,
            output wire alu_src1_ID,
            output wire ld_nextpc_ID,
            output reg [2: 0] imm_type          
);
localparam RTYPE = 3'd0;
localparam ITYPE = 3'd1;
localparam STYPE = 3'd2;
localparam BTYPE = 3'd3;
localparam UTYPE = 3'd4;
localparam JTYPE = 3'd5;

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

localparam  OP_R = 7'b0110011,
            OP_LOAD = 7'b0000011,
            OP_I = 7'b0010011,
            OP_STORE = 7'b0100011,
            OP_JAL = 7'b1101111, 
            OP_JALR = 7'b1100111,
            OP_BRANCH = 7'b1100011,
            OP_AUIPC = 7'b0010111,
            OP_LUI = 7'b0110111;

wire [6:0] op, fn7;
wire [2:0] fn3;
wire [4:0] rs1, rs2, rd;
reg [1: 0] alu_src2_ID_reg;


assign {fn7, rs2, rs1, fn3, rd, op} = instr;
assign jal_ID = (op == OP_JAL) ? 1'b1:1'b0;
assign jalr_ID = (op == OP_JALR) ? 1'b1:1'b0;
assign mem_to_reg_ID = (op == OP_LOAD) ? 1'b1:1'b0;
assign ld_nextpc_ID = jal_ID | jalr_ID ;

assign alu_src1_ID = (op == OP_AUIPC) ? 1'b1:1'b0;
assign alu_src2_ID = alu_src2_ID_reg;

always @( * ) begin
    if ((op == OP_I) && (fn3[1:0] == 2'b01))//slli, srli, sral
        alu_src2_ID_reg <= 2'b01;
    else if ((op == OP_R) || (op == OP_BRANCH) )//R-type or beq type
        alu_src2_ID_reg <= 2'b00 ;
    else//loadi addi subi lui, auipc...
        alu_src2_ID_reg <= 2'b10;
end


always @( * ) begin
    if (op == OP_BRANCH)
    begin
        case (fn3)
            3'b000:
                branch_type_ID <= BEQ;     //BEQ
            3'b001:
                branch_type_ID <= BNE;     //BNE
            3'b100:
                branch_type_ID <= BLT;     //BLT
            3'b101:
                branch_type_ID <= BGE;     //BGE
            3'b110:
                branch_type_ID <= BLTU;    //BLTU
            default:
                branch_type_ID <= BGEU;    //BGEU
        endcase
    end
    else
    begin
        branch_type_ID <= NOBRANCH;
    end
end

always@( * ) begin
  case (op)
    OP_R:
    begin
        reg_write_ID <= LW;
        mem_write_ID <= 4'b0000;
        imm_type <= RTYPE;
        case (fn3)
            3'b000:
            begin
                if (fn7[5] == 1)
                    alu_control_ID <= SUB;   //SUB
                else
                    alu_control_ID <= ADD;   //ADD
            end
            3'b001:
                alu_control_ID <= SLL;   //SLL
            3'b100:
                alu_control_ID <= XOR;   //XOR
            3'b101:
                alu_control_ID <= SRL;   //SRL
            3'b110:
                alu_control_ID <= OR;    //OR
            default:
                alu_control_ID <= AND;    //AND
        endcase
    end
    OP_I:
    begin
        reg_write_ID <= LW;
        mem_write_ID <= 4'b0000;
        imm_type <= ITYPE;
        case (fn3)
            3'b000:
                alu_control_ID <= ADD;  //ADDI
            3'b001:
                alu_control_ID <= SLL;  //SLLI
            3'b100:
                alu_control_ID <= XOR;    //XORI
            3'b101:
                alu_control_ID <= SRL;   //SRLI
            3'b110:
                alu_control_ID <= OR;   //ORI
            default:
                alu_control_ID <= AND;    //ANDI
        endcase
    end
    OP_LOAD:
    begin    //load
        mem_write_ID <= 4'b0000;
        alu_control_ID <= ADD;
        imm_type <= ITYPE;
        case (fn3)
            3'b000:
                reg_write_ID <= LB;    //LB
            3'b001:
                reg_write_ID <= LH;    //LH
            3'b010:
                reg_write_ID <= LW;     //LW
            3'b100:
                reg_write_ID <= LBU;    //LBU
            default:
                reg_write_ID <= LHU;    //LHU
        endcase
    end
     OP_STORE :
    begin    //store
        reg_write_ID <= NOREGWRITE;
        alu_control_ID <= ADD;
        imm_type <= STYPE;
        case (fn3)
            3'b000: 
                mem_write_ID <= 4'b0001;   //SB
            3'b001:
                mem_write_ID <= 4'b0011;   //SH 
            3'b010:
                mem_write_ID <= 4'b1111;   //SW
            default: 
                mem_write_ID <= 4'b0000;
        endcase
    end
    OP_JAL:
    begin    //jal
        reg_write_ID <= LW;
        mem_write_ID <= 4'b0000;
        alu_control_ID <= ADD;
        imm_type <= JTYPE;
    end
    OP_JALR:
    begin    //jalr
        reg_write_ID <= LW;
        mem_write_ID <= 4'b0000;
        alu_control_ID <= ADD;
        imm_type <= ITYPE;
    end
    OP_BRANCH:
    begin    //branch
        reg_write_ID <= NOREGWRITE;
        mem_write_ID <= 4'b0000;
        imm_type <= BTYPE;
        alu_control_ID <= ADD;
    end
    OP_LUI:
    begin    //lui
        reg_write_ID <= LW;
        mem_write_ID<= 4'b0000;
        alu_control_ID <= LUI;
        imm_type <= UTYPE;
    end
    OP_AUIPC:
    begin   //auipc
        reg_write_ID <= LW;
        mem_write_ID<= 4'b0000;
        alu_control_ID<= ADD;
        imm_type <= UTYPE;
    end
    default:
    begin      
        reg_write_ID <= NOREGWRITE;
        mem_write_ID <= 4'b0000;
        alu_control_ID <= ADD;
        imm_type <= ITYPE;
    end
  endcase
end

always @( * ) begin
    case (imm_type)
        RTYPE:                      //if reg_read[1]==1, 
            reg_read_ID = 2'b11;    //means this instr may use reg_data_out1
        ITYPE:                      //if reg_read[0]==1, 
            reg_read_ID = 2'b10;    //means this instr may use reg_data_out2
        STYPE:
            reg_read_ID = 2'b11;
        BTYPE:
            reg_read_ID = 2'b11;
        UTYPE:
            reg_read_ID = 2'b00;
        JTYPE:
            reg_read_ID = 2'b00;
        default:
            reg_read_ID = 2'b00;
    endcase
end





endmodule