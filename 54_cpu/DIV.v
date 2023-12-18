`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 13:36:49
// Design Name: 
// Module Name: DIV
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


module DIV(
    input [31:0] dividend,   //被除数
    input [31:0] divisor,    //除数
    input start,    //启动除法运算
    input clock,
    input reset,            //置0
    output [31:0] q,  //商
    output [31:0] r,   //除数
    output reg busy      //除法器忙标志位
    );
    
     wire ready;
     reg [5:0] count;
     reg [31:00] reg_q;
     reg [31:00] reg_r;
     reg [31:00] reg_b;
 
     wire [31:00] reg_rt;
 
     reg busy2,r_sign,sign;
 
     assign ready=~busy&busy2;
 
     wire [32:0] sub_add=r_sign?({reg_r,reg_q[31]}+{1'b0,reg_b}):({reg_r,reg_q[31]}-{1'b0,reg_b});
    
     assign reg_rt=r_sign?reg_r+reg_b:reg_r;
    
     assign r=dividend[31]?(~reg_rt+1):reg_rt;
     assign q=(divisor[31]^dividend[31])?(~reg_q+1):reg_q;
     
     always @(posedge clock or posedge reset)begin
     if(reset)
     begin
         count<=0;
         busy<=0;
         busy2<=0;
     end
     else 
     begin
         busy2<=busy;
         if(start)
         begin
             reg_r<=32'b0;
             r_sign<=0;
             if(dividend[31]==1) 
             begin
                 reg_q<=~dividend+1;
             end
             else 
             reg_q<=dividend;
 
             if(divisor[31]==1)
                 begin
                 reg_b<=~divisor+1;
                 end
              else 
                 reg_b<=divisor;
 
             count<=0;
             busy<=1;
         end
         else if(busy)
         begin
             reg_r<=sub_add[31:0];
             r_sign<=sub_add[32];
             reg_q<={reg_q[30:0],~sub_add[32]};
             count<=count+1;
             if(count==31)
             busy<=0;
         end
     end
     end    
    
    
endmodule
