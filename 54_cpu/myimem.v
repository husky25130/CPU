`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 21:30:41
// Design Name: 
// Module Name: my_imem
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


module my_imem(
    input [10:0] addr,	        //指令地址
    output [31:0] inst	        //指令数据
    );


    dist_mem_gen_0 imem(
        .a(addr),            // ip a
        .spo(inst)            //ip spo
    );
endmodule
