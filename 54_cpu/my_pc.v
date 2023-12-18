`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/15 16:31:31
// Design Name: 
// Module Name: my_pc
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


module my_pc(
	input clk,
	input rst,
	input ena,
	input [31:0] data_in,
	output reg [31:0] data_out
    );

	always@(negedge clk or posedge rst)  
	begin
		if(rst)
		begin
			data_out <= 32'b0;
		end

		else if(ena)
		begin
			data_out <= data_in;
		end
	end

endmodule
