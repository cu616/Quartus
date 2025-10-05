module decoder4_16(//屎山4-16译码器，当时我怎么写出来的？！
 input [ 3: 0] in_data, //4 位信号输入
 input enable, //使能信号输入
 output reg [ 15: 0] out_data //16 位译码信号输出
);

always @(*)begin
 if(enable)begin
 case(in_data[3:0]) //enable = 1 时,对 in_data 进行译码，输出out_data
 4'b0000: out_data = 16'b0000_0000_0000_0001;
 4'b0001: out_data = 16'b0000_0000_0000_0010;
 4'b0010: out_data = 16'b0000_0000_0000_0100;
 4'b0011: out_data = 16'b0000_0000_0000_1000;
 4'b0100: out_data = 16'b0000_0000_0001_0000;
 4'b0101: out_data = 16'b0000_0000_0010_0000;
 4'b0110: out_data = 16'b0000_0000_0100_0000;
 4'b0111: out_data = 16'b0000_0000_1000_0000;
 4'b1000: out_data = 16'b0000_0001_0000_0000;
 4'b1001: out_data = 16'b0000_0010_0000_0000;
 4'b1010: out_data = 16'b0000_0100_0000_0000;
 4'b1011: out_data = 16'b0000_1000_0000_0000;
 4'b1100: out_data = 16'b0001_0000_0000_0000;
 4'b1101: out_data = 16'b0010_0000_0000_0000;
 4'b1110: out_data = 16'b0100_0000_0000_0000;
 4'b1111: out_data = 16'b1000_0000_0000_0000;

 default:out_data = 16'b0;
 endcase
 end
 else begin //enable = 0 时，输出恒为 8'b0000_0000
 out_data = 16'b0;
 end
end
endmodule
