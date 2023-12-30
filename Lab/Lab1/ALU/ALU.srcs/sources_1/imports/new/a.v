`timescale 10ns / 1ns
module alu#(
parameter WIDTH = 6,         //数据宽度
parameter SUB = 3'b000,
parameter ADD = 3'b001,
parameter AND = 3'b010,
parameter OR = 3'b011,
parameter XOR = 3'b100,
parameter RS = 3'b101,
parameter LS = 3'b110,
parameter RRS= 3'b111
)(
input [WIDTH-1:0] a,
input [WIDTH-1:0] b,               //两操作数
input [2:0] s,                     //功能选择
output reg[WIDTH-1:0] y,           //运算结果
output reg[2:0] f                  //标志
);
always@(*)begin
    case (s)
        SUB:begin
            y=a-b;
            if(!y) f=3'b001;
            else begin
                f[0]=0;
                f[1]=(a<b)? 1:0;
                if(a[WIDTH-1]==1&&b[WIDTH-1]==0) f[2]=1;
                else if(a[WIDTH-1]==0&&b[WIDTH-1]==1) f[2]=0;
                else if(a[WIDTH-1]==0 && b[WIDTH-1]==0) f[2]=(a<b)? 1:0;
                else f[2]=(a>b)? 1:0;
            end
        end
        ADD:begin
            y=a+b;
            f=0;
        end
        AND:begin
            y=a&b;
            f=0;
        end
        OR:begin
            y=a|b;
            f=0;
        end
        XOR:begin
            y=a^b;
            f=0;
        end
        RS:begin
            y=a>>b;
            f=0;
        end
        LS:begin
            y=a<<b;
            f=0;
        end
        RRS:begin
            y=a>>>b;
            f=0;
        end
        default:begin
            y=0;
            f=0;
        end
    endcase
end
endmodule
