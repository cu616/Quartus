module decoder3_8( //flie name: decoder3_8.v，三八译码器
		input		[ 2: 0]		a,	//input 3 bits signal
		input					en,	//enable signal
		output	reg	[ 7: 0]		Y	//output 8 bits signal
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
