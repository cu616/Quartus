module display_driver(
    input clk,
    input [23:0] K,
    output [6:0] SEG,
    output [7:0] DIG
);
    reg [19:0] freq_hz;
    reg [23:0] digits_combined; // 组合后的数字信号
    
    always @(*) begin
        // 频率计算（示例值，实际需根据K与频率关系调整）
        freq_hz = K * 6; 
        
        // 分解各个数位并组合成24bit信号
        digits_combined[3:0]   = freq_hz % 10;         // 个位
        digits_combined[7:4]   = (freq_hz / 10) % 10;  // 十位
        digits_combined[11:8]  = (freq_hz / 100) % 10; // 百位
        digits_combined[15:12] = (freq_hz / 1000) % 10;// 千位
        digits_combined[19:16] = (freq_hz / 10000) % 10;  // 万位
        digits_combined[23:20] = (freq_hz / 100000) % 10; // 十万位
    end

    seg7_driver u_seg7(
        .clk(clk),
        .digits_combined(digits_combined),
        .SEG(SEG),
        .DIG(DIG)
    );
endmodule