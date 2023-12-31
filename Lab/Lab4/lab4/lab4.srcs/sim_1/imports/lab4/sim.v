module test_for_cpu(
    );
reg clk, rst;
wire [31:0] pc;
test_cpu cpu(.clk(clk), .rstn(rst), .pc(pc));
parameter PERIOD = 10;    	
initial
  begin
    clk = 0;
    repeat (300)
      #(PERIOD / 2) clk = ~clk;
    $finish;
  end
initial begin
    rst <= 1;

    #(PERIOD)
    rst <= 0;

    #(200*PERIOD)
    rst <= 1;
end
endmodule