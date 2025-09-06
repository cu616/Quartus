module SEG7_LUT(  
	input [3:0]id,
	output reg[6:0]os
);
always@(id)
begin
case(id)
4'b0000:os=7'b100_0000;
4'b0001:os=7'b111_1001;
4'b0010:os=7'b010_0100;
4'b0011:os=7'b011_0000;
4'b0100:os=7'b001_1001;
4'b0101:os=7'b001_0010;
4'b0110:os=7'b000_0010;
4'b0111:os=7'b111_1000;
4'b1000:os=7'b000_0000;
4'b1001:os=7'b001_1000;
endcase
end
endmodule