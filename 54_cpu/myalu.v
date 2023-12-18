`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/11 19:10:39
// Design Name: 
// Module Name: alu
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


module my_alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    reg  [31:0] temp; 
    reg tmp1;
    reg tmp2;
 always@(*)   
 begin
    case(aluc)
    4'b0000:
    begin
     {carry, r} = $unsigned(a) + $unsigned(b);
     zero = (r == 0) ? 1 : 0 ; 
     negative = r[31];                                                                                                                                                                                                                                                
    end
    4'b0010:
    begin
     r = $signed(a) + $signed(b);
  
     overflow = ((a[31]==b[31]&&(~r[31]==a[31])))?1:0;
     negative = r[31];
     zero = (r == 0) ? 1 : 0 ;
    end
    4'b0001:
    begin
     {carry, r} = $unsigned(a)-$unsigned(b);
    zero = (r == 0) ? 1 : 0 ;    
    negative = r[31];
    end    
    4'b0011:
    begin
    
       
     temp = -b;
     //b = temp;
     r = $signed(a) - $signed(b);
    overflow = ((a[31]==0&&b[31]==1&&r[31]==1)||(a[31]==1&&b[31]==0&&r[31]==0))?1:0;
    negative = r[31];
    zero = (r == 0) ? 1 : 0 ;
    end    
    4'b0100:
    begin
    r = a & b;
    zero = (r == 0) ? 1 : 0 ;
    negative = r[31];
    end
    4'b0101:
    begin
    r = a | b;
    
    negative = r[31];
    zero = (r == 0) ? 1 : 0 ;
    end       
    4'b0110:
    begin
    r = a^b;
    negative = r[31];
    zero = (r == 0) ? 1 : 0 ;
    end
    4'b0111:
    begin
    r = ~(a | b);
    
    negative = r[31];
    zero = (r == 0) ? 1 : 0 ;
    end       
    4'b1000:
    begin
      r={b[15:0],16'b0};
      
      negative = r[31];
      zero = (r == 0) ? 1 : 0 ;
    end     
    4'b1001:
    begin
      r={b[15:0],16'b0};
      
     negative = r[31]; 
      zero = (r == 0) ? 1 : 0 ;
    end    
    4'b1011:
    begin    
      if(a[31]==1&&b[31]==0)
        r=1;
      else if(a[31]==0&&b[31]==1)
        r=0;
      else
           r = (a < b) ? 1 : 0 ;   //ÓÐ·ûºÅ
      negative = r;
      zero = (a==b) ? 1 : 0 ;
    end     
    4'b1010:
    begin
      r = (a < b) ? 1 : 0;   //ÎÞ·ûºÅ
      carry = r;
      negative = r[31];
     zero = (a==b) ? 1 : 0 ;
    end     
    4'b1100:
    begin
      if( a == 0)
         begin
         r=b;
         carry = 0;
         end  
         else
           begin
           r = $signed(b) >>> a-1;       
           carry = r[0];
           r = $signed(r) >>> 1;
            end
          negative = r[31];    
          zero = (r == 0) ? 1 : 0 ;
    end
    4'b1110:
    begin
      if( a == 0)
         begin
         r=b;
         carry = 0;
         end  
         else
           begin
           r = b<<a-1;       
           carry = r[31];
           r = r<<1;
            end
          negative = r[31];    
          zero = (r == 0) ? 1 : 0 ;
                      
    end     
    4'b1101:
    begin
      if( a == 0)
      begin
      r=b;
      carry = 0;
      end  
      else
        begin
        r = b>>a-1;       
        carry = r[0];
        r = r>>1;
         end
       negative = r[31];    
       zero = (r == 0) ? 1 : 0 ;                           
    end     
        4'b1111:
    begin
     if( a == 0)
     begin
     r=b;
     carry = 0;
     end  
     else
       begin
       r = b<<a-1;       
       carry = r[31];     
       r = r<<1;
        end
        negative = r[31];
      zero = (r == 0) ? 1 : 0 ;
    end                          
        default:;
    endcase
   // zero = (r == 32'b00000000_00000000) ? 1 : 0 ; 
end
endmodule
