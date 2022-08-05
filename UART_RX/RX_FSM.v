module RX_FSM (
input	wire 								CLK,
input	wire								RST,
input	wire 								PAR_EN,
input	wire								RX_IN,
input	wire								Sample_Available,  
input	wire			[3:0]				bit_cnt,
input	wire								par_error,
input	wire								start_glitch,
input	wire								stop_error,

output	reg 								Counter_enable,
output	reg 								data_samp_en,
output	reg 								deser_en,
output	reg 								par_check_en,
output	reg 								start_check_en,
output	reg 								stop_check_en,
output	reg									RST_parity,
output	reg 								data_valid
);

//States encoding "gray code"
localparam	IDLE = 3'b000,
			Start = 3'b001,
			Recieve_data = 3'b011,
			Check_Parity = 3'b010,
			Stop = 3'b110 ,
			Check_Error = 3'b111;
			
reg		[2:0]	current_state,
				next_state ;
		

reg				data_valid_comb;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		current_state <= IDLE ;
	 end
	else 
	 begin 
		current_state <= next_state ;
	 end
 end	
 
  //next state logic
 always @ (*)
  begin
	case (current_state)
	IDLE		:	
				begin
	
				 if ( !RX_IN )
				  begin
				   next_state = Start ;
				  end
				 else
				  begin
				   next_state = IDLE ;
				  end
				  
				end
	
	Start		:	
				begin
				 if ( start_glitch )
				  begin
				   next_state = IDLE ;
				  end
				 else if ( bit_cnt == 4'b1 )
				  begin
				   next_state = Recieve_data ;
				  end
				 else
				  begin
				   next_state = Start ;
				  end
				end
				
	Recieve_data	:	
				begin
	
				 if ( (bit_cnt == 4'd9) && PAR_EN )
				  begin
				   next_state = Check_Parity ;
				  end
				 else if ( (bit_cnt == 4'd9) && !PAR_EN )
				  begin
				   next_state = Stop ;
				  end
				  else
				  begin
				   next_state = Recieve_data ;
				  end
				end
				 
	Check_Parity	:
				begin
				 if ( bit_cnt == 4'd10 )
				  begin
				   next_state = Stop ;
				  end
				 else
				  begin
				   next_state = Check_Parity ;
				  end
				end
				
	Stop		:	
				begin
				 if ( Sample_Available )
				  begin
				   next_state = Check_Error ;
				  end
				  else
				  begin
				   next_state = Stop ;
				  end
				end
				
	Check_Error		:	
				begin
				 if (((bit_cnt == 4'd10 && !PAR_EN) || (bit_cnt == 4'd11 && PAR_EN)) && !RX_IN) // Stop bit ended and another start bit is sent
 				  begin
				   next_state = Start ;
				  end
				 else if ( (bit_cnt == 4'd10 && !PAR_EN) || (bit_cnt == 4'd11 && PAR_EN) ) // Stop bit ended
				  begin
				   next_state = IDLE ;
				  end
				  else
				  begin
				   next_state = Check_Error ;
				  end
				end

	default 	: 
				begin
                 next_state = IDLE  ;
				end  
    endcase 
 end

//output logic
 always @ (*)
  begin
	Counter_enable = 1'b0;
	data_samp_en = 1'b0;
	deser_en= 1'b0;
	par_check_en = 1'b0;
	start_check_en = 1'b0;
	stop_check_en = 1'b0;
	data_valid_comb = 1'b0;
	RST_parity = 1'b1;
	case (current_state)
	IDLE		:	
				begin
				Counter_enable = 1'b0;
				data_samp_en = 1'b0;
				deser_en= 1'b0;
				par_check_en = 1'b0;
				start_check_en = 1'b0;
				stop_check_en = 1'b0;
				data_valid_comb = 1'b0;
				RST_parity = 1'b0;
				end
	
	Start		:	
				begin
				Counter_enable = 1'b1;
				data_samp_en = 1'b1;
				deser_en= 1'b0;
				par_check_en = 1'b0;
				stop_check_en = 1'b0;
				data_valid_comb = 1'b0;
				if (Sample_Available)
					start_check_en = 1'b1;
				else
					start_check_en = 1'b0;
				end
				
	Recieve_data	:	
				begin
				Counter_enable = 1'b1;
				data_samp_en = 1'b1;
				start_check_en= 1'b0;
				par_check_en = 1'b0;
				stop_check_en = 1'b0;
				data_valid_comb = 1'b0;
				if (Sample_Available)
					deser_en = 1'b1;
				else
					deser_en = 1'b0;
				end
				 
	Check_Parity	:
				begin
				Counter_enable = 1'b1;
				data_samp_en = 1'b1;
				start_check_en= 1'b0;
				deser_en = 1'b0;
				stop_check_en = 1'b0;
				data_valid_comb = 1'b0;
				if (Sample_Available)
					par_check_en = 1'b1;
				else
					par_check_en = 1'b0;
				end
				
	Stop		:	
				begin
				Counter_enable = 1'b1;
				data_samp_en = 1'b1;
				start_check_en= 1'b0;
				deser_en = 1'b0;
				par_check_en = 1'b0;
				data_valid_comb = 1'b0;
				if (Sample_Available)
					stop_check_en = 1'b1;
				else
					stop_check_en = 1'b0;
				end
				
	Check_Error		:	
				begin
				Counter_enable = 1'b1;
				data_samp_en = 1'b1;
				start_check_en= 1'b0;
				deser_en = 1'b0;
				par_check_en = 1'b0;
				stop_check_en = 1'b0;
				if (!(par_error || stop_error))
					data_valid_comb = 1'b1;
				else
					data_valid_comb = 1'b0;
				end

	default 	: 
				begin
				Counter_enable = 1'b0;
				data_samp_en = 1'b0;
				deser_en= 1'b0;
				par_check_en = 1'b0;
				start_check_en = 1'b0;
				stop_check_en = 1'b0;
				data_valid_comb = 1'b0;
				RST_parity = 1'b0;
				end
    endcase 
 end


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    data_valid <= 1'b0 ;
   end
  else
   begin
    data_valid <= data_valid_comb ;
   end
 end

endmodule