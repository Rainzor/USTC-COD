`timescale 1ns / 1ns
module test_for_sort(
    );
reg clk, rst;
wire [31:0] pc;
cpu_s cpu(.clk(clk), .rst(rst), .chk_pc(pc));
parameter PERIOD = 2;    	
initial
  begin
    clk = 0;
    repeat ('h1000_0000)
      #(PERIOD / 2) clk = ~clk;
    $finish;
  end
initial begin
    rst <= 1;

    #(PERIOD)
    rst <= 0;
    
    #(400_000)
    rst <= 1;
end
endmodule
