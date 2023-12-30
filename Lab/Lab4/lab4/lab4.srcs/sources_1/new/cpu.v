
module  cpu (
  input clk,  //(时钟频率不能是100MHZ，那么就要调低，具体看CPU性能) 
  input rstn,

  //IO_BUS
  output [7:0]  io_addr,	//外设地址
  output [31:0]  io_dout,	//向外设输出的数据
  output  io_we,		//向外设输出数据时的写使能信号
  output  io_rd,		//从外设输入数据时的读使能信号
  input [31:0]  io_din,	//来自外设输入的数据

  //Debug_BUS
  output reg[31:0] pc, 	        //当前执行指令地址
  input [15:0] chk_addr,	    //数据通路状态的编码地址 
  output reg[31:0] chk_data    //数据通路状态的数据
);
localparam  ADD = 3'b000,
            SUB = 3'b001,
            AND = 3'b010,
            OR = 3'b011,
            XOR = 3'b100,
            SRL = 3'b101,
            SLL = 3'b110,
            SRA= 3'b111;
            
localparam  OP_R = 7'b0110011,
            OP_LOAD = 7'b0000011,
            OP_IMM = 7'b0010011,
            OP_STORE = 7'b0100011,
            OP_JAL = 7'b1101111, 
            OP_JALR = 7'b1100111,
            OP_BRANCH = 7'b1100011,
            OP_AUIPC = 7'b0010111,
            OP_LUI = 7'b0110111;
                        
localparam  WB_ALU = 3'b000,
            WB_RD = 3'b001,
            WB_PC_ADD = 3'b010,
            WB_PC_SUM= 3'b011,
            WB_LUI=3'b100,
            WB_NULL=3'b111;
            
localparam  B_E=3'b000,
            B_L=3'b001,
            J_JAL=3'b010,
            I_JALR=3'b011,
            B_NULL=3'b111,
            B_G=3'b100;
//control    
reg MemWrite,AluSrc,RegWrite,ImmGen;
reg[2:0] AluOp,MemtoReg, Branch;
reg[31:0]extend_imm;
reg[31:0] dbg_data;


//instructions
wire[2:0] funct3;
wire[4:0] rs1,rs2,rd;
wire[6:0] opcode,funct7;
wire[31:0] instruction;
//alu
wire[1:0] alu_z;
wire[31:0] alu_a, alu_b, alu_out;
//pc
reg[31:0] next_pc;
wire[31:0] pc_sum,pc_add;
//reg and mem
reg[31:0] reg_wd;
wire  data_mem_we;
wire[31:0] data_mem_out,data_mem_mux;
wire[31:0] reg_rd1,reg_rd2;
//debuge 
wire [31:0] r_data; //data read from register
wire [31:0] m_data; //data read from mem

