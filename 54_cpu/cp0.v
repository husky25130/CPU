`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/15 15:49:52
// Design Name: 
// Module Name: cp0
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


module CP0(
input clk,
input rst,
input mfc0, // CPU指令Mfc0
input mtc0, // CPU指令Mtc0
input [31:0]pc,
input [4:0] Rd, // 指定CP0寄存器
input [31:0] wdata, // 数据从GP寄存器到CP0寄存器
input exception,
input eret, // 指令ERET (Exception Return)
input [4:0]cause,
input intr,
output [31:0] rdata, //数据从CP0寄存器到GP寄存器
output [31:0] status,
output reg timer_int,
output [31:0]exc_addr // 异常起始地址
);

	parameter	STA	= 12;
	parameter	CAU	= 13;
	parameter	EPC	= 14;

	reg [31:0] my_reg[0:31];

	assign status=my_reg[STA];

	always@(posedge clk or posedge rst)
	begin
		if(rst==1)
		begin
			my_reg[0]<=32'b0;
			my_reg[1]<=32'b0;
			my_reg[2]<=32'b0;
			my_reg[3]<=32'b0;
			my_reg[4]<=32'b0;
			my_reg[5]<=32'b0;
			my_reg[6]<=32'b0;
			my_reg[7]<=32'b0;
			my_reg[8]<=32'b0;
			my_reg[9]<=32'b0;
			my_reg[10]<=32'b0;
			my_reg[11]<=32'b0;
			my_reg[12]<={27'b0,5'b11111};
			my_reg[13]<=32'b0;
			my_reg[14]<=32'b0;
			my_reg[15]<=32'b0;
			my_reg[16]<=32'b0;
			my_reg[17]<=32'b0;
			my_reg[18]<=32'b0;
			my_reg[19]<=32'b0;
			my_reg[20]<=32'b0;
			my_reg[21]<=32'b0;
			my_reg[22]<=32'b0;
			my_reg[23]<=32'b0;
			my_reg[24]<=32'b0;
			my_reg[25]<=32'b0;
			my_reg[26]<=32'b0;
			my_reg[27]<=32'b0;
			my_reg[28]<=32'b0;
			my_reg[29]<=32'b0;
			my_reg[30]<=32'b0;
			my_reg[31]<=32'b0;

		end

		else if(mtc0==1)
		begin
			my_reg[Rd]<=wdata;
		end

		else if(exception==1)
		begin
			my_reg[STA]<=status<<5;
			my_reg[CAU]<={25'b0,cause,2'b0};
			my_reg[EPC]<=pc;
		end

		else if(eret==1)
		begin
			my_reg[STA]<=status>>5;
		end
	end

	assign rdata=(mfc0==1) ? my_reg[Rd]:32'bz;

	assign exc_addr=(eret==1) ? my_reg[EPC]:32'h00400004;
endmodule
