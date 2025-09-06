// 2选1数据选择器子模块
module _2to1MUX(
    input [7:0] X, Y,
    input SEL,
    output [7:0] OUT
);
    assign OUT = SEL ? X : Y;
endmodule

module DE2(
    output [0:0] GPIO,       // 用于外接扬声器驱动电路
    output [6:0] HEX0, HEX1,
    output [6:0] HEX2, HEX3,  // 显示秒钟个位和十位
    output [6:0] HEX4, HEX5,  // 显示分钟个位和十位
    output [6:0] HEX6, HEX7,  // 显示小时个位和十位
    input CLOCK_50,           // 50MHz时钟输入
    input [5:0] SW,           // 控制信号
    input [0:0] KEY           // 按键KEY0
);
    wire [31:0] iDIG;         // 七段显示译码器的输入

    Complete_Clock CLOCK_Inst(
        .LED_Hr(iDIG[31:24]),  // 小时（BCD码）
        .LED_Min(iDIG[23:16]), // 分钟（BCD码）
        .LED_Sec(iDIG[15:8]),  // 秒钟（BCD码）
        .ALARM(GPIO[0]),       // 输出至扬声器驱动电路
        .CLK_50(CLOCK_50),    // 50MHz输入
        .AdjMinkey(SW[0]),    // 校正分钟SW0
        .AdjHrkey(SW[1]),     // 校正小时SW1
        .SetHrkey(SW[2]),     // 设置闹钟的小时SW2
        .SetMinkey(SW[3]),    // 设置闹钟的分钟SW3
        .Mode(SW[4]),         // 显示模式SW4:0，正常计时；1，闹钟
        .nCR(KEY[0])          // 清零
    );

    assign HEX0=7'b1111111;    // 不使用（让其不显示）
    assign HEX1=7'b1111111;

    SEG_LUT Hex2(iDIG[11:8], HEX2);  // 显示秒钟个位
    SEG_LUT Hex3(iDIG[15:12], HEX3);  // 显示秒钟十位
    SEG_LUT Hex4(iDIG[19:16], HEX4);  // 显示分钟个位
    SEG_LUT Hex5(iDIG[23:20], HEX5);  // 显示分钟十位
    SEG_LUT Hex6(iDIG[27:24], HEX6);  // 显示小时个位
    SEG_LUT Hex7(iDIG[31:28], HEX7);  // 显示小时十位
endmodule

module Complete_Clock(
    input CLK_50, nCR,
    input AdjMinkey, AdjHrkey, // 校小时、校分钟
    input SetHrkey, SetMinkey, // 闹钟小时、分钟的设定值
    input CtrlBell, Mode,
    output ALARM,
    output [7:0] LED_Hr, LED_Min, LED_Sec
);

wire [7:0] Hour, Minute, Second;      // 小时、分钟、秒钟的输出值
wire [7:0] Set_Hr, Set_Min;
wire _1Hz, _500Hz, _1kHzIN;
wire ALARM_Clock;
wire ALARM_Radio;

// 分频器
CP_1kHz_500Hz_1Hz U0(
    .CLK_50(CLK_50),
    .CP_1kHz(_1kHzIN),
    .CP_500Hz(_500Hz),
    .CP_1Hz(_1Hz)
);

// 时钟主体电路（含计时和校时）
top_clock U1(
    .Hour(Hour),
    .Minute(Minute),
    .Second(Second),
    ._1Hz(_1Hz),
    .nCR(nCR),
    .AdjMinkey(AdjMinkey),
    .AdjHrkey(AdjHrkey)
);

// 仿广播电台报时
Radio U2(
    .ALARM_Radio(ALARM_Radio),
    .Minute(Minute),
    .Second(Second),
    ._1kHzIN(_1kHzIN),
    ._500Hz(_500Hz)
);

// 闹钟子模块
Bell U3(
    .ALARM_Clock(ALARM_Clock),
    .Set_Hr(Set_Hr),
    .Set_Min(Set_Min),
    .Hour(Hour),
    .Minute(Minute),
    .Second(Second),
    ._1kHzIN(_1kHzIN),
    ._500Hz(_500Hz),
    ._1Hz(_1Hz),
    .SetHrkey(SetHrkey),
    .SetMinkey(SetMinkey),
    .CtrlBell(CtrlBell)
);

// 控制扬声器子模块
assign ALARM = ALARM_Radio | ALARM_Clock;

