module segment2(
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
    output reg [7:0] digit,
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
reg [31:0] counter;
reg[3:0] seg_in;

always @(posedge clock ) begin
    if(!reset) begin
        counter <= 32'd0;
        digit <= 8'b1111_1110;
    end
    else if(counter < 32'd100000)begin
        counter <= counter + 32'd1;
    end
    else begin
        counter <= 32'd0;
        digit <= {digit[6:0],digit[7]};
    end
end

// Showing digits
always @(posedge clock) begin
    if(~digit[0]) begin
        case(counter0)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end
    else if(~digit[1]) begin
        case(counter1)
       4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end
    else if(~digit[2]) begin
        case(counter2)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end
    else if(~digit[3]) begin
        case(counter3)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end 
    else if(~digit[4]) begin
        case(counter4)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end 
    else if(~digit[5]) begin
        case(counter5)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase
    end 
    else if(~digit[6]) begin
        case(counter6)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase        
    end if(~digit[7]) begin
        case(counter7)
        4'd0: begin segment_out <= Hex0; end
        4'd1: begin segment_out <= Hex1; end
        4'd2: begin segment_out <= Hex2; end
        4'd3: begin segment_out <= Hex3; end
        4'd4: begin segment_out <= Hex4; end
        4'd5: begin segment_out <= Hex5; end
        4'd6: begin segment_out <= Hex6; end
        4'd7: begin segment_out <= Hex7; end
        4'd8: begin segment_out <= Hex8; end
        4'd9: begin segment_out <= Hex9; end
        4'ha: begin segment_out <= Hexa; end
        4'hb: begin segment_out <= Hexb; end
        4'hc: begin segment_out <= Hexc; end
        4'hd: begin segment_out <= Hexd; end
        4'he: begin segment_out <= Hexe; end
        4'hf: begin segment_out <= Hexf; end
        default: begin segment_out <= Hexx; end
        endcase        
    end else segment_out<=Hexx;
end

endmodule
