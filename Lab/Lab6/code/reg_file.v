`timescale 1ns / 1ps
module  reg_file  #(
    parameter AW = 5,		
    parameter DW = 32		
)(
    input  clk,			
    input rst,
    input we,			
    input [AW-1:0]  wa,		
    input [DW-1:0]  wd,		
    input [AW-1:0]  ra1, ra2, ra3,	
    output wire[DW-1:0]  rf_data1, rf_data2, rf_data3	
);

reg [DW-1:0]  rf [0: 31]; 	

integer i;

assign rf_data1 = (ra1==5'b0)? (32'b0):((ra1==wa && we)? wd : rf[ra1]);
assign rf_data2 = (ra2==5'b0)? (32'b0):((ra2==wa && we)? wd : rf[ra2]);	
assign rf_data3 = (ra3==5'b0)? (32'b0):((ra3==wa && we)? wd : rf[ra3]);

always  @(posedge  clk or posedge rst) begin
    if(rst) begin
         for (i = 0;i < 32;i = i + 1)
            rf[i] <= 32'b0;
    end else if((we == 1'b1) &&wa!=5'b0)begin 
            rf[wa]  <=  wd;		//
    end
end   
    

endmodule