//十字路口交通灯
`define S0 2'b00//GREEN RED
`define S1 2'b01//YELLOW RED
`define S2 2'b11//RED GREEN
`define S3 2'b10//RED YELLOW
module controller(
input CLK,RESET,
input S,//支干道有人时为1
output reg HG,HY,HR,FG,FY,FR,//H为主干道，F为支干道；GYR为绿黄红灯
output [6:0]HEX0,HEX1);
reg[3:0]TimerH, TimerL;
reg St;//状态转换标识
wire CLK_1HzOut;
wire T1,Ts,Ty;//亮灯时间
//状态转换
reg[1:0]CurrentState,NextState;//FSM状态触发器

Divider50MHz u1(.CLK_50M(CLK), .nCLR(RESET), .CLK_1HzOut(CLK_1HzOut)); 
defparam u1.OUT_Freq=8;
 
SEG7_LUT u2(.id(TimerL),
.os(HEX0[6:0])
);
SEG7_LUT u3(.id(TimerH),
.os(HEX1[6:0]));

always @(posedge CLK_1HzOut,negedge RESET )
begin//:counter
if (~RESET) {TimerH,TimerL}=8'b0;
else if(St) {TimerH, TimerL}=8'b0;
else if((TimerH==5)&(TimerL==9)) begin{TimerH,TimerL}={TimerH,TimerL};end
else if(TimerL==9) begin TimerH=TimerH+1;TimerL=0;end
else
begin TimerH=TimerH;TimerL=TimerL+1;end
end

//Ty,Ts,T1对应主干道绿灯最长时间、支干道绿灯最短时间、黄灯默认时间，记到临界值时信号为1
assign Ty = (TimerH == 0) & (TimerL == 4);
assign Ts = (TimerH == 2) & (TimerL == 9);
assign T1 = (TimerH == 5) & (TimerL == 9);


always @(posedge CLK_1HzOut,negedge RESET )
begin:statereg
if(~RESET)CurrentState<=`S0;
else CurrentState<=NextState;
end//FSM组合逻辑

always @(S or CurrentState or T1 or Ts or Ty)
begin//:fsm
case(CurrentState)//S0是用define定义的，在引用时要加右撒号
`S0:begin
NextState=(T1&&S)?`S1 :`S0;
St=(T1&& S)? 1:0;
end 
`S1: begin
NextState=(Ty)?`S2:`S1;
St=(Ty)? 1:0;
end
`S2: begin NextState=(Ts||~S)?`S3 :`S2;
 St=(Ts||~S)? 1:0;
end
`S3:begin
NextState=(Ty)?`S0 :`S3;
St=(Ty)?1:0;
end
endcase
end

//fsm
always @(CurrentState)
begin
case(CurrentState)
`S0:begin
	{HG,HY,HR}=3'b100;
	{FG,FY,FR}=3'b001;
end
`S1:begin
	{HG,HY,HR}=3'b010;
	{FG,FY,FR}=3'b001;
end
`S2:begin
	{HG,HY,HR}=3'b001;
	{FG,FY,FR}=3'b100;
end
`S3:begin
	{HG,HY,HR}=3'b001;
	{FG,FY,FR}=3'b010;
end
endcase
end
endmodule
