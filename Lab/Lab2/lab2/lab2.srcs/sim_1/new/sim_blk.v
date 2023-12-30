`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/26 19:08:50
// Design Name: 
// Module Name: sim_blk
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


module sim_blk(

    );
    reg clka, ena, wea;
reg [ 7: 0 ] addra;
reg [ 15: 0 ] dina;
wire [ 15: 0 ] douta;
blk_mem_gen_0 blk_sim(clka, ena, wea, addra, dina, douta);
parameter PERIOD = 10,    	//time per cycle
          CYCLE = 20;		//total cycles
initial
  begin
    clka = 0;
    repeat ( 3 * CYCLE )
      #( PERIOD / 2 ) clka = ~clka;
    $finish;
  end
initial
  begin
        ena = 1;      		
        wea = 0;
        addra = 8'h0;
        dina = 16'hff;
        #PERIOD;
        addra = 8'h2;
        dina = 16'hf5;
        wea = 1;
        #PERIOD;
        wea = 0;
        addra = 8'h0;
        dina = 16'h5a;
    
        #PERIOD;
        addra = 8'h1;
        dina = 16'h00;
        wea = 1;
        #PERIOD;
        addra = 8'h1;
        dina = 16'h11;
        wea = 0;
        #PERIOD;
        addra = 8'h3;
        dina = 16'hcc;
        wea  = 1;
  end
endmodule
