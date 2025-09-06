// ===================== 时钟与复位模块 =====================
module CLK_RST(
    input iCLK_50,
    input iRst,       // 假设硬件复位为低有效
    output reg oRst,  // 系统高有效复位
    output cClk_VGA,
    output cClk_dbg
);
    // 增加复位信号极性转换
    always @(*) begin
        oRst = ~iRst; // 将低有效转换为高有效
    end
    
    MY_PLL MY_PLL_inst (
        .inclk0(iCLK_50),
        .c0(cClk_VGA),
        .c1(cClk_dbg)
    );
endmodule

// ===================== VGA时序生成模块 =====================
module VGA_HVCnt(
    input iPixclk,
    input iRst,
    output reg oHs,
    output reg oVs,
    output reg [9:0] oCoord_X,
    output reg [9:0] oCoord_Y
);
    // 修正后的时序参数（单位：像素时钟周期）
    parameter H_SYNC   = 10'd96;   // 行同步脉冲
    parameter H_BACK   = 10'd48;   // 行后沿
    parameter H_ACTIVE = 10'd640;  // 行有效像素
    parameter H_FRONT  = 10'd16;   // 行前沿
    parameter H_TOTAL  = H_SYNC + H_BACK + H_ACTIVE + H_FRONT; // 800
    
    parameter V_SYNC   = 10'd2;    // 场同步脉冲
    parameter V_BACK   = 10'd33;   // 场后沿
    parameter V_ACTIVE = 10'd480;  // 场有效行
    parameter V_FRONT  = 10'd10;   // 场前沿
    parameter V_TOTAL  = V_SYNC + V_BACK + V_ACTIVE + V_FRONT; // 525
    
    reg [9:0] h_cnt; // 行计数器 (0-799)
    reg [9:0] v_cnt; // 场计数器 (0-524)

    // 行计数器逻辑（修正时序顺序）
    always @(posedge iPixclk or negedge iRst) begin
        if(!iRst) begin
            h_cnt <= 0;
            oHs <= 1'b0;
        end else begin
            if(h_cnt < H_TOTAL-1) h_cnt <= h_cnt + 1;
            else h_cnt <= 0;
            
            // 生成行同步信号（低有效）
            oHs <= (h_cnt < H_SYNC) ? 1'b0 : 1'b1;
        end
    end

    // 场计数器逻辑（修正触发条件）
    always @(posedge iPixclk or negedge iRst) begin
        if(!iRst) begin
            v_cnt <= 0;
            oVs <= 1'b0;
        end else begin
            if(h_cnt == H_TOTAL-1) begin // 仅在行结束时递增
                if(v_cnt < V_TOTAL-1) v_cnt <= v_cnt + 1;
                else v_cnt <= 0;
            end
            
            // 生成场同步信号（低有效）
            oVs <= (v_cnt < V_SYNC) ? 1'b0 : 1'b1;
        end
    end

    // 有效坐标生成逻辑（修正边界条件）
    always @(posedge iPixclk) begin
        // X坐标计算（严格时序顺序）
        if((h_cnt >= H_SYNC + H_BACK) && 
           (h_cnt < H_SYNC + H_BACK + H_ACTIVE)) 
        begin
            oCoord_X <= h_cnt - (H_SYNC + H_BACK);
        end else begin
            oCoord_X <= 10'h3FF; // 无效坐标标记
        end
        
        // Y坐标计算（需行结束确认）
        if((v_cnt >= V_SYNC + V_BACK) && 
           (v_cnt < V_SYNC + V_BACK + V_ACTIVE) &&
           (h_cnt == H_TOTAL-1)) 
        begin
            oCoord_Y <= v_cnt - (V_SYNC + V_BACK);
        end else if(h_cnt == H_TOTAL-1) begin
            oCoord_Y <= 10'h3FF; // 行结束时更新无效标记
        end
    end
endmodule


// ===================== D/A接口模块 =====================
module DA_IF(
    input iPixclk,
    input iHs,
    input iVs,
    input [23:0] iRGB,
    output [7:0] oRed,
    output [7:0] oGreen,
    output [7:0] oBlue,
    output oVGA_SYNC_N,
    output oVGA_BLANK_N
);
    // 同步信号处理
    assign oVGA_SYNC_N = 1'b0;    // 同步信号常低
    assign oVGA_BLANK_N = iHs & iVs; // 有效显示区域
    
    // RGB分量分离
    assign oRed   = iRGB[23:16];  // R分量
    assign oGreen = iRGB[15:8];   // G分量
    assign oBlue  = iRGB[7:0];    // B分量
