`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 21:30:41
// Design Name: 
// Module Name: my_reg
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


module my_reg(
    input ena,       	//ʹ���ź�
    input rst,       	//��λ�źţ��ߵ�ƽ��Ч
    input clk,       	//ʱ���ź�
    input RF_W,		        //д��Ч�ź�
    input [4:0] addr_d,        	//Rd�ĵ�ַ
    input [4:0] addr_s,	        //Rs�ĵ�ַ
    input [4:0] addr_t,	        //Rt�ĵ�ַ
    input [31:0] data_d,        	//Rd����
    output [31:0] data_s,       	//Rs����
    output [31:0] data_t	        //Rt����
    );
	
    reg [31:0] array_reg[31:0];      //Ҫ��

    always@(negedge clk or posedge rst)
    begin
        if(rst && ena)
        begin
            array_reg[0] <= 32'b0;
            array_reg[1] <= 32'b0;
            array_reg[2] <= 32'b0;
            array_reg[3] <= 32'b0;
            array_reg[4] <= 32'b0;
            array_reg[5] <= 32'b0;
            array_reg[6] <= 32'b0;
            array_reg[7] <= 32'b0;
            array_reg[8] <= 32'b0;
            array_reg[9] <= 32'b0;
            array_reg[10] <= 32'b0;
            array_reg[11] <= 32'b0;
            array_reg[12] <= 32'b0;
            array_reg[13] <= 32'b0;
            array_reg[14] <= 32'b0;
            array_reg[15] <= 32'b0;
            array_reg[16] <= 32'b0;
            array_reg[17] <= 32'b0;
            array_reg[18] <= 32'b0;
            array_reg[19] <= 32'b0;
            array_reg[20] <= 32'b0;
            array_reg[21] <= 32'b0;
            array_reg[22] <= 32'b0;
            array_reg[23] <= 32'b0;
            array_reg[24] <= 32'b0;
            array_reg[25] <= 32'b0;
            array_reg[26] <= 32'b0;
            array_reg[27] <= 32'b0;
            array_reg[28] <= 32'b0;
            array_reg[29] <= 32'b0;
            array_reg[30] <= 32'b0;
            array_reg[31] <= 32'b0;
        end
        else if(RF_W && ena && addr_d != 5'b0) //
            array_reg[addr_d] <= data_d;
    end

    assign data_s = ena ? array_reg[addr_s] : 32'bz;
    assign data_t = ena ? array_reg[addr_t] : 32'bz;

endmodule

