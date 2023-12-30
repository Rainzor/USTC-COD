`timescale 1ns / 1ps

module test_for_cpu(
    );
reg clk, rst;
wire [31:0] pc;
cpu_1 cpu(.clk(clk), .rst(rst), .chk_pc(pc));
parameter PERIOD = 6;    	
initial
  begin
    clk = 0;
    repeat (400)
      #(PERIOD / 2) clk = ~clk;
    $finish;
  end
initial begin
    rst <= 1;

    #(PERIOD)
    rst <= 0;


end
endmodule
