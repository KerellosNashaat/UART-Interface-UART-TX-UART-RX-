module stop_check (
input	wire 				CLK,
input	wire 				RST,
input	wire 				stop_check_en,
input	wire 				sampled_bit,

output	reg					stop_error
);


always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		stop_error <= 1'b0 ;
	 end
	else if (stop_check_en)
	 begin
		stop_error <= (sampled_bit != 1'b1) ;
	 end
 end
 
endmodule