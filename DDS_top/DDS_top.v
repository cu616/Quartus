module DDS_top(
    input CLK_50,
    input RSTn,
    input [1:0] WaveSel,
    input [23:0] K_in,
    output reg [11:0] WaveValue,
    output [0:0] LEDG,
    output wire CLOCK_100,
    input KEY_inc,
    input KEY_dec,
    output [6:0] SEG,
    output [7:0] DIG
);
    wire [9:0] ROMaddr;
    wire [23:0] Address;
    wire [11:0] Qsine, Qsquare, Qtri;
    wire [23:0] K;
    
    // 频率显示模块
    display_driver display(
        .clk(CLOCK_100),
        .K(K),
        .SEG(SEG),
        .DIG(DIG)
    );
    
    // 按键处理模块
    key_handler keys(
        .clk(CLOCK_100),
        .rst_n(RSTn),
        .key_inc(KEY_inc),
        .key_dec(KEY_dec),
        .K(K)
    );
    // 原有模块实例化
    PLL100_CP PLL(.inclk0(CLK_50), .c0(CLOCK_100), .locked(LEDG[0]));
    
    addr_cnt phase_acc(
        .CPI(CLOCK_100),
        .K(K),
        .ROMaddr(ROMaddr),
        .Address(Address)
    );
    
    SineROM sine_rom(
        .address(ROMaddr),
        .clock(CLOCK_100),
        .q(Qsine)
    );
    
    squwave square_gen(
        .CPI(CLOCK_100),
        .RSTn(RSTn),
        .Address(Address),
        .Qsquare(Qsquare)
    );
    
    triwave tri_gen(
        .address(ROMaddr),
        .Qtri(Qtri)
    );
    
    // 波形选择逻辑
    always @(posedge CLOCK_100) begin
        case(WaveSel)
            2'b01: WaveValue <= Qsine;
            2'b10: WaveValue <= Qsquare;
            2'b11: WaveValue <= Qtri;
            default: WaveValue <= Qsine;
        endcase
    end
endmodule
module debounce(
    input clk,
    input key_in,
    output reg key_out
);
    reg [19:0] cnt;
    always @(posedge clk) begin
        if (key_in != key_out) begin
            if (&cnt) key_out <= key_in;
            else cnt <= cnt + 1;
        end 
        else cnt <= 0;
    end
endmodule
