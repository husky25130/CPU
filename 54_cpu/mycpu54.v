`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 21:30:41
// Design Name: 
// Module Name: my_cpu
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


module cpu(
	input clk,		        //时钟信号
	input ena,		          //使能信号
	input rst,		          //置位信号
	output DM_E,	            //使能信号
	output DM_R,	         //读信�?
	output DM_W,	         //写信�?
	input [31:0] inst,	    //指令
	input [31:0] DM_rdata,	    //读取的数�?
	output [31:0] DM_wdata, 	//输出的数�?
	output [31:0] pc_out,	    //输出pc
	output [31:0] alu_out,	    //输出alu
    output [1:0] opt        //位数
	);

	parameter PC_START = 32'h0040_0000;

	parameter	CAUSE_SYSCALL	= 5'b01000,
				CAUSE_BREAK		= 5'b01001,
				CAUSE_TEQ		= 5'b01101;


	// 拆分指令
	wire [5:0] my_op		= inst[31:26];
	wire [4:0] my_rs		= inst[25:21];
	wire [4:0] my_rt		= inst[20:16];
	wire [4:0] my_rd		= inst[15:11];
    
	wire [4:0] shamt	= inst[10:6];
	wire [5:0] func	= inst[5:0];
	wire [15:0] immediate	= inst[15:0];
	wire [25:0] addr	= inst[25:0];

		/*****R �?*******/
	wire ADD	= my_op == 6'b0 && func == 6'b100000;
	wire ADDU   = my_op == 6'b0 && func == 6'b100001;
	wire SUB	= my_op == 6'b0 && func == 6'b100010;
	wire SUBU   = my_op == 6'b0 && func == 6'b100011;
	wire AND	= my_op == 6'b0 && func == 6'b100100;
	wire OR		= my_op == 6'b0 && func == 6'b100101;
	wire XOR	= my_op == 6'b0 && func == 6'b100110;
	wire NOR	= my_op == 6'b0 && func == 6'b100111;
	wire SLT	= my_op == 6'b0 && func == 6'b101010;
	wire SLTU	= my_op == 6'b0 && func == 6'b101011;
	wire SLL	= my_op == 6'b0 && func == 6'b000000;
	wire SRL	= my_op == 6'b0 && func == 6'b000010;
	wire SRA	= my_op == 6'b0 && func == 6'b000011;
	wire SLLV	= my_op == 6'b0 && func == 6'b000100;
	wire SRLV	= my_op == 6'b0 && func == 6'b000110;
	wire SRAV	= my_op == 6'b0 && func == 6'b000111;
	wire JR		= my_op == 6'b0 && func == 6'b001000;

		/*****I �?*******/
	wire ADDI	= my_op == 6'b001000;
	wire ADDIU	= my_op == 6'b001001;
	wire ANDI	= my_op == 6'b001100;
	wire ORI	= my_op == 6'b001101;
	wire XORI	= my_op == 6'b001110;
	wire LUI	= my_op == 6'b001111;
	wire LW		= my_op == 6'b100011;
	wire SW		= my_op == 6'b101011;
	wire BEQ	= my_op == 6'b000100;
	wire BNE	= my_op == 6'b000101;
	wire SLTI	= my_op == 6'b001010;
	wire SLTIU	= my_op == 6'b001011;

		/*****J �?*******/
	wire J		= my_op == 6'b000010;
	wire JAL	= my_op == 6'b000011;

	// 23 expansion
	wire DIV	= my_op == 6'b000000 && func == 6'b011010;
	wire DIVU	= my_op == 6'b000000 && func == 6'b011011;
	wire MUL	= my_op == 6'b011100 && func == 6'b000010;
	wire MULTU	= my_op == 6'b000000 && func == 6'b011001;
	wire BGEZ	= my_op == 6'b000001;
	wire JALR	= my_op == 6'b000000 && func == 6'b001001;
	wire LBU	= my_op == 6'b100100;
	wire LHU	= my_op == 6'b100101;
	wire LB		= my_op == 6'b100000;
	wire LH		= my_op == 6'b100001;
	wire SB		= my_op == 6'b101000;
	wire SH		= my_op == 6'b101001;
	wire BREAK	= my_op == 6'b000000 && func == 6'b001101;
	wire SYSCALL= my_op == 6'b000000 && func == 6'b001100;
	wire ERET	= my_op == 6'b010000 && func == 6'b011000;
	wire MFHI	= my_op == 6'b000000 && func == 6'b010000;
	wire MFLO	= my_op == 6'b000000 && func == 6'b010010;
	wire MTHI	= my_op == 6'b000000 && func == 6'b010001;
	wire MTLO	= my_op == 6'b000000 && func == 6'b010011;
	wire MFC0	= my_op == 6'b010000 && my_rs == 5'b00000;// && func == 6'b000000;
	wire MTC0	= my_op == 6'b010000 && my_rs == 5'b00100;// && func == 6'b000000;
	wire CLZ	= my_op == 6'b011100 && func == 6'b100000;
	wire TEQ	= my_op == 6'b000000 && func == 6'b110100;

	// ALU标志�?
	wire zero, carry, negative, overflow;

	// 数据选择器信�?
	wire M1		= (BEQ && zero) || (BNE && !zero) || (BGEZ && !negative);
	wire M2		= J || JAL;
	wire M3		= JR || JALR;
	wire M4		= JAL || JALR;//
	wire M5		= LW;
	wire M6		= SLL || SRL || SRA || SLLV || SRLV || SRAV;
	wire M7		= ADDI || ADDIU || ANDI || ORI || XORI || LW || SW || SLTI || SLTIU || LUI || LB || LBU || LH || LHU || SB || SH;
	wire M8		= ADDI || ADDIU || LW || SW || SLTI || SLTIU || LB || LBU || LH || LHU || SB || SH;//sign ext
	wire M9		= ADDI || ADDIU || ANDI || ORI || XORI || LUI || LW || SLTI || SLTIU || LBU || LHU || LB || LH || MFC0;
	wire M10	= SLL || SRL || SRA;
	wire M11	= ERET || BREAK;//图中M12
	wire M12	= MFHI;//图中M8，�?�择HI
	wire M13	= MUL;//图中M9，�?�择MUL
	// wire M14	= MUL || MULU;//M13 in pic
	wire M15	= MFHI || MFLO;
	wire M16	= LW || LB || LH || LBU || LHU;//else CLZ
	wire M17	= LBU || LHU;//zero ext
	wire M18	= LH || LHU;//load half
	// wire M19	= LB || LBU;//load byte
	wire M20	= CLZ;
	wire M21	= MFC0;

	wire [3:0] aluc;
	assign aluc[3] = SLT || SLTI || SLTU || SLTIU || SLL || SLLV || SRL || SRLV || SRA || SRAV || LUI;
	assign aluc[2] = AND || ANDI || OR || ORI || XOR || XORI || NOR || SLL || SLLV || SRL || SRLV || SRA || SRAV;
	assign aluc[1] = ADD || ADDI || SUB || BEQ || BNE || XOR || XORI || NOR || SLT || SLTI || SLTU || SLTIU || SLL || SLLV || BGEZ || TEQ || LW || SW || LBU || LHU || LB || LH || SB || SH;//
	assign aluc[0] = SUB || BEQ || BNE || SUBU || OR || ORI || NOR || SLT || SLTI || SRL || SRLV || BGEZ || TEQ;

	// pc
	reg [31:0] pc;
	wire [31:0] NPC	= pc + 4;
	assign pc_out = pc;

	// regs
	wire [4:0] addr_s = my_rs;
	wire [4:0] addr_t = my_rt;
	wire [4:0] addr_d = JAL ? 5'd31 : (M9 ? my_rt : my_rd);
	wire [31:0] data_d;
	wire [31:0] data_s;
	wire [31:0] data_t;
	wire RF_W = !(JR || SW || BEQ || BNE || J || DIV || DIVU || BGEZ || SB || SH || BREAK || SYSCALL || ERET || MTHI || MTLO || MTC0 || TEQ);//因为基本上都�?要往RF中写东西，故采用取反的方式简化代�?
	
	// CP0
	wire exception		= BREAK || SYSCALL || TEQ;
	wire [4:0] cause	= BREAK ? CAUSE_BREAK : (SYSCALL ? CAUSE_SYSCALL : (TEQ ? CAUSE_TEQ : 5'bz) );///是否是z�?
	wire [31:0] CP0_wdata	= data_t;
	wire [31:0] CP0_rdata;
	wire [31:0] status;
	wire [31:0] EPC;

	// ALU
	wire [31:0] ALU_A = M6 ? {27'b0,(M10 ? shamt : data_s[4:0])} : data_s;
	wire [31:0] ALU_B = M7 ? (M8 ? {{16{immediate[15]}},immediate} : {16'b0,immediate}) : (BGEZ ? 32'b0 : data_t);

	// div
	wire [31:0] div_lo, div_hi, divu_lo, divu_hi;
	wire div_busy, divu_busy;
	wire busy = div_busy | divu_busy;

	// mul, multu
	wire [31:0] mul_out;
	wire [31:0] multu_hi, multu_lo;

	// lo, hi
	wire [31:0] lo_in = MTLO ? data_s : (MULTU ? multu_lo : (DIV ? div_lo : divu_lo));
	wire [31:0] hi_in = MTHI ? data_s : (MULTU ? multu_hi : (DIV ? div_hi : divu_hi));
	wire [31:0] lo_out, hi_out;
	wire HI_ENA = MULTU | DIV | DIVU | MTHI;
	wire LO_ENA = MULTU | DIV | DIVU | MTLO;

	// CLZ
	wire [31:0] clz_out;
	
	my_reg cpu_ref(
		.ena(ena),
		.rst(rst),
		.clk(clk),
		.RF_W(RF_W),
		.addr_d(addr_d),
		.addr_s(addr_s),
		.addr_t(addr_t),
		.data_d(data_d),
		.data_s(data_s),
		.data_t(data_t)
	);

	CP0 my_cp0(
		.clk(clk),
		.rst(rst),
		.mfc0(MFC0), // CPU instruction is Mfc0
		.mtc0(MTC0), // CPU instruction is Mtc0
		.pc(pc),
		.Rd(my_rd), // Specifies Cp0 register
		.wdata(CP0_wdata), // Data from GP register to replace CP0 register
		.exception(exception),
		.eret(ERET), // Instruction is ERET (Exception Return)
		.cause(cause),
		.rdata(CP0_rdata), // Data from CP0 register for GP register
		.status(status),
		.exc_addr(EPC)
	);

	my_alu alu(
		.a(ALU_A),
		.b(ALU_B),
		.aluc(aluc),
		.r(alu_out),
		.zero(zero),
		.carry(carry),
		.negative(negative),
		.overflow(overflow)
	);

	my_pc low(
		.clk(clk),
		.rst(rst),
		.ena(LO_ENA),
		.data_in(lo_in),
		.data_out(lo_out)
	);

	my_pc high(
		.clk(clk),
		.rst(rst),
		.ena(HI_ENA),
		.data_in(hi_in),
		.data_out(hi_out)
	);

	DIV my_div(
		.dividend(data_s), //被除�?
		.divisor(data_t), //除数
		.start(DIV & ~busy), //启动除法运算//start = is_div & ~busy
		.clock(clk),
		.reset(rst),
		.q(div_lo), //�?
		.r(div_hi), //余数
		.busy(div_busy) //除法器忙标志�?
	);

	DIVU my_divu(
		.dividend(data_s), //被除�?
		.divisor(data_t), //除数
		.start(DIVU & ~busy), //启动除法运算//start = is_div & ~busy
		.clock(clk),
		.reset(rst),
		.q(divu_lo), //�?
		.r(divu_hi), //余数
		.busy(divu_busy) //除法器忙标志�?
	);

	MUL my_mul(
		.clk(clk), 
		.reset(rst),
		.a(data_s),
		.b(data_t),
		.out(mul_out)
	);

	MULTU my_multu(
		.clk(clk), 
		.reset(rst),
		.a(data_s),
		.b(data_t),
		.high(multu_hi),
		.low(multu_lo)
	);

	my_clz my_clz(
		.in(data_s),
		.out(clz_out)
	);

	assign DM_E	= LW || SW || LBU || LHU || LB || LH || SB || SH;
	assign DM_R		= LW || LBU || LHU || LB || LH;
	assign DM_W		= SW || SB || SH;
	assign DM_wdata	= data_t;
	wire DM_32		= LW | SW;
	wire DM_16		= LW | SW | LH | LHU | SH;
	assign opt	= {DM_32, DM_16};

	always@(negedge clk or posedge rst)//negedge
	begin
		if(ena && rst)
			pc <= PC_START;
		else if(ena)
		begin
			pc <= busy ? pc : (M3 ? data_s : (M2 ? {pc[31:28],addr,2'b0} : (M1 ? NPC + {{14{immediate[15]}},immediate,2'b00} : (M11 ? EPC : NPC))));
		end
	end

	assign data_d = M4 ? NPC :
				// (M14 ? (M13 ? mul_out : mulu_out) : 
				(M13 ? mul_out : 
				(M15 ? (M12 ? hi_out : lo_out) : 
				(M16 ? (M5 ? DM_rdata : 
				(M18 ? {M17 ? 16'b0 : {16{DM_rdata[15]}},DM_rdata[15:0]} : 
				{M17 ? 24'b0 : {24{DM_rdata[7]}},DM_rdata[7:0]})) : 
				(M20 ? clz_out :
				(M21 ? CP0_rdata :
				alu_out)))));

endmodule
