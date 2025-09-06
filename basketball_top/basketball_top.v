module basketball_top(oSEG0,oSEG1,Alarm,nRST,nPAUSE,CLK_50);
//输入端口声明
input CLK_50;
//输入端口声明
input nRST, nPAUSE;
//输出端口声明
output Alarm;
//输出端口声明
output[6:0]oSEG0,oSEG1;
//中间变量
wire CLK_1Hz;
//中间变量//实例引用子模块 Divider50MHz
wire [3:0]TimerH, TimerL;
Divider50MHz U0(.CLK_50M(CLK_50),.nCLR(nRST),
//sw[0]
.CLK_1HzOut(CLK_1Hz));
//实例引用子模块 Basketbal1
Basketball U1(
.TimerH(TimerH),
.TimerL (TimerL),
//LEDG[0]//sw[o]
.Alarm(Alarm),
.nRST (nRST),
.nPAUSE (nPAUSE),
.CP(CLK_1Hz));
SEG7_LUT U2(
.os(oSEG0),
.id(TimerL));
SEG7_LUT U3 (
.os(oSEG1),
//sw[1]
//实例引用子模块 SEG7 LUT(例 3.6.3)
//实例引用子模块 SEG7 LUT(OSEG,1DIG)
.id(TimerH));
endmodule
