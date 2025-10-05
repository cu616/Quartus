
module Var_Counter (CP,CLR_,En,SW, Q); 
input CP,CLR_,En; 
input [1:0] SW; 
output reg [3:0]Q; 
always @ (posedge CP or negedge CLR_) 
begin 
if (~ CLR_) Q<=4'd0; 
else if (En) 
begin 
case (SW) 
2'b00:if(Q>=4'd5) 
Q<=4'd0; 
else Q<=Q+1'd1; 
2'b01:if (Q>=4'd7) 
Q<=4'd0; 
else Q<=Q+1'd1; 
2'b10:if (Q>=4'd9) 
Q<=4'd0; 
else Q<=Q+1'd1; 
2'b11:if (Q>=4'd14) 
Q<=4'd0; 
else Q<=Q+1'd1; 
endcase 
end 
else Q<=Q;
end 
endmodule