// 选择数码管的显示内容（时钟/闹钟）
_2to1MUX MU1(
    .OUT(LED_Hr),
    .SEL(Mode),
    .X(Set_Hr),
    .Y(Hour)
);
_2to1MUX MU2(
    .OUT(LED_Min),
    .SEL(Mode),
    .X(Set_Min),
    .Y(Minute)
);
_2to1MUX MU3(
    .OUT(LED_Sec),
    .SEL(Mode),
    .X(8'hFF),
    .Y(Second)
);
endmodule

// 分频器模块
module CP_1kHz_500Hz_1Hz(
    input CLK_50, nRST,
    output CP_1kHz, CP_500Hz, CP_1Hz
);
    Divider50MHz U0(
        .CLK_50M(CLK_50),
        .nCLR(nRST),
        .CLK_1HzOut(CP_1Hz)
    );
    defparam U0.N=25;
    defparam U0.CLK_Freq=50000000;
    defparam U0.OUT_Freq=1;

    Divider50MHz U1(
        .CLK_50M(CLK_50),
        .nCLR(nRST),
        .CLK_1HzOut(CP_500Hz)
    );
    defparam U1.N=16;
    defparam U1.CLK_Freq=50000000;
    defparam U1.OUT_Freq=500;

    Divider50MHz U2(
        .CLK_50M(CLK_50),
        .nCLR(nRST),
        .CLK_1HzOut(CP_1kHz)
    );
    defparam U2.N=15;
    defparam U2.CLK_Freq=50000000;
    defparam U2.OUT_Freq=1000;
endmodule

// 仿广播电台正点报时模块
module Radio(
    input _1kHzIN, _500Hz,
    input [7:0] Minute, Second,
    output reg[7:0]  ALARM_Radio
);
    always @(Minute, Second)
    begin
        if (Minute == 8'h59)
            case (Second)
                8'h51, 8'h53, 8'h55, 8'h57, 8'h59:
                    ALARM_Radio = _1kHzIN;
                default:
                    ALARM_Radio = 1'b0;
            endcase
        else
            ALARM_Radio = 1'b0;
    end
endmodule

// 定时闹钟模块
module Bell(
    input _1kHzIN, _500Hz, _1Hz, SetHrkey, SetMinkey, CtrlBell,
    input [7:0] Hour, Minute, Second,
    output ALARM_Clock,
    output [7:0] Set_Hr, Set_Min
);
    supply1 Vdd;
    wire Hrh_EQU, HrL_EQU, Minh_EQU, MinL_EQU;
    wire Time_EQU;

    // 闹钟分钟设置
    counter60 SU1(
        .Cnt(Set_Min),
        .nCR(Vdd),
        .En(SetMinkey),
        .CP(_1Hz)
    );

    // 闹钟小时设置
    counter24 SU2(
        .CntH(Set_Hr[7:4]),
        .CntL(Set_Hr[3:0]),
        .nCR(Vdd),
        .EN(SetHrkey),
        .CP(_1Hz)
    );

    // 比较闹钟的设定时间和数字钟当前时间是否相等
    _4bitcomparator SU4(Hrh_EQU, Set_Hr[7:4], Hour[7:4]);
    _4bitcomparator SU5(HrL_EQU, Set_Hr[3:0], Hour[3:0]);
    _4bitcomparator SU6(Minh_EQU, Set_Min[7:4], Minute[7:4]);
    _4bitcomparator SU7(MinL_EQU, Set_Min[3:0], Minute[3:0]);

    assign Time_EQU = (Hrh_EQU & HrL_EQU & Minh_EQU & MinL_EQU);
    assign ALARM_Clock = CtrlBell ? (Time_EQU && ((Second[0] == 1'b1) && _500Hz) || ((Second[0] == 1'b0) && _1kHzIN)) : 1'b0;
endmodule

// 4位比较器模块
module _4bitcomparator(EQU, A, B);
    input [3:0] A, B;
    output EQU;
    assign EQU = (A == B);
endmodule

// 模60计数器
module counter60(
    input CP, nCR, En,
    output [7:0] Cnt
);
    reg [3:0] Q;
    always @(posedge CP or negedge nCR)
    begin
        if (~nCR)
            Q <= 4'b0000;
        else if (~En)
            Q <= Q;
        else if (Q == 4'b1011)
            Q <= 4'b0000;
        else
            Q <= Q + 1'b1;
    end
    assign Cnt = {Q[3:0], Q[3:0]};
endmodule

// 模24计数器
module counter24(
    input CP, nCR, EN,
    output reg [3:0] CntH, CntL
);
    always @(posedge CP or negedge nCR)
    begin
        if (~nCR)
            {CntH, CntL} <= 8'h00;
        else if (~EN)
            {CntH, CntL} <= {CntH, CntL};
        else if ((CntH > 2) || ((CntH == 2) && (CntL > 3)))
            {CntH, CntL} <= 8'h00;
        else if ((CntH == 2) && (CntL < 3))
            begin CntH <= CntH; CntL <= CntL + 1'b1;end
        else if (CntL == 9)
            begin CntH <= CntH + 1'b1;CntL <= 4'h0;end
        else
            begin CntH <= CntH;CntL <= CntL + 1'b1;end
    end
endmodule

// 数字钟主体电路
module top_clock(
    input _1Hz, nCR, AdjMinkey, AdjHrkey,
    output [7:0] Hour, Minute, Second
);
    supply1 Vdd;
    wire MinCP, HrCP;

    // 时分秒计数器
    counter60 UT1(
        .Cnt(Second),
        .nCR(nCR),
        .En(Vdd),
        .CP(_1Hz)
    );
    counter60 UT2(
        .Cnt(Minute),
        .nCR(nCR),
        .En(Vdd),
        .CP(MinCP)
    );
    counter24 UT3(
        .CntH(Hour[7:4]),
        .CntL(Hour[3:0]),
        .nCR(nCR),
        .EN(Vdd),
        .CP(HrCP)
    );

    // 分钟计数器时钟
    assign MinCP = AdjMinkey ? _1Hz : (Second == 8'h59);
    // 小时计数器时钟
    assign HrCP = AdjHrkey ? _1Hz : (Minute == 8'h59);
endmodule
module SEG_LUT(  
	input [3:0]iDIG,
	output reg[6:0]oSEG
);
always@(iDIG)
begin
case(iDIG)
4'b0000:oSEG=7'b100_0000;
4'b0001:oSEG=7'b111_1001;
4'b0010:oSEG=7'b010_0100;
4'b0011:oSEG=7'b011_0000;
4'b0100:oSEG=7'b001_1001;
4'b0101:oSEG=7'b001_0010;
4'b0110:oSEG=7'b000_0010;
4'b0111:oSEG=7'b111_1000;
4'b1000:oSEG=7'b000_0000;
4'b1001:oSEG=7'b001_1000;
endcase
end
endmodule