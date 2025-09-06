

module SEG7_LUT(  
	input [2:0]id,
	output reg[6:0]os
);
always@(id)
begin
case(id)
3'b000:os=7'b100_0000;
3'b001:os=7'b111_1001;
3'b010:os=7'b010_0100;
3'b011:os=7'b011_0000;
3'b100:os=7'b001_1001;
3'b101:os=7'b001_0010;
3'b110:os=7'b000_0010;
3'b111:os=7'b111_1000;
endcase
end
endmodule

module display378(
		input		[7: 0]	I,
		input			en,	
		output	reg	[2: 0]	Y,	
		output reg GS,
		output 	reg EO,
		output wire [6:0]HEX
);
SEG7_LUT seg7_instance (
    .id(Y),
    .os(HEX)
);

always @(I or en)begin
	GS=1'b0;
	EO=1'b0;
	Y = 3'b000;
	if(en)begin
		Y=3'b000;
		GS=1;
		EO=0;
	casez(I)
		8'b1???_????:Y=3'b111;
		8'b01??_????:Y=3'b110;
		8'b001?_????:Y=3'b101;
		8'b0001_????:Y=3'b100;
		8'b0000_1???:Y=3'b011;
		8'b0000_01??:Y=3'b010;
		8'b0000_001?:Y=3'b001;
		8'b0000_0001:Y=3'b000;
		8'b0000_0000:begin Y=3'b000;GS=1'b0;EO=1'b1;end
		endcase
		end
		
		  end

endmodule


