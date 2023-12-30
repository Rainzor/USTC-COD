module segment_trans(
    input       clock,
    input       reset,
    input [3:0] counter0,
    input [3:0] counter1,
    input [3:0] counter2,
    input [3:0] counter3,
    input [3:0] counter4,
    input [3:0] counter5,
    input [3:0] counter6,
    input [3:0] counter7,
    output reg [7:0] an,
    output reg [6:0] segment_out
);

parameter
            Hexx = 7'b1111111,
            Hex0 = 7'b0000001, //共阳极数码管
            Hex1 = 7'b1001111,
            Hex2 = 7'b0010010,
            Hex3 = 7'b0000110,
            Hex4 = 7'b1001100,
            Hex5 = 7'b0100100,
            Hex6 = 7'b0100000,
            Hex7 = 7'b0001111,
            Hex8 = 7'b0000000,
            Hex9 = 7'b0000100,
            Hexa = 7'b0001000,
            Hexb = 7'b1100000,
            Hexc = 7'b0110001,    
            Hexd = 7'b1000010,
            Hexe = 7'b0110000,
            Hexf = 7'b0111000;

// Looping digit
localparam N = 19;
reg [N-1:0] regN;
reg[3:0] hex_in;
always@(posedge clock, posedge reset)begin
	if(!reset)
			regN <= 0;
		else
			regN <= regN + 1;
end
always@ *
	begin
		case(regN[N-1:N-3])
		3'b000:begin
			an = 8'b1111_1110; //选中第1个数码管
			hex_in = counter0; //数码管显示的数字由hex_in控制，显示hex0输入的数字；
		end
		3'b001:begin
			an = 8'b1111_1101; //选中第二个数码管
			hex_in = counter1;
		end
		3'b010:begin
			an = 8'b1111_1011; //选中第3个数码管
			hex_in = counter2;
		end
		3'b011:begin
			an = 8'b1111_0111; //选中第4个数码管
			hex_in = counter3;
		end
		3'b100:begin
			an = 8'b1110_1111; 
			hex_in = counter4;
		end
		3'b101:begin
			an = 8'b1101_1111; 
			hex_in = counter5;
		end
		3'b110:begin
			an = 8'b1011_1111; 
			hex_in = counter6;
		end
		3'b111:begin
			an = 8'b0111_1111; 
			hex_in = counter7;
		end
		endcase
	
	end

// Showing digits
always@ *
	begin
        case(hex_in)
        4'h0: begin segment_out = Hex0; end
        4'h1: begin segment_out = Hex1; end
        4'h2: begin segment_out = Hex2; end
        4'h3: begin segment_out = Hex3; end
        4'h4: begin segment_out = Hex4; end
        4'h5: begin segment_out = Hex5; end
        4'h6: begin segment_out = Hex6; end
        4'h7: begin segment_out = Hex7; end
        4'h8: begin segment_out = Hex8; end
        4'h9: begin segment_out = Hex9; end
        4'ha: begin segment_out = Hexa; end
        4'hb: begin segment_out = Hexb; end
        4'hc: begin segment_out = Hexc; end
        4'hd: begin segment_out = Hexd; end
        4'he: begin segment_out = Hexe; end
        4'hf: begin segment_out = Hexf; end
        default: begin segment_out = Hexx; end
        endcase
    end 


endmodule
