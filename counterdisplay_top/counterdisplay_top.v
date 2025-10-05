module counterdisplay_top (KEY, SW, LEDG, HEX1, HEX0);//变模计数器
input [1:0]KEY; 
input [2:0]SW; 
output [3:0]LEDG; //绿色发光二极管
output [6:0]HEX0; //七段数字显示器0 
output [6:0]HEX1; //七段数字显示器1 
wire [3:0]BCD1, BCD0, Q; //中间变量
wire CP, CLR_, EN; //中间变量
assign CP=KEY[0]; //用KEY0作为CP 
assign CLR_=KEY[1]; //用KEY1作为CLR 
assign EN=SW[2]; //用sw2作为EN 
assign LEDG=Q; 
Var_Counter B0 (CP, CLR_,EN, SW, Q); //实例引用变模计数器子模块
_4bitBIN2bcd B1 (.Bin(Q), //实例引用子模块4bitBIN2bcd 
.BCD1 ( BCD1 ), // 4bitBIN2bed (Bin, BCD1,BCD0) 
.BCD0 ( BCD0 )); 
SEG7_LUT u0 (.os( HEX0 ), 
.id ( BCD0) ); 
SEG7_LUT u1 (BCD1, HEX1);
 endmodule 
//实例引用子模块SEG7LUT (oSEG,iDIG) /用显示器HEX0显示个位BCD数1/用显示器HEX1显示十位BCD数