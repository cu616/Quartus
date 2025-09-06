module squwave(
    input CPI,
    input RSTn,
    input [23:0] Address,   // 适配24位地址
    output reg [11:0] Qsquare
);
    always @(posedge CPI) begin
        if (!RSTn)
            Qsquare <= 12'h0000;
        else
            Qsquare <= Address[23] ? 12'h0000 : 12'hFFF; // 根据最高位判断
    end
endmodule