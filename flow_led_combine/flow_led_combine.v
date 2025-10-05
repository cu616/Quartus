//计数器实现流水灯与移位运算符实现的流水灯结合，用2选1选择器切换模式
module flow_led_combine(
 input clk_50m, //输入 50MHz 系统时钟
 input rst_n, //输入低电平复位信号
 input flow_led_stop, //输入流水灯暂停信号
 input sw_change, //2 选 1 选择信号
 output wire [7: 0] flow_led //16 位流水灯输出信号
);//定义线型变量
wire [7: 0] flow_led_cnt; //计数器实现流水灯模块输出
wire [7: 0] flow_led_shift_reg; 
assign flow_led = sw_change ? flow_led_cnt : flow_led_shift_reg;
flow_led_counter8 flow_led_counter8_inst(
 .clk_50m(clk_50m), //输入 50MHz 系统时钟
 .rst_n(rst_n), //输入低电平复位信号
 .flow_led_stop(flow_led_stop), //输入流水灯暂停信号
 .flow_led(flow_led_cnt) //输出 8 位流水灯
);

led_register(
 .clk_50m(clk_50m), //输入 50MHz 系统时钟
 .rst_n(rst_n), //输入低电平复位信号
 .flow_led_stop(flow_led_stop), //输入流水灯暂停信号
 .flow_led(flow_led_shift_reg) //8 位流水灯输出信号
);
endmodule

module led_register(//移位流水灯
 input clk_50m, 
 input rst_n, 
 input flow_led_stop, 
 output reg [7: 0] flow_led
);

reg [24:0] cnt_50m; //计数，用于分频1hz
reg clk_1hz;

reg mod;//为1正向移动，为0反向
always @(posedge clk_50m or negedge rst_n)begin
 if(!rst_n)begin
 cnt_50m <= 25'd0;
 end
 else if(cnt_50m == 25'd24_999_999)begin
 cnt_50m <= 25'd0;
 end
 else begin
 cnt_50m <= cnt_50m + 1'd1;
 end
end

always @(posedge clk_50m or negedge rst_n)begin
 if(!rst_n)begin
 clk_1hz <= 1'b0;
 end
 else if(cnt_50m == 25'd24999999)begin 
 clk_1hz <= ~clk_1hz;
 end
end

always @(posedge clk_1hz or negedge rst_n)begin
 if(!rst_n)begin
 flow_led <= 8'b0000_0001;
 mod<=1'b1;
end
 else if(flow_led_stop)begin
 flow_led <= flow_led; 
 end
 else  if(mod&&(flow_led!=8'b1000_0000) )begin//令人难绷的四分支判断，总之就是灯到了边缘会反向移动（改变mod）
 flow_led <= {flow_led[6:0], flow_led[7]}; 
end
else if(mod&&(flow_led==8'b1000_0000) )
begin 
mod<=~mod;
flow_led<=8'b0100_0000;
end 
else if(~mod&&(flow_led!=8'b0000_0001)) begin 
flow_led <= {flow_led[0], flow_led[7:1]};
end
else if(~mod&&(flow_led==8'b0000_0001))begin 
mod<=~mod;
flow_led<=8'b0000_0010;
end
 end

endmodule
module flow_led_counter8(//计数流水灯
 input clk_50m,
 input rst_n,
 input flow_led_stop,
 output wire [7: 0] flow_led
);
wire [ 2: 0] cnt_led;
counter8 counter_1(
 .clk_50m(clk_50m), 
 .rst_n(rst_n), 
 .cnt_stop(flow_led_stop), 
 .cnt_led(cnt_led) 
);
e3to8 decoder_1(
 .a(cnt_led), 
 .en(rst_n), 
 .Y(flow_led) 
);
endmodule

module e3to8(
		input		[ 2: 0]		a,	
		input					en,	
		output	reg	[ 7: 0]		Y	
);
always @(*)begin
	if(en)begin
		case(a[2:0])//decoder3_8
			3'b000: Y = 8'b0000_0001;
			3'b001: Y = 8'b0000_0010;
			3'b010: Y = 8'b0000_0100;
			3'b011: Y = 8'b0000_1000;
			3'b100: Y = 8'b0001_0000;
			3'b101: Y = 8'b0010_0000;
			3'b110: Y = 8'b0100_0000;
			3'b111: Y = 8'b1000_0000;
			default:Y = 8'b1111_1111;
		endcase
	end
	else begin
		Y = 8'b1111_1111;
	end
end

endmodule
	
module counter8(
 input clk_50m, 
 input rst_n, 
 input cnt_stop, 
 output reg [ 2: 0] cnt_led 
);

reg [24:0] cnt_50m ; 
reg clk_1hz;
reg mod;
always @(posedge clk_50m or negedge rst_n)begin
 if(!rst_n)begin
 cnt_50m <= 25'd0;
 end
 else if(cnt_50m == 25'd24_999_999)begin
 cnt_50m <= 25'd0;
 end
 else begin
 cnt_50m <= cnt_50m + 1'd1; 
 end
end

always @(posedge clk_50m or negedge rst_n)begin
 if(!rst_n)begin
 clk_1hz <= 1'b0;
 end
 else if(cnt_50m == 25'd24999999)begin 
 clk_1hz <= ~clk_1hz;
 end
end

always @(posedge clk_1hz or negedge rst_n)begin
 if(!rst_n)begin
 cnt_led <= 3'b0;
 end
 else if(cnt_stop)begin
 cnt_led <= cnt_led;
 end
else if(mod)begin
  if(cnt_led == 3'b111)begin 
        cnt_led <= 3'b110;
		  mod<=~mod;
    end
     else begin
    cnt_led <= cnt_led + 1'd1;
    end
 end
 
 else if(~mod)begin
 if(cnt_led == 3'b000)begin 
 cnt_led <= 3'b001;
 mod<=~mod;
 end
 else begin
 cnt_led <= cnt_led - 1'd1;
 end
end

end
endmodule
