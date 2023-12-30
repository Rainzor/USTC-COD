module IF_reg(
           input clk, en, clear,
           input [31: 0] pc_in,
           output reg [31: 0] pc_IF
       );
initial begin
    pc_IF=0;
end

always @(posedge clk) begin
    if(en) begin
        if(clear)
            pc_IF <= 0;
        else
            pc_IF <= pc_in;
    end
end

endmodule