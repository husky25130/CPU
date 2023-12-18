`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/27 09:58:34
// Design Name: 
// Module Name: DIVU
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


module DIVU(
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
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg busy2,r_sign;

    assign ready=~busy&busy2;

    wire [32:0] sub_add=r_sign?({reg_r,q[31]}+{1'b0,reg_b}):({reg_r,q[31]}-{1'b0,reg_b});
                                
    assign r=r_sign?reg_r+reg_b:reg_r;

    assign q=reg_q;
    
    always @(posedge clock or posedge reset)
    begin
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
            reg_q<=dividend;
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
