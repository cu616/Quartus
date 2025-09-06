module addr_cnt(//相位累加器
    input CPI,
    input [23:0] K,        // 扩展K到24位
    output reg [9:0] ROMaddr,
    output reg [23:0] Address // 相位累加器扩展为24位
);
    always @(posedge CPI) begin
        Address <= Address + K;
        ROMaddr <= Address[23:14]; // 取高10位作为ROM地址
    end
endmodule
