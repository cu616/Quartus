//****************************************************************
// 文件名：stopwatch.v
// 功能：数字跑表，支持开始/暂停/继续/清零操作
//****************************************************************
module stopwatch(
    input clk,          // 50MHz时钟输入
    input rst_n,        // 低电平复位（系统复位）
    input key_r,        // R键（清零控制，低有效）
    input key_s,        // S键（启动/暂停，低有效）
    output  [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6 // 分钟高位（0-5）
);

// 分频参数（生成100Hz使能信号）
parameter DIVIDER = 500000; // 50MHz/100Hz = 500,000
parameter DEBOUNCE_CYCLES = 1000000; // 20ms消抖周期

// 状态定义
localparam IDLE      = 2'b00;
localparam RUNNING   = 2'b01;
localparam PAUSED_S  = 2'b10;
localparam PAUSED_R  = 2'b11;

reg [3:0] min_high; // 分钟高位（0-5）
reg [3:0] min_low; // 分钟低位（0-9）
reg [3:0] sec_high; // 秒钟高位（0-5）
reg [3:0] sec_low; // 秒钟低位（0-9）
reg [3:0] hsec_high;// 0.1秒高位（0-9）
reg [3:0] hsec_low  ;// 0.1秒低位（0-9）
reg [1:0] state, next_state;
reg [19:0] counter;
reg [19:0] debounce_r, debounce_s;

SEG7_LUT UL0(  
	.iDIG(hsec_low),
	.oSEG(HEX0)
);
SEG7_LUT UL1(  
	.iDIG(hsec_high),
	.oSEG(HEX1)
);
SEG7_LUT UL2(  
	.iDIG(sec_low),
	.oSEG(HEX2)
);
SEG7_LUT UL3(  
	.iDIG(sec_high),
	.oSEG(HEX3)
);
SEG7_LUT UL4(  
	.iDIG(min_low),
	.oSEG(HEX4)
);
SEG7_LUT UL5(  
	.iDIG(min_high),
	.oSEG(HEX5)
);

reg key_r_stable, key_s_stable;
reg key_r_prev, key_s_prev;
wire key_r_pressed, key_s_pressed;

// 时间寄存器（BCD格式）
reg [3:0] min_h, min_l;  // 0-59
reg [3:0] sec_h, sec_l;  // 0-59
reg [3:0] hsec_h, hsec_l;// 0-99

// 100Hz时钟使能
wire en_100hz = (counter == DIVIDER - 1);

// 分频计数器
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) counter <= 0;
    else counter <= (en_100hz) ? 0 : counter + 1;
end

// 按键消抖处理（R键）
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        debounce_r <= 0;
        key_r_stable <= 1;
    end else begin
        if (debounce_r < DEBOUNCE_CYCLES) debounce_r <= debounce_r + 1;
        else begin
            key_r_stable <= key_r;
            debounce_r <= 0;
        end
    end
end

// 按键消抖处理（S键）
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        debounce_s <= 0;
        key_s_stable <= 1;
    end else begin
        if (debounce_s < DEBOUNCE_CYCLES) debounce_s <= debounce_s + 1;
        else begin
            key_s_stable <= key_s;
            debounce_s <= 0;
        end
    end
end

// 按键边沿检测
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        key_r_prev <= 1;
        key_s_prev <= 1;
    end else begin
        key_r_prev <= key_r_stable;
        key_s_prev <= key_s_stable;
    end
end

assign key_r_pressed = (key_r_prev && !key_r_stable);
assign key_s_pressed = (key_s_prev && !key_s_stable);

// 状态转移逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= IDLE;
    else state <= next_state;
end

always @(*) begin
    case(state)
        IDLE: 
            next_state = (key_s_pressed) ? RUNNING : IDLE;
        
        RUNNING: begin
            if (key_s_pressed)      next_state = PAUSED_S;
            else if (key_r_pressed)  next_state = PAUSED_R;
            else                    next_state = RUNNING;
        end
        
        PAUSED_S: begin
            if (key_s_pressed)      next_state = RUNNING;
            else if (key_r_pressed) next_state = IDLE;
            else                    next_state = PAUSED_S;
        end
        
        PAUSED_R: begin
            if (key_r_pressed)     next_state = RUNNING;
            else                    next_state = PAUSED_R;
        end
        
        default: next_state = IDLE;
    endcase
end

// 时间计数逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {min_h, min_l, sec_h, sec_l, hsec_h, hsec_l} <= 24'd0;
    end else begin
        case(state)
            IDLE: // 清零所有计数器
                {min_h, min_l, sec_h, sec_l, hsec_h, hsec_l} <= 24'd0;
            
            RUNNING: if (en_100hz) begin
                // 处理0.01秒递增
                if (hsec_l < 9) hsec_l <= hsec_l + 1;
                else begin
                    hsec_l <= 0;
                    if (hsec_h < 9) hsec_h <= hsec_h + 1;
                    else begin
                        hsec_h <= 0;
                        // 处理秒递增
                        if (sec_l < 9) sec_l <= sec_l + 1;
                        else begin
                            sec_l <= 0;
                            if (sec_h < 5) sec_h <= sec_h + 1;
                            else begin
                                sec_h <= 0;
                                // 处理分钟递增
                                if (min_l < 9) min_l <= min_l + 1;
                                else begin
                                    min_l <= 0;
                                    if (min_h < 5) min_h <= min_h + 1;
                                    else min_h <= 5; // 保持最大值59
                                end
                            end
                        end
                    end
                end
            end
            
            default: ; // PAUSED状态保持当前值
        endcase
    end
end

// 输出连接
always @* begin
    min_high  = min_h;
    min_low   = min_l;
    sec_high  = sec_h;
    sec_low   = sec_l;
    hsec_high = hsec_h;
    hsec_low  = hsec_l;
end

endmodule