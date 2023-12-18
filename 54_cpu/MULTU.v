`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/22 10:49:40
// Design Name: 
// Module Name: MULTU
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


module MULTU(
    input clk, 
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [31:0] high,
    output [31:0] low
    );
    //申请寄存�?
        assign {high, low} = a * b;
    
endmodule