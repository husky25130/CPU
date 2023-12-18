`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 22:34:55
// Design Name: 
// Module Name: MUL
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


module MUL(
    input clk, 
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [31:0] out
);
    wire [31:0] a1 = a[31] ? -a : a;
    wire [31:0] b1 = b[31] ? -b : b;

    wire [31:0] tmp = a1 * b1;

    assign out = a[31] == b[31] ? tmp : -tmp;

endmodule
