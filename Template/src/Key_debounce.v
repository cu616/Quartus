module Key_debounce(
    input clk,          // 50MHz时钟输入
    input Key,        // 低电平复位消抖，想高电平消抖自觉用~Key
    output reg key_stable  
);
parameter N=20;
parameter DEBOUNCE_CYCLES = 500000; // 默认值，接入50MHz时时长为10ms
reg [N-1:0] debounce_cnt;
always @(posedge clk or negedge Key) begin
    if (!Key) begin
        debounce_cnt <= 0;
        key_stable <= 1;
    end 
    else begin
        if (debounce_cnt < DEBOUNCE_CYCLES) debounce_cnt <= debounce_cnt + 1;
        else begin
            key_stable <= Key;
            debounce_cnt <= 0;
        end
    end
end
endmodule