//IO
assign io_we = (alu_out[15:8]==8'hff) & MemWrite;//写使能
assign data_mem_mux = (alu_out[15:8]==8'hff)?io_din:data_mem_out;//当不由内存写入回寄存器时，由外设写入
assign io_rd = (alu_out[15:8]==8'hff) & (MemtoReg==WB_RD);//读使能
assign io_dout = reg_rd2;  //e.g. sw x10 4(0xff00) 计算 外设的地址 并向外设存值
assign io_addr = alu_out[7:0];
/*Debug*/
always@(*)begin
    case(chk_addr[13:12])
      2'b00:begin
        case(chk_addr[3:0])
            4'h0: chk_data = next_pc;
            4'h1: chk_data = pc;
            4'h2: chk_data = instruction;
            4'h3: chk_data = {Branch,MemtoReg,AluOp,MemWrite,AluSrc,RegWrite};    
            4'h4: chk_data = reg_rd1;
            4'h5: chk_data = reg_rd2;
            4'h6: chk_data = extend_imm;
            4'h7: chk_data = alu_out;
            4'h8: chk_data = data_mem_mux;
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


//pc control
assign pc_add=pc+32'd4;
assign pc_sum=extend_imm+pc;
always@(*)begin
    case(Branch)
        B_E:next_pc=(alu_z[0] & (~alu_z[1])) ? pc_sum:pc_add;
        B_L:next_pc=(alu_z==2'b10) ? pc_sum:pc_add;
        B_G:next_pc=(alu_z==2'b10) ? pc_add:pc_sum;
        J_JAL:next_pc = pc_sum;
        I_JALR:next_pc = {alu_out[31:1],1'b0}; 
        B_NULL:next_pc = pc_add;
        default:next_pc=pc_add;
    endcase
end 

always@(posedge clk, posedge rstn)begin
  if (rstn) begin
      pc <= 32'd0;
  end else begin
      pc <= next_pc;
  end
end

//get IC
inst_mem inst_mem(pc[9:2], instruction);
assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd =  instruction[11:7];
//register

reg_file #(32) Register
                (.clk(clk), 
                .ra0(rs1), 
                .ra1(rs2),
                .ra2(chk_addr[4:0]),
                .rd0(reg_rd1), 
                .rd1(reg_rd2),
                .rd2(r_data),
                .wa(rd), 
                .we(RegWrite), 
                .wd(reg_wd));
                
always @(*) begin //reg write back control
    case (MemtoReg)
        WB_ALU: reg_wd = alu_out;
        WB_RD:  reg_wd = data_mem_mux;
        WB_PC_ADD:reg_wd = pc_add;
        WB_PC_SUM:reg_wd = pc_sum; 
        WB_LUI:reg_wd = extend_imm;
        default: reg_wd = 0;
    endcase
end
    
//CALCULATE ALU
assign alu_a = reg_rd1;
assign alu_b = AluSrc ? extend_imm : reg_rd2;//是写入立即数还是寄存器读口？
alu  ALU(.a(alu_a), .b(alu_b),.f(AluOp), .y(alu_out), .z(alu_z));

//Distributed Memory
assign data_mem_we = MemWrite&(~(alu_out[15:8]==8'hff));//当外设不写时，内存写
//assign io_we = (alu_out[15:8]==8'hff) & MemWrite;//对外存写使能
data_mem data_mem(
                .a(alu_out[9:2]), 
                .d(reg_rd2), 
                .dpra(chk_addr[7:0]), 
                .clk(clk), 
                .we(data_mem_we), 
                .spo(data_mem_out), 
                .dpo(m_data));
    
//analysis IC and control 
always@(*)begin
    case(opcode)
        OP_R:begin//R： add sub
            Branch = B_NULL;
            ImmGen = 0;
            AluSrc = 0;//ALU使用reg2 
            if(funct7==7'b0000000 )//add
                AluOp = ADD;
            else if(funct7==7'b0100000)//sub
                AluOp = SUB;
            MemtoReg = WB_ALU;
            RegWrite=1;
            MemWrite = 0;
           
        end
        OP_IMM:begin//addi
            Branch = B_NULL;
            ImmGen = 1;
            AluSrc = 1;//ALU使用立即数  
            if(funct3=='b000 )//addi
                AluOp = ADD;
            else if(funct3==3'b001)//slli
                AluOp = SLL;
            MemtoReg = WB_ALU;
            RegWrite=1;
            MemWrite = 0;
            
        end
        OP_LOAD:begin//lw
            Branch=B_NULL;
            ImmGen=1;
            AluSrc=1; //ALU使用立即数          
            AluOp=ADD;
            MemtoReg = WB_RD;
            RegWrite=1;
            MemWrite=0;            

        end
        OP_STORE:begin//sw
            Branch=B_NULL;
            ImmGen=1;
            AluSrc=1;//ALU使用立即数  
            AluOp=ADD;
            MemtoReg = WB_NULL;//不写回寄存器
            RegWrite=0;
            MemWrite=1;//对内存写入
        end
        OP_JAL:begin//jal
            Branch=J_JAL;
            ImmGen=1;//生成立即数
            AluSrc=0; //是PC+立即数       
            AluOp=ADD;
            MemtoReg = WB_PC_ADD;
            RegWrite=1;
            MemWrite=0;            
        end
        OP_JALR:begin//jalr
            Branch=I_JALR;
            ImmGen=1;//生成立即数
            AluSrc=1;        
            AluOp=ADD;
            MemtoReg = WB_PC_ADD;
            RegWrite=1;
            MemWrite=0;   
        end
        OP_BRANCH:begin
            if(funct3==3'b000)//分支指令 beq
                Branch=B_E;
            else if(funct3==3'b100)//ble
                Branch=B_L;
            else if(funct3==3'b101)//bge
                Branch=B_G;
            ImmGen=1;//生成立即数
            AluSrc=0;        
            AluOp=SUB;
            MemtoReg = WB_NULL;
            RegWrite=0;
            MemWrite=0;
        end
        OP_AUIPC:begin//auipc
            Branch=B_NULL;
            ImmGen=1;//生成立即数
            AluSrc=0;        
            AluOp=ADD;
            MemtoReg = WB_PC_SUM;
            RegWrite=1;
            MemWrite=0;
        end
        OP_LUI:begin//lui
            Branch=B_NULL;
            ImmGen=1;//生成立即数
            AluSrc=0;        
            AluOp=ADD;
            MemtoReg = WB_LUI;
            RegWrite=1;
            MemWrite=0;
        end 
        default:begin
            Branch=B_NULL;
            ImmGen=0;//生成立即数
            AluSrc=0;        
            AluOp=ADD;
            MemtoReg = WB_NULL;
            RegWrite=0;
            MemWrite=0; 
        end
    endcase
end
//ImmGen control
always @(*) begin
    if(ImmGen)begin
      case (opcode)
            //addi
            OP_IMM: begin
              if(funct3==3'b000)
              extend_imm = instruction[31]?{20'b1111_1111_1111_1111_1111, instruction[31:20]}:{20'b0000_0000_0000_0000_0000, instruction[31:20]};
              else if(funct3==3'b001)
              extend_imm = {27'b0000_0000_0000_0000_0000_0000_00,instruction[24:20]};
            end
            //lw jalr
            OP_LOAD,OP_JALR: begin
              extend_imm = instruction[31]?{20'b1111_1111_1111_1111_1111, instruction[31:20]}:{20'b0000_0000_0000_0000_0000, instruction[31:20]};
            end
            //sw 
            OP_STORE: begin
              extend_imm = instruction[31]?{20'b1111_1111_1111_1111_1111, instruction[31:25], instruction[11:7]}:{20'b000_0000_0000_0000_0000, instruction[31:25], instruction[11:7]};
            end
            //jal
            OP_JAL: begin
              extend_imm = instruction[31]?{11'b111_1111_1111, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}:{11'b000_0000_0000, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            
            //beq ble bge
            OP_BRANCH: begin
              extend_imm = instruction[31]?{19'b111_1111_1111_1111_1111, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}:{19'b000_0000_0000_0000_0000, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            //lui auipc
            OP_LUI,OP_AUIPC:begin
                extend_imm = {instruction[31:12],12'b0000_0000_0000};
            end
            
            default:
              extend_imm = 32'd0;
        endcase
    end
end


endmodule