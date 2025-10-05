module mux2to1(
input D0, //输入信号 D0
input D1, //输入信号 D1
input S, //输入选择信号 S
output reg Y //输出信号 Y
); 
 
/*电路功能描述
 1.(*)表示 always 块中所有输入信号都是敏感信号
 2.Y 必须定义成 reg 型
*/
//Y:2 选 1 数据选择器输出数据
always @(*)begin
if(S == 1'b1)//or: if (S) Y = D1;
Y = D1;
else
Y = D0;
end
endmodule