module seg7_driver(
    input clk,
    input [23:0] digits_combined, // 使用压缩数组传递6个数字（每个4bit）
    output reg [6:0] SEG,
    output reg [7:0] DIG
);
    reg [2:0] cnt = 0;
    reg [3:0] current_digit;
    
    // 将组合信号转换为数组
    wire [3:0] digits [0:5];
    assign digits[0] = digits_combined[3:0];
    assign digits[1] = digits_combined[7:4];
    assign digits[2] = digits_combined[11:8];
    assign digits[3] = digits_combined[15:12];
    assign digits[4] = digits_combined[19:16];
    assign digits[5] = digits_combined[23:20];

    always @(posedge clk) begin
        cnt <= cnt + 1;
        case(cnt)
            3'd0: begin DIG <= 8'b11111110; current_digit <= digits[0]; end
            3'd1: begin DIG <= 8'b11111101; current_digit <= digits[1]; end
            3'd2: begin DIG <= 8'b11111011; current_digit <= digits[2]; end
            3'd3: begin DIG <= 8'b11110111; current_digit <= digits[3]; end
            3'd4: begin DIG <= 8'b11101111; current_digit <= digits[4]; end
            3'd5: begin DIG <= 8'b11011111; current_digit <= digits[5]; end
            default: DIG <= 8'b11111111;
        endcase
        
        case(current_digit)
            0: SEG <= 7'b1000000;  // 0
            1: SEG <= 7'b1111001;  // 1
            2: SEG <= 7'b0100100;  // 2
            3: SEG <= 7'b0110000;  // 3
            4: SEG <= 7'b0011001;  // 4
            5: SEG <= 7'b0010010;  // 5
            6: SEG <= 7'b0000010;  // 6
            7: SEG <= 7'b1111000;  // 7
            8: SEG <= 7'b0000000;  // 8
            9: SEG <= 7'b0010000;  // 9
            default: SEG <= 7'b1111111;
        endcase
    end
endmodule