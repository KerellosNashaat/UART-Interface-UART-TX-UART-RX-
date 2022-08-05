module deserializer #(parameter WIDTH = 8)(
input	wire 				CLK,
input	wire 				RST,
input	wire 				deser_en,
input	wire 				sampled_bit,

output	reg		[WIDTH - 1:0]		P_DATA
);


always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		P_DATA <= 'b0 ;
	 end
	else if (deser_en)
	 begin
		P_DATA <= {sampled_bit ,P_DATA[WIDTH - 1 : 1]} ;
	 end
 end
 

endmodule