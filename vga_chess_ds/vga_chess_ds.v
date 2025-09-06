module vga_chess_ds (
    input wire clk,         // 输入时钟（25.175 MHz，用于640x480@60Hz）
    input wire rst,         // 复位信号
    output reg hsync,       // 行同步信号
    output reg vsync,       // 场同步信号
    output wire [2:0] rgb  // RGB输出（R, G, B各1位）
);

// 定义VGA时序参数
parameter H_DISPLAY = 640;  // 行显示周期
parameter H_FRONT  = 16;    // 行前沿
parameter H_SYNC   = 96;    // 行同步脉冲
parameter H_BACK   = 48;    // 行后沿
parameter H_TOTAL  = H_DISPLAY + H_FRONT + H_SYNC + H_BACK; // 800

parameter V_DISPLAY = 480;  // 场显示周期
parameter V_FRONT  = 10;    // 场前沿
parameter V_SYNC   = 2;     // 场同步脉冲
parameter V_BACK   = 33;    // 场后沿
parameter V_TOTAL  = V_DISPLAY + V_FRONT + V_SYNC + V_BACK; // 525

// 定义棋盘参数
localparam BOARD_SIZE  = 480;  // 棋盘大小
localparam SQUARE_SIZE = 60;   // 每个格子大小
localparam BOARD_X_START = (H_DISPLAY - BOARD_SIZE)/2; // 水平起始位置 (80)
localparam BOARD_X_END   = BOARD_X_START + BOARD_SIZE;  // 水平结束位置 (560)

// 定义颜色
localparam COLOR_BLACK  = 3'b000;
localparam COLOR_WHITE  = 3'b111;
localparam COLOR_BG     = 3'b100; // 背景颜色（红色）

// 行场计数器
reg [9:0] h_cnt;         // 行计数器（0-799）
reg [9:0] v_cnt;         // 场计数器（0-524）

// 同步信号生成
always @(posedge clk or posedge rst) begin
    if (rst) begin
        h_cnt <= 10'd0;
        v_cnt <= 10'd0;
    end else begin
        if (h_cnt == H_TOTAL - 1) begin
            h_cnt <= 10'd0;
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 10'd0;
            else
                v_cnt <= v_cnt + 1'b1;
        end else begin
            h_cnt <= h_cnt + 1'b1;
        end
    end
end

// 生成同步信号（负极性同步）
always @(*) begin
    hsync = ~((h_cnt >= H_DISPLAY + H_FRONT) && 
             (h_cnt < H_DISPLAY + H_FRONT + H_SYNC));
    vsync = ~((v_cnt >= V_DISPLAY + V_FRONT) && 
             (v_cnt < V_DISPLAY + V_FRONT + V_SYNC));
end

// 判断有效显示区域
wire valid_display = (h_cnt < H_DISPLAY) && (v_cnt < V_DISPLAY);

// 判断棋盘区域
wire in_board = (h_cnt >= BOARD_X_START) && 
               (h_cnt < BOARD_X_END) && 
               (v_cnt < BOARD_SIZE);

// 棋盘坐标计算
wire [9:0] board_x = h_cnt - BOARD_X_START; // 棋盘内X坐标（0-479）
wire [9:0] board_y = v_cnt;                 // 棋盘内Y坐标（0-479）

// 计算格子位置
wire [3:0] x_tile = board_x / SQUARE_SIZE; // X方向格子编号（0-7）
wire [3:0] y_tile = board_y / SQUARE_SIZE; // Y方向格子编号（0-7）

// 棋盘颜色逻辑（异或判断奇偶性）
wire color_sel = (x_tile[0] ^ y_tile[0]); // 奇偶性不同时为1
wire [2:0] board_color = color_sel ? COLOR_WHITE : COLOR_BLACK;

// 最终颜色输出
assign rgb = valid_display ? 
                (in_board ? board_color : COLOR_BG) : 
                COLOR_BLACK;

endmodule