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
    input clk,	             //ʱ���ź�
    input DM_E,	             //ʹ���ź�
    input DM_R,	             //dmem���ź�
    input DM_W,	                //dmemд�ź�
    input [1:0] opt,            //bitλ
    input [5:0] addr,	    	//dmem���ݵ�ַ
    input [31:0] data_in,	    //��������
    output [31:0] data_out	    //�������
    
    );

   reg [7:0] mem [0:512];    //������ռ�     

 
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
  : 32'bz; //λ��

 endmodule


