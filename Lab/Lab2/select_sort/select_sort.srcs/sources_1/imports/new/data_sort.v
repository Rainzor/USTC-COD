`timescale 1ns / 1ps


module data_sort(
  input  clk, 
  input  rstn,

  input [15:0]  x,	//输入1位十六进制数字
  input del,		//删除1位十六进制数字
  input addr,		//设置地址
  input data,		//修改数据
  input chk,		//查看下一项
  input run,		//启动排序

  output [7:0]  an,		//数码管显示位置
  output [6:0]  seg,    //数码管显示存储器地址和数据
  output busy,	//1-正在排序，0-排序结束
  output [15:0]  cnt//排序耗费时钟周期数
    );
 
  wire chk_p;
  wire del_p;
  wire data_p;
  wire addr_p;
  wire p;
  wire[3:0] h;
  wire [15 : 0] spo,sout;
  wire[15:0] dpo,dout;
  wire[7:0] dpra;

  reg[2:0] state,nextState;
  reg[15:0] d,nextd,Din;
  reg[7:0] a,nexta,Ain;
  reg[7:0] tem_dpra, index;
  reg s;
  reg we;
  reg busy2=0;
  reg[15:0] ram[0:255];
  reg[7:0] count1=9'b0;
  reg[15:0] count=16'b0;
  reg[7:0] index1;
  reg [3:0] sort_state;
  reg [3:0] next_state;
 
  integer min_index;
  integer i,j;
  
  parameter InitState=3'b000,
            InState=3'b001,
            DelState=3'b010,
            DataState=3'b011,
            AddrState=3'b100,
            ChkState=3'b101, 
            RunState=3'b110;
localparam 	s0 = 4'b0000,
			s1 = 4'b0001,
			s2 = 4'b0010,
			s3 = 4'b0011,
			s4 = 4'b0100,
			s5 = 4'b0101,
			s6 = 4'b0110,
			s7 = 4'b0111,
			s8 = 4'b1000,
			s9 = 4'b1001,
			s10 = 4'b1010,
			s11 = 4'b1011,
			s12 = 4'b1100,
			s13 = 4'b1101,
			s14 = 4'b1110,
			s15= 4'b1111;
    


  assign busy=busy2; 
  assign dpra=tem_dpra; 
  assign cnt = count; 

 segment_trans ST(
  .clock(clk),
  .reset(rstn),
  .counter7(a[7:4]),
  .counter6(a[3:0]),
  .counter5(4'b0),
  .counter4(4'b0),
  .counter3(d[15:12]),
  .counter2(d[11:8]),
  .counter1(d[7:4]),
  .counter0(d[3:0]),
  .an(an),
  .segment_out(seg)
  ); 
  
  DP dp(clk,chk,del,data,addr,run,chk_p,del_p,data_p,addr_p,run_p);
  
  DEP dep(clk,x,h,p);
  
  dist_mem_gen_1 dmem (
  .a(Ain),        // input wire [7 : 0] a
  .d(Din),        // input wire [15 : 0] d
  .dpra(dpra),  // input wire [7 : 0] dpra
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
   .spo(spo),  
  .dpo(dpo)    // output wire [15 : 0] dpo
);
   
  always@(*)begin 
        if(!rstn) begin //当rst=0时，重置。
            s=0;
            nextState = InitState;
            nexta=8'b0;
       end else  begin
            if(busy2==0) begin
            case(state)
                InitState:begin
                        nextd=d;
                        nexta=a;
                        if(p==1)
                            nextState=InState;
                        else if(chk_p==1)begin
                            nextState=ChkState;
                        end else if(del_p==1)begin
                            nextState=DelState;
                        end else if(data_p==1)begin
                            nextState=DataState;
                        end else if(addr_p==1)begin
                            nextState=AddrState;
                        end else if(run_p==1)begin
                            nextState=RunState;
                        end
                        else   nextState=InitState;  
                    end
                InState:begin
                        nextd={d[11:0],h};
                        nexta=a;
                        s=1;
                        nextState=InitState;
                    end
                ChkState:begin
                        tem_dpra=a+1'b1;
                        nexta=a+1'b1;
                        s=0;
                        nextState=InitState;
                    end
                DelState:begin
                        tem_dpra=a;
                        nexta=a;
                        nextd={4'b0000,d[15:4]};
                        s=1;
                        nextState=InitState;
                    end
                DataState:begin
                        tem_dpra=a+1'b1;
                        nexta=a+1'b1;
                        s=0;
                        nextState=InitState;
                    end
                 AddrState:begin
                         nexta=d[7:0];
                         tem_dpra=d[7:0];
                        s=0;
                        nextState=InitState;
                    end
                  RunState:begin
                            s=0;
                            nexta=8'b0;    
                            nextState=InitState;
                    end
             endcase
             end else begin
                    case(sort_state)
                        
                        
                        s1: begin
                            //ram[tem_te]<=dpo;
                            if(index<8'b1111_1111)
                                next_state = s2;
                            else 
                                next_state = s4;
                        end
                        
                        s2: begin
                            //ram[index]<=spo;
                            //index++
                            next_state = s3;//赋值
                        end
                        
                        s3: begin
                           //Ain<=index;
                            next_state = s1;
                        end
                        
                        s4: begin
                           // i<=0;
                            //j<=0;
                           //  Ain<=0;
                            next_state = s5;
                        end
                        
                   s5: begin
                            //sort_state<=next_state
                            if(i < 'd256)
                                next_state = s6;
                            else
                                next_state = s13;
                        end
                        
                   s6: begin
                             //min_index <= i;
                             // j <= i + 1;
                            next_state = s7;
                    end
                    
                    s7: begin
                        if(j <'d256)
                            next_state = s8;
                        else
                            next_state = s11;
                    end
                    
                    s8: begin
                        if(ram[j] < ram[min_index])
                            next_state = s9;
                        else
                            next_state = s10;
                    end
                    
                    s9: begin
                      //  min_index <= j;
                        next_state = s10;
                    end
                    
                    s10: begin
                   //  j <= j + 1;
                        next_state = s7;
                    end
                    
                    s11: begin
                           // ram[min_index] <= ram[i];
                          //  ram[i] <= ram[min_index];
                         //   sort_state<=next_state;
                          next_state = s12;
                    end
                    
                    s12: begin
                       //  i<= i + 1;
                        next_state = s5;
                    end
                    
                    s13: begin	
                      //  we<=1;
                      //  count1<=0;
                        next_state=s14;
                    end
                    s14:begin
                         //Ain<=index1;
                         //Din<=ram[index1];
                         if(index1<8'b1111_1111)begin
                            next_state=s14;
                         end else
                            next_state=s15;
                    end
                    
                    
                    default: begin
                        next_state = s1;
                    end
                endcase    
             end
        end
  end

 
  
  always@(posedge clk )begin
        if(!rstn)begin
            busy2<=0;
            state<=InitState;
        end
       if(busy==0)begin
            if(s==0)begin
                d<=dpo;
            end else begin
                d<=nextd;
            end
            a<=nexta;
            state<=nextState;
            case(state)
                InitState:begin
                     we<=0;   
                end
                InState:begin
                   
                end
                ChkState:begin
                    
                end
                DelState:begin
               
                end
                DataState:begin
                    Ain<=a;
                    Din<=d;
                    we<=1;
                end
                AddrState:begin
                   
                end
                RunState:begin
                     we<=0;
                     Ain<=0;
                     busy2<=1;
                     index <=0;
                     sort_state <= s1;
                     state<=InitState;
                     count<=0;
              end
            endcase         
         end else begin
              count<=count+1;
              case(sort_state)
                       
                        s1:begin
                            sort_state<=next_state;
                        end
                        s2:begin
                           
                           ram[index]<=spo;
                           index<=index+1'b1;
                           sort_state<=next_state;
                        end
                        s3:begin
                            Ain<=index;
                            sort_state<=next_state;
                        end
                        s4:begin
                            i<=0;
                            j<=0;
                            Ain<=0;
                            sort_state<=next_state;
                        end
                        s5:begin  
                            sort_state<=next_state;
                        end
                        s6:begin
                            min_index <= i;
                            j <= i + 1;
                            sort_state<=next_state;
                        end
                        s7:begin  
                            sort_state<=next_state;
                        end
                        s8:begin  
                            sort_state<=next_state;
                        end
                        s9:begin
                             min_index <= j;
                             sort_state<=next_state;
                        end
                        s10:begin
                            j <= j + 1;
                            sort_state<=next_state;
                        end
                        s11:begin
                            
                            ram[min_index] <= ram[i];
                            ram[i] <= ram[min_index];
                            sort_state<=next_state;
                        end
                        s12:begin
                            i<= i + 1;
                            sort_state<=next_state;
                        end
                        s13:begin
                            we<=1;
                            index1<=0;
                            sort_state<=next_state;
                        end
                        s14:begin
                             index1<=index1+1'b1;
                             Ain<=index1;
                             Din<=ram[index1];
                             sort_state<=next_state;
                        end
                        s15:begin
                            index1<=0;
                              we<=0;
                              busy2<=0;
                              state<=InitState; 
                        end
                       
                        default:begin
                             sort_state <= next_state;  
                        end
             endcase
         end
     
  end

endmodule
