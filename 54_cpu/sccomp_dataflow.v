`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/15 16:41:54
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow(
    input clk_in,		    //时钟(要求)
    input reset,		    //置位信号(要求)
    output [31:0] inst,	    //指令输出(要求)
    output [31:0] pc	    //pc输出(要求)
    );

	parameter DM_START = 32'h1001_0000;
	parameter PC_START = 32'h0040_0000;

	wire DM_E,DM_R,DM_W;

	wire [31:0] DM_rdata;
	wire [31:0] DM_wdata;
	wire [31:0] res;
	wire [1:0] opt;

    cpu sccpu(
        .clk(clk_in),
        .ena(1'b1),
		.rst(reset),
		.DM_E(DM_E),
		.DM_R(DM_R),
		.DM_W(DM_W),
		.inst(inst),
		.DM_rdata(DM_rdata),
		.opt(opt),
		.DM_wdata(DM_wdata),
		.pc_out(pc),
		.alu_out(res)
    );

	wire [31:0] IM_addr = pc - PC_START;

	my_imem imem(
		.addr(IM_addr[12:2]),
		.inst(inst)
	);

	wire [5:0] DM_addr = res - DM_START;
    
	my_dmem dmem(
		.clk(clk_in),
		.DM_E(DM_E),
		.DM_R(DM_R),
		.DM_W(DM_W),
		.opt(opt),
		.addr(DM_addr),
		.data_in(DM_wdata),
		.data_out(DM_rdata)
	);

endmodule
