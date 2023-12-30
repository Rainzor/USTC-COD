module reg_file #( parameter WIDTH = 32 ) (  //data width
         input clk,  //clock
         input [ 4: 0 ] ra0,  //read address 0
         output [ WIDTH - 1: 0 ] rd0,  //read data 0
         input [ 4: 0 ] ra1,  //read address 1
         output [ WIDTH - 1: 0 ] rd1,  //read data 1
         input [ 4: 0 ] ra2, //read address 2
         output [ WIDTH - 1: 0 ] rd2, //read data 2
         input [ 4: 0 ] wa,  //write address
         input we,  //write enable
         input [ WIDTH - 1: 0 ] wd //write data
       );
reg [ WIDTH - 1: 0 ] mem[ 0: WIDTH - 1 ];

assign rd0 = mem[ ra0 ];
assign rd1 = mem[ ra1 ];
assign rd2 = mem[ ra2 ];
always @( posedge clk )
  begin
    if ( we )
      begin
        if(wa)begin
        mem[ wa ] <= wd;
        mem[0]<=0;
        end
        else
        mem[0]<=0;
      end
    else mem[0]=0;
  end
endmodule