`timescale 1ns / 1ns
module test_for_sort(
    );
reg clk, rst;
wire [31:0] pc;
cpu cpu(.clk(clk), .rstn(rst), .pc(pc));
parameter PERIOD = 2;    	
initial
  begin
    clk = 0;
    repeat (5000)
      #(PERIOD / 2) clk = ~clk;
    $finish;
  end
initial begin
    rst <= 1;

    #(PERIOD)
    rst <= 0;

    #(1500*PERIOD)
    rst <= 1;
end
endmodule
