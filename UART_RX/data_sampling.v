module data_sampling (
input	wire 			CLK,
input	wire 			RST,
input	wire 			data_samp_en,
input	wire			RX_IN,
input	wire 	[4:0]	Prescale,
input	wire	[4:0]	edge_cnt,


output	reg				Sample_Available,
output	reg				sampled_bit
);

reg		[2:0]	Sample;
reg 			sampling_flag, Sample_Ready_flag;
reg				sampled_bit_Comb;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		Sample <= 3'b111 ;
	 end
	else if (data_samp_en)
	 begin
		if (sampling_flag)
		 begin
			Sample <= { Sample[1:0], RX_IN };
		 end
	 end
 end
 
 
always @(*)
 begin
	case (Prescale)
		5'd8:
		begin
			sampling_flag = (edge_cnt == 5'd2) || (edge_cnt == 5'd3) || (edge_cnt == 5'd4);
			Sample_Ready_flag = (edge_cnt == 5'd5);
		end
		5'd16:
		begin
			sampling_flag = (edge_cnt == 5'd6) || (edge_cnt == 5'd7) || (edge_cnt == 5'd8);
			Sample_Ready_flag = (edge_cnt == 5'd9);
		end
		5'd32:
		begin
			sampling_flag = (edge_cnt == 5'd14) || (edge_cnt == 5'd15) || (edge_cnt == 5'd16);
			Sample_Ready_flag = (edge_cnt == 5'd17);
		end
	default :
		begin
			sampling_flag = (edge_cnt == 5'd2) || (edge_cnt == 5'd3) || (edge_cnt == 5'd4);
			Sample_Ready_flag = (edge_cnt == 5'd5);
		end
	endcase
 end
 
 
always @(*)
 begin
	case (Sample)
		3'b000:
			sampled_bit_Comb = 1'b0;
		3'b001:
			sampled_bit_Comb = 1'b0;
		3'b010:
			sampled_bit_Comb = 1'b0; //not a logical case
		3'b011:
			sampled_bit_Comb = 1'b1;
		3'b100:
			sampled_bit_Comb = 1'b0;
		3'b101:
			sampled_bit_Comb = 1'b1;	//not a logical case
		3'b110:
			sampled_bit_Comb = 1'b1;
		3'b111:
			sampled_bit_Comb = 1'b1;
		
	endcase
 end
 
always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		sampled_bit <= 1'b1 ;
		Sample_Available <= 1'b0;
	 end
	else if (Sample_Ready_flag)
	 begin
		sampled_bit <= sampled_bit_Comb ;
		Sample_Available <= 1'b1;
	 end
	else
		Sample_Available <= 1'b0; 
 end
endmodule