endmodule

module VGA_cb(
    input iCLK_50,
    input iKEY,          // 低有效复位按键
    output oVGA_HS,
    output oVGA_VS,
    output oVGA_BLANK_N,
    output oVGA_SYNC_N,
    output [7:0] oVGA_R,
    output [7:0] oVGA_G,
    output [7:0] oVGA_B
);
    wire VGA_CLK;
    wire [9:0] coord_X;
    wire [9:0] coord_Y;
    wire [23:0] vga_rgb;
    wire vga_hs, vga_vs;
    wire sys_rst;

    CLK_RST clk_gen(
        .iCLK_50(iCLK_50),
        .iRst(iKEY),     // 传入低有效
        .oRst(sys_rst),  // 转换为高有效
        .cClk_VGA(VGA_CLK),
        .cClk_dbg()
    );

    VGA_HVCnt vga_timing(
        .iPixclk(VGA_CLK),
        .iRst(sys_rst),
        .oHs(vga_hs),
        .oVs(vga_vs),
        .oCoord_X(coord_X),
        .oCoord_Y(coord_Y)
    );

    VGA_Chessboard chessboardccb(
        .iPixclk(VGA_CLK),
        .iRst(sys_rst),
        .iCoord_X(coord_X),
        .iCoord_Y(coord_Y),
        .oRGB(vga_rgb)
    );

    DA_IF vga_dac(
        .iPixclk(VGA_CLK),
        .iHs(vga_hs),
        .iVs(vga_vs),
        .iRGB(vga_rgb),
        .oRed(oVGA_R),
        .oGreen(oVGA_G),
        .oBlue(oVGA_B),
        .oVGA_SYNC_N(oVGA_SYNC_N),
        .oVGA_BLANK_N(oVGA_BLANK_N)
    );

    assign oVGA_HS = vga_hs;
    assign oVGA_VS = vga_vs;
endmodule
// ===================== 国际象棋棋盘生成模块 =====================
module VGA_Chessboard(
    input iPixclk,
    input iRst,
    input [9:0] iCoord_X,
    input [9:0] iCoord_Y,
    output reg [23:0] oRGB
);
    // 棋盘参数
    localparam BOARD_X_START = 80;    // 水平起始位置
    localparam BOARD_Y_START = 0;     // 垂直起始位置
    localparam SQUARE_SIZE   = 60;    // 格子尺寸
    localparam BOARD_X_END   = 560;   // 水平结束位置（80+480）
    localparam BOARD_Y_END   = 480;   // 垂直结束位置

    // 有效坐标判断
    wire valid_coord = (iCoord_X < 640) && (iCoord_Y < 480);
    
    // 棋盘区域判断
    wire in_board;
    assign in_board = valid_coord && 
                     (iCoord_X >= BOARD_X_START) && 
                     (iCoord_X < BOARD_X_END) &&
                     (iCoord_Y >= BOARD_Y_START) && 
                     (iCoord_Y < BOARD_Y_END);
    
    // 相对坐标计算
    wire [9:0] x_rel = iCoord_X - BOARD_X_START;
    wire [9:0] y_rel = iCoord_Y - BOARD_Y_START;
    
    // 棋盘格坐标计算
    wire [3:0] x_block = x_rel / SQUARE_SIZE; // 0-7
    wire [3:0] y_block = y_rel / SQUARE_SIZE; // 0-7
    
    // 棋盘格颜色模式（异或生成黑白交替）
    wire checker_pattern = x_block[0] ^ y_block[0];
    
    // 颜色生成逻辑
    always @(posedge iPixclk) begin
        if (!iRst) begin
            oRGB <= 24'h0;
        end else begin
            if (in_board) begin
                oRGB <= checker_pattern ? 24'h000000 : 24'hFFFFFF;
            end else if (valid_coord) begin
                oRGB <= 24'hFF0000; // 非棋盘区红色背景
            end else begin
                oRGB <= 24'h0;      // 消隐区黑色
            end
        end
    end
endmodule