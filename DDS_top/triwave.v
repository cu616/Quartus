module triwave(
    input [9:0] address,
    output reg [11:0] Qtri
);
    always @(*) begin
        if (address < 10'd512)
            Qtri = address * 8;         // 上升沿
        else
            Qtri = 12'hFFF - (address - 10'd512) * 8; // 下降沿
    end
endmodule
