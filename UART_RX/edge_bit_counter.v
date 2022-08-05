module edge_bit_counter (
input	wire 			CLK,
input	wire 			RST,
input	wire 			Counter_enable,
input	wire 	[4:0]	Prescale,

output	reg		[4:0]	edge_cnt,
output	reg		[3:0]	bit_cnt
);

reg   bit_done_flag;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		edge_cnt <= 5'b0;
		bit_cnt <= 4'b0 ;
	 end
	else if (Counter_enable)
	 begin
		if (bit_done_flag)
		 begin
			bit_cnt <= bit_cnt + 4'b1;
			edge_cnt <= 5'b0;
		 end
		else
		 begin
			edge_cnt <= edge_cnt + 5'b1;
		 end
	 end
	else 
	 begin
		edge_cnt <= 5'b0;
		bit_cnt <= 4'b0 ;
	 end
 
 end


always @(*)
 begin
	case (Prescale)
		5'd8:
			bit_done_flag = (edge_cnt == 5'd7);
		5'd16:
			bit_done_flag = (edge_cnt == 5'd15);
		5'd32:
			bit_done_flag = (edge_cnt == 5'd31);
	default :
			bit_done_flag = (edge_cnt == 5'd7);
	endcase
 end
endmodule