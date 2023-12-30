`timescale 1ns / 1ps

module DataMem(
    input  clk,
    input  [3:0] we, 
    input  [14:2] addr,
    input  [9:2] dpra,
    input  [31:0] din,
    output reg [31: 0]dpo,
    output reg [31:0] douta
);

reg [31:0] ram_cell [0:4096];
integer i;


initial begin
//    ram_cell[0]=32'h10;
//    ram_cell[       0] = 32'h00000063;
//    ram_cell[       1] = 32'h000000c6;
//    ram_cell[       2] = 32'h00000095;
//    ram_cell[       3] = 32'h00000042;
//    ram_cell[       4] = 32'h00000074;
//    ram_cell[       5] = 32'h000000b3;
//    ram_cell[       6] = 32'h00000010;
//    ram_cell[       7] = 32'h00000002;
//    ram_cell[       8] = 32'h00000072;
//    ram_cell[       9] = 32'h0000009e;
//    ram_cell[      10] = 32'h0000005a;
//    ram_cell[      11] = 32'h00000006;
//    ram_cell[      12] = 32'h0000002c;
//    ram_cell[      13] = 32'h0000001e;
//    ram_cell[      14] = 32'h000000e6;
//    ram_cell[      15] = 32'h00000000;
//    ram_cell[      16] = 32'h00000012;
//    ram_cell[      17] = 32'h000000cb;
//    ram_cell[      18] = 32'h00000041;
//    ram_cell[      19] = 32'h0000006d;
//    ram_cell[      20] = 32'h000000fe;
//    ram_cell[      21] = 32'h000000e7;
//    ram_cell[      22] = 32'h000000a0;
//    ram_cell[      23] = 32'h000000ca;
//    ram_cell[      24] = 32'h00000098;
//    ram_cell[      25] = 32'h000000f1;
//    ram_cell[      26] = 32'h00000068;
//    ram_cell[      27] = 32'h0000001f;
//    ram_cell[      28] = 32'h000000ec;
//    ram_cell[      29] = 32'h000000d0;
//    ram_cell[      30] = 32'h00000031;
//    ram_cell[      31] = 32'h000000e5;
//    ram_cell[      32] = 32'h0000002a;
//    ram_cell[      33] = 32'h0000000d;
//    ram_cell[      34] = 32'h0000009c;
//    ram_cell[      35] = 32'h000000a1;
//    ram_cell[      36] = 32'h00000028;
//    ram_cell[      37] = 32'h0000003d;
//    ram_cell[      38] = 32'h00000085;
//    ram_cell[      39] = 32'h00000071;
//    ram_cell[      40] = 32'h000000ba;
//    ram_cell[      41] = 32'h000000d4;
//    ram_cell[      42] = 32'h0000004c;
//    ram_cell[      43] = 32'h00000024;
//    ram_cell[      44] = 32'h00000014;
//    ram_cell[      45] = 32'h00000017;
//    ram_cell[      46] = 32'h000000c7;
//    ram_cell[      47] = 32'h000000f3;
//    ram_cell[      48] = 32'h000000f9;
//    ram_cell[      49] = 32'h0000009a;
//    ram_cell[      50] = 32'h000000ea;
//    ram_cell[      51] = 32'h0000000a;
//    ram_cell[      52] = 32'h0000004f;
//    ram_cell[      53] = 32'h00000087;
//    ram_cell[      54] = 32'h00000080;
//    ram_cell[      55] = 32'h00000089;
//    ram_cell[      56] = 32'h0000007c;
//    ram_cell[      57] = 32'h00000076;
//    ram_cell[      58] = 32'h000000d5;
//    ram_cell[      59] = 32'h000000f2;
//    ram_cell[      60] = 32'h00000001;
//    ram_cell[      61] = 32'h000000a9;
//    ram_cell[      62] = 32'h00000035;
//    ram_cell[      63] = 32'h0000000c;
//    ram_cell[      64] = 32'h0000004b;
//    ram_cell[      65] = 32'h00000059;
//    ram_cell[      66] = 32'h000000c1;
//    ram_cell[      67] = 32'h000000ff;
//    ram_cell[      68] = 32'h00000011;
//    ram_cell[      69] = 32'h0000000b;
//    ram_cell[      70] = 32'h000000b8;
//    ram_cell[      71] = 32'h0000007f;
//    ram_cell[      72] = 32'h00000065;
//    ram_cell[      73] = 32'h0000008b;
//    ram_cell[      74] = 32'h00000045;
//    ram_cell[      75] = 32'h00000088;
//    ram_cell[      76] = 32'h000000e2;
//    ram_cell[      77] = 32'h000000bc;
//    ram_cell[      78] = 32'h00000097;
//    ram_cell[      79] = 32'h00000078;
//    ram_cell[      80] = 32'h000000dc;
//    ram_cell[      81] = 32'h0000002e;
//    ram_cell[      82] = 32'h000000a4;
//    ram_cell[      83] = 32'h0000002d;
//    ram_cell[      84] = 32'h0000008f;
//    ram_cell[      85] = 32'h000000cc;
//    ram_cell[      86] = 32'h000000eb;
//    ram_cell[      87] = 32'h0000008e;
//    ram_cell[      88] = 32'h000000b2;
//    ram_cell[      89] = 32'h00000049;
//    ram_cell[      90] = 32'h000000c5;
//    ram_cell[      91] = 32'h000000c3;
//    ram_cell[      92] = 32'h00000023;
//    ram_cell[      93] = 32'h00000069;
//    ram_cell[      94] = 32'h00000036;
//    ram_cell[      95] = 32'h000000f7;
//    ram_cell[      96] = 32'h00000007;
//    ram_cell[      97] = 32'h00000054;
//    ram_cell[      98] = 32'h0000000e;
//    ram_cell[      99] = 32'h00000084;
//    ram_cell[     100] = 32'h00000099;
//    ram_cell[     101] = 32'h000000e4;
//    ram_cell[     102] = 32'h00000021;
//    ram_cell[     103] = 32'h000000da;
//    ram_cell[     104] = 32'h0000009d;
//    ram_cell[     105] = 32'h000000f6;
//    ram_cell[     106] = 32'h00000039;
//    ram_cell[     107] = 32'h000000a3;
//    ram_cell[     108] = 32'h0000008d;
//    ram_cell[     109] = 32'h000000e3;
//    ram_cell[     110] = 32'h00000062;
//    ram_cell[     111] = 32'h0000005f;
//    ram_cell[     112] = 32'h000000dd;
//    ram_cell[     113] = 32'h00000083;
//    ram_cell[     114] = 32'h000000fc;
//    ram_cell[     115] = 32'h00000056;
//    ram_cell[     116] = 32'h0000002f;
//    ram_cell[     117] = 32'h00000019;
//    ram_cell[     118] = 32'h00000032;
//    ram_cell[     119] = 32'h000000b9;
//    ram_cell[     120] = 32'h000000c9;
//    ram_cell[     121] = 32'h0000005b;
//    ram_cell[     122] = 32'h000000a8;
//    ram_cell[     123] = 32'h000000ae;
//    ram_cell[     124] = 32'h000000a5;
//    ram_cell[     125] = 32'h0000006b;
//    ram_cell[     126] = 32'h0000001b;
//    ram_cell[     127] = 32'h0000003c;
    for(i = 0 ; i <128 ; i = i+1)
            ram_cell[i][31:0] <= 127-i;
    for(i = 128 ; i <4096 ; i = i+1)
            ram_cell[i][31:0] <= 0;
//     ram_cell[0]=32'hdeadbeef;
//     ram_cell[1]=32'h8;
//     for(i=0;i<256;i=i+1)
//        ram_cell [i+1][31:0] <= i;
end
initial begin 
    douta=0; 
    dpo = 0;
end

always @ (posedge clk) begin
    dpo <= ram_cell[dpra];
    douta <= ram_cell[addr];
    ram_cell[addr][7: 0] <= we[0] ? din[7: 0] : ram_cell[addr][7: 0];
    ram_cell[addr][15: 8] <= we[1] ? din[15: 8] : ram_cell[addr][15: 8];
    ram_cell[addr][23:16] <= we[2] ? din[23:16] : ram_cell[addr][23:16];
    ram_cell[addr][31:24] <= we[3] ? din[31:24] : ram_cell[addr][31:24];
end  

endmodule
