module parity_check (
input	wire 				CLK,
input	wire 				RST,
input	wire 				RST_parity,
input	wire 				par_check_en,
input	wire 				PAR_TYP,
input	wire 				sampled_bit,
input	wire				Sample_Available,  

output	reg					par_error
);

wire	even_parrity;
reg		parity_comb, parity;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		parity <= 1'b0 ;
	 end
	else if (!RST_parity)
	 begin
		parity <= 1'b0 ;
	 end
	else if (Sample_Available)
	 begin
		parity <= parity_comb ;
	 end
 end
 
 
assign even_parrity = sampled_bit ^ parity;

always @(*)
 begin
	if (PAR_TYP)
		parity_comb = ~even_parrity;
	else
		parity_comb = even_parrity;
end 
 
 
always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		par_error <= 1'b0 ;
	 end
	else if (par_check_en)
	 begin
		par_error <= (sampled_bit != parity) ;
	 end
 end
 
 endmodule