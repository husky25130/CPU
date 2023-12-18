`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 21:30:41
// Design Name: 
// Module Name: my_dmem
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


module my_dmem(
    input clk,	             //时钟信号
    input DM_E,	             //使能信号
    input DM_R,	             //dmem读信号
    input DM_W,	                //dmem写信号
    input [1:0] opt,            //bit位
    input [5:0] addr,	    	//dmem数据地址
    input [31:0] data_in,	    //输入数据
    output [31:0] data_out	    //输出数据
    
    );

   reg [7:0] mem [0:512];    //开个大空间     

 
 always@(posedge clk)
 begin
     if(DM_W && DM_E)
     begin
         mem[addr] <= data_in[7:0];
         if(opt[0])
         begin
             mem[addr+1] <= data_in[15:8];
         end
         
         if(opt[1])
         begin
             mem[addr+2] <= data_in[23:16];
             mem[addr+3] <= data_in[31:24];
         end
     end
 end

 assign data_out = (DM_E && DM_R) ?
  {(opt[1] ? {mem[addr+3],mem[addr+2]} : 16'b0),
   (opt[0] ? mem[addr+1] : 8'b0),
    mem[addr]}   
  : 32'bz; //位数

 endmodule


