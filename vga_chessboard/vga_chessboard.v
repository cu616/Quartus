module vga_chessboard (

	input		wire					clk,
	input		wire					rst_n,
	
	output	wire		[7:0]		vga_rgb,
	output	wire					vga_hs,
	output	wire					vga_vs
);

	wire					clk_25m;
	wire					pll_locked;
	
	pll pll_inst (
	
		.areset 			( ~rst_n 	),
		.inclk0 			( clk 		),
		.c0				( clk_25m	),
		.locked 			( pll_locked)
	);

	vga_ctrl vga_ctrl_inst (

		.clk					(clk_25m		),
		.rst_n				(pll_locked	),
                         
		.vga_rgb				(vga_rgb		),
		.vga_hs				(vga_hs		),
		.vga_vs				(vga_vs		)
	);

endmodule 
