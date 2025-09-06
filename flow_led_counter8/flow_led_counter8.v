module flow_led_counter8(
 input clk_50m,
 input rst_n,
 input flow_led_stop,
input mod,
 output wire [7: 0] flow_led
);
wire [ 2: 0] cnt_led;
counter8 counter_1(
 .clk_50m(clk_50m), 
 .rst_n(rst_n), 
 .cnt_stop(flow_led_stop), 
.mod(mod),
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
 input mod,
 output reg [ 2: 0] cnt_led 
);

reg [24:0] cnt_50m ; 
reg clk_1hz;

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
 cnt_led <= 3'd0;
 end
 else if(cnt_stop)begin
 cnt_led <= cnt_led;
 end
else if(mod)begin
  if(cnt_led == 3'd111)begin 
        cnt_led <= 3'd0;
    end
     else begin
    cnt_led <= cnt_led + 1'd1;
    end
 end
 else if(~mod)begin
 if(cnt_led == 3'd000)begin 
 cnt_led <= 3'd111;
 end
 else begin
 cnt_led <= cnt_led - 1'd1;
 end
end
end
endmodule
