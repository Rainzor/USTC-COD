`timescale 10ns / 1ns


module DP(
    input clk,
    
    input chk,
    input del,
    input data,
    input addr,
    input run,
   
    output chk_p,
    output del_p,
    output data_p,
    output addr_p,
    output run_p
    );
    
    reg[31:0] count=32'b0;
    wire[4:0] flag;
    reg p[0:4];
    initial begin
    p[0]=0;
    p[1]=0;
    p[2]=0;
    p[3]=0;
    p[4]=0;
    end
    assign chk_p=p[0];
    assign del_p=p[1];
    assign data_p=p[2];
    assign addr_p=p[3];
    assign run_p=p[4];
    assign flag[0] = (chk==1)? 1'b1 : 1'b0;
    assign flag[1] = (del==1)? 1'b1 : 1'b0;
    assign flag[2] = (data==1)? 1'b1 : 1'b0;
    assign flag[3] = (addr==1)? 1'b1 : 1'b0;
    assign flag[4] = (run==1) ? 1'b1 : 1'b0;
    always@(posedge clk)begin
        case(flag)
            5'b00001:
            begin
                count <= count + 1'b1;                
                if(count=='d5000000)begin
                    p[0]<=1'b1;
                end else p[0]<=1'b0;
            end
            5'b00010:
            begin
                  count<=count+1'b1;  
                 if(count=='d5000000)
                    begin
                         p[1]<=1'b1;
                    end else p[1]<=1'b0;
            end
            5'b00100:
            begin
                  count<=count+1'b1;  
                  if(count=='d5000000)
                    begin
                         p[2]<=1'b1;
                    end else p[2]<=1'b0;
            end
            5'b01000:
            begin
                  count<=count+1'b1;  
                  if(count=='d5000000)
                    begin
                         p[3]<=1'b1;
                    end else p[3]<=1'b0;
            end
            5'b10000:
            begin
                    count<=count+1'b1;  
                  if(count=='d5000000)
                    begin
                         p[4]<=1'b1;
                    end else p[4]<=1'b0;
            end
            default:
            begin
                  count<=32'b0;
                  p[0]<=0;p[1]<=0;p[2]<=0;p[3]<=0;
            end
        endcase
    end
endmodule
