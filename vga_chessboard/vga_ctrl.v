`define VGA_640x480x60					// choose different video standard,revise PLL clk ,alter cnt WIDTH
//`define VGA_680X480X75
//`define VGA_800X600X60
//`define VGA_800X600X75
//`define VGA_1024X768X60
//`define VGA_1024X768X75
//`define VGA_1280X1024X60
//`define VGA_1280X800X60
//`define VGA_1440X900X60

module vga_ctrl (

	input		wire					clk,
	input		wire					rst_n,

	output	reg		[7:0]		vga_rgb,
	output	reg					vga_hs,
	output	reg					vga_vs
);

//================ VGA_680X480X60 =========================================================

`ifdef VGA_640x480x60								// PLL clk = 25M = 640x480x60

	localparam			HS_A	=	96;				// synchronous pulse, horizontal
	localparam			HS_B	=	48;				// back porch pulse
	localparam			HS_C	=	640;				// display interval
	localparam			HS_D	=	16;				// Front porch
	localparam			HS_E	=	800;				// horizontal cycles

	localparam			VS_A	=	2;					// synchronous pulse, vertical
	localparam			VS_B	=	33;
	localparam			VS_C	=	480;	
	localparam			VS_D	=	10;	
	localparam			VS_E	=	525;	
	
	localparam			HS_WIDTH	=	10;
	localparam			VS_WIDTH	=	10;

`endif

//================ VGA_800X600X60 =========================================================
//
//`ifdef VGA_800X600X60								// PLL clk = 40.0M
//
//	localparam			HS_A	=	128;
//	localparam			HS_B	=	88;
//	localparam			HS_C	=	800;
//	localparam			HS_D	=	40;
//	localparam			HS_E	=	1056;
//		
//	localparam			VS_A	=	4;
//	localparam			VS_B	=	23;
//	localparam			VS_C	=	600;
//	localparam			VS_D	=	1;
//	localparam			VS_E	=	628;
//	
//	localparam			HS_WIDTH	=	11;			// different resolution correspond to different couter width
//	localparam			VS_WIDTH	=	10;
//	
//`endif
//=====================================================================================================
	
	parameter			WIDTH = 40;							// chessboard long
	
	wire		[4:0]		cnt_hs_div40;						// 640/40 = 16
	wire		[3:0]		cnt_vs_div40;						// 480/40 = 12
	wire					sum_div40;							// least significant bit XOR
	
	reg		[HS_WIDTH - 1:0]		cnt_hs;				// counter for horizontal synchronous signal
	reg		[VS_WIDTH - 1:0]		cnt_vs;				// counter for vertical synchrous signal
	
	wire					en_hs;								//	dsiplay horizontal enable
	wire					en_vs;								// display vertical enable
	wire					en;									// effective display zone
	
	always @ (posedge clk, negedge rst_n)
		if (!rst_n)
			cnt_hs <= 0;
		else
			if (cnt_hs < HS_E - 1)
				cnt_hs <= cnt_hs + 1'b1;
			else
				cnt_hs <= 0;
				
	always @ (posedge clk, negedge rst_n)
		if (!rst_n)
			cnt_vs <= 0;
		else
			if (cnt_hs == HS_E - 1)
				if (cnt_vs < VS_E - 1)
					cnt_vs <= cnt_vs + 1'b1;
				else
					cnt_vs <= 0;
			else
				cnt_vs <= cnt_vs;
				
	always @ (posedge clk, negedge rst_n)
		if (!rst_n)
			vga_hs <= 1'b1;
		else
			if (cnt_hs < HS_A - 1)
				vga_hs <= 1'b0;
			else
				vga_hs <= 1'b1;
				
	always @ (posedge clk, negedge rst_n)
		if (!rst_n)
			vga_vs <= 1'b1;
		else
			if (cnt_vs < VS_A - 1)
				vga_vs <= 1'b0;
			else
				vga_vs <= 1'b1;
		
	assign en_hs = (cnt_hs > HS_A + HS_B - 1)	&& (cnt_hs < HS_E - HS_D);
	assign en_vs = (cnt_vs > VS_A + VS_B - 1) && (cnt_vs < VS_E - VS_D);
	assign en = en_hs && en_vs;
	
	assign cnt_hs_div40 = (cnt_hs - HS_A - HS_B) / 40;
	assign cnt_vs_div40 = (cnt_vs - VS_A - VS_B) / 40;
	assign sum_div40 = cnt_hs_div40[0] ^ cnt_vs_div40[0];						// xor, check parity of sum_div40
				
	always @ (posedge clk, negedge rst_n)
		if (!rst_n)
			vga_rgb <= 8'b000_000_00;
		else
			if (en)
				if (sum_div40 == 1)
					vga_rgb <= 8'b111_111_11;					// white
				else
					vga_rgb <= 8'b000_000_00;					// black
			else
				vga_rgb <= 8'b000_000_00;

endmodule 
