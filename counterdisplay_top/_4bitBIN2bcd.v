module _4bitBIN2bcd (Bin,BCD1,BCD0);//4位二进制转换成2位十进制
input [3:0] Bin;
output reg [3:0] BCD1, BCD0;
 always @ (Bin) 
begin 
{BCD1,BCD0}=8'h00;
if (Bin<10) begin 
BCD1=4'h0;
BCD0=Bin;end  
else begin BCD1=4'h1; BCD0=Bin-4'd10; 

end 
end endmodule