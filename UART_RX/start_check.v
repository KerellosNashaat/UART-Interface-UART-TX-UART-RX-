module start_check (
input	wire 				CLK,
input	wire 				RST,
input	wire 				start_check_en,
input	wire 				sampled_bit,

output	reg					start_glitch
);


always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		start_glitch <= 1'b0 ;
	 end
	else if (start_check_en)
	 begin
		start_glitch <= (sampled_bit != 1'b0) ;
	 end
 end
 
endmodule