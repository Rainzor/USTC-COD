`timescale 1ns / 1ps

module DataMem(
    input  clk,
    input  [3:0] we, 
    input  [9:2] addr,
    input  [9:2] dpra,
    input  [31:0] din,
    output reg [31: 0]dpo,
    output reg [31:0] douta
);

reg [31:0] data_ram [0:255];
integer i;


initial begin
    data_ram[0]=32'h10;
    for (i = 0;i < 16;i = i + 1)
            data_ram [i+1][31: 0] <= 15-i;
    for(i = 17 ; i < 50 ; i = i+1)
            data_ram[i][31:0] <= 0;
//     data_ram[0]=32'hdeadbeef;
//     data_ram[1]=32'h8;
//     for(i=0;i<256;i=i+1)
//        data_ram [i+1][31:0] <= i;
end
initial begin 
    douta=0; 
    dpo = 0;
end

always @ (posedge clk) begin
    dpo <= data_ram[dpra];
    douta <= data_ram[addr];
    data_ram[addr][7: 0] <= we[0] ? din[7: 0] : data_ram[addr][7: 0];
    data_ram[addr][15: 8] <= we[1] ? din[15: 8] : data_ram[addr][15: 8];
    data_ram[addr][23:16] <= we[2] ? din[23:16] : data_ram[addr][23:16];
    data_ram[addr][31:24] <= we[3] ? din[31:24] : data_ram[addr][31:24];
end  

endmodule
