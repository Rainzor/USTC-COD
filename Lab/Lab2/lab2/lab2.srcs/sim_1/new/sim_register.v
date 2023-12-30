`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 20:39:15
// Design Name: 
// Module Name: regfile_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile_sim(

    );
reg clk, we;
reg [4: 0] ra0, ra1, wa;
wire [31: 0] rd0, rd1;
reg[31:0] wd;
register_file
   rf(
    .clk(clk),
    .ra0(ra0),
    .rd0(rd0),
    .ra1(ra1),
    .rd1(rd1), 
    .wa(wa),
    .we(we), 
    .wd(wd) 
  );

parameter PERIOD = 10,    
          CYCLE = 20;		
initial
  begin
    clk = 0;
    repeat ( 100 * CYCLE )
      #( PERIOD / 5) clk = ~clk;
    $finish;
  end
initial
  begin
    ra0 = 5'b00010;     
    ra1 = 5'b00011;
    wd=32'b0;
    wa = 5'b0;
    we=0;
    #PERIOD;
    we = 1;
    repeat(31)begin
        #5;
        wa = wa+5'b1;
        wd = wd+32'b1;
    end
    ra1 = 5'd31;
    #(PERIOD/2);
    ra0=5'd4;
    ra1=5'd16;
    #(PERIOD);
    
    #PERIOD;
    wa = 5'b0;
    wd = 32'ha5a5;
    ra0 =5'b1;
    ra1 = 5'd30;
    #PERIOD;
    wa = 5'd4;
    wd = 32'b1;
    ra1 = 5'd4;
    ra0 = 5'd0;
    #PERIOD;
    wa = 5'd2;
    wd = 32'hffff;
    ra0 = 5'd11;
    ra1 = 5'd13;
    #PERIOD;
    $finish;
  end
endmodule

