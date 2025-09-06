module Divider50MHz (CLK_50M, nCLR, CLK_1HzOut); 
parameter  N=25; 
//位宽:根据计数器的模来确定
parameter  CLK_Freq=50000000; //50MHz时钟输入
parameter OUT_Freq=1; //1Hz时钟输出
input nCLR, CLK_50M; //输入端口声明
output reg CLK_1HzOut; 
//输出端口及变量的数据类型声明
reg [N-1:0] Count_DIV; 
//内部节点，存放计数器的输出值
always @(posedge CLK_50M or negedge nCLR) begin 
if(! nCLR) begin 
CLK_1HzOut<=0; 
Count_DIV<=0; 
//输出信号被异步清零
//分频器的输出被异步清零
end 
else begin
 if (Count_DIV<(CLK_Freq/(2*OUT_Freq)-1))
 Count_DIV<=Count_DIV+1'b1; 
else begin Count_DIV <=0; 
CLK_1HzOut <=~CLK_1HzOut; end end 
end 
endmodule
