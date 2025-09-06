module key_handler(
    input clk,
    input rst_n,
    input key_inc,
    input key_dec,
    output reg [23:0] K
);
    parameter MIN_K = 24'd1;       // 10Hz对应K值
    parameter MAX_K = 24'hFFFFFF;  // 10MHz对应K值
    
    // 按键消抖逻辑
    wire inc_pulse, dec_pulse;
    debounce deb_inc(.clk(clk), .key_in(key_inc), .key_out(inc_pulse));
    debounce deb_dec(.clk(clk), .key_in(key_dec), .key_out(dec_pulse));
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            K <= MIN_K;
        end else begin
            case({inc_pulse, dec_pulse})
                2'b10: K <= (K < MAX_K) ? K + 1 : K;
                2'b01: K <= (K > MIN_K) ? K - 1 : K;
                default: K <= K;
            endcase
        end
    end
endmodule
