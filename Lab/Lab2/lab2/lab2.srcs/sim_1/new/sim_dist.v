`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/26 17:58:40
// Design Name: 
// Module Name: sim_dist
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


module sim_dist(

    );
    reg clk, we;
    reg[7:0] a;
    reg[15:0] d;
    wire[15:0] spo;
    
    dist_mem_gen_0 dist_sim(a, d, clk, we, spo);
    
    parameter PERIOD =10,
              CYCLE=20;
    initial
      begin
        clk = 0;
        repeat ( 3 * CYCLE )
          #( PERIOD / 2 ) clk = ~clk;
        $finish;
      end   
    initial begin
        a = 8'h0;
        d = 16'hff;
        we = 0;
    
        #PERIOD;
        a = 8'h2;
        d = 16'hf5;
        we = 1;
        #PERIOD;
        we = 0;
        a = 8'h0;
        d = 16'h5a;
    
        #PERIOD;
        a = 8'h1;
        d = 16'h00;
        we = 1;
        #PERIOD;
        a = 8'h1;
        d = 16'h11;
        we = 0;
        #PERIOD;
        a = 8'h3;
        d = 16'hcc;
        we  = 1;
    end
endmodule
