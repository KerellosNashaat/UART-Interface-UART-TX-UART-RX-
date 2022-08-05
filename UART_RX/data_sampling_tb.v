`timescale 1ns/100ps

module data_sampling_tb ();

parameter	CLK_PERIOD = 5;

reg 				CLK_tb;
reg 				CLK2_tb;
reg 				RST_tb;
reg 				data_samp_en_tb;
reg 		[4:0]	Prescale_tb;
reg 				RX_IN_tb;
reg					enable_tb;


wire 				sampled_bit_tb;
wire 		[4:0]	edge_cnt_tb;
wire  		[3:0]	bit_cnt_tb;

wire				Sample_Available_tb;

wire		[7:0]	P_DATA_tb;

initial
 begin
	initialize();
	reset();
	@(posedge CLK_tb);	
	RX_IN_tb = 1'b0;
	@(posedge CLK_tb);	
	data_samp_en_tb = 1'b1;
	enable_tb = 1'b1; 
	
	repeat(7)	@(posedge CLK_tb);
	RX_IN_tb = 1'b1;
	
	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b0;
	
	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b0;
	
	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b1;

	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b0;
	
	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b0;
	
	repeat(8)	@(posedge CLK_tb);
	RX_IN_tb = 1'b1;
	
	repeat(8)	@(posedge CLK_tb);
	#(4*CLK_PERIOD)
	$finish;
 end

task initialize;
 begin
  CLK_tb = 1'b0;
  CLK2_tb = 1'b0;
  data_samp_en_tb = 1'b0;
  enable_tb = 1'b0; 
  Prescale_tb = 5'd8;
  
 end
endtask 

task reset;
 begin
  RST_tb = 1'b1;
  #(4*CLK_PERIOD)
  RST_tb = 1'b0;
  #(4*CLK_PERIOD)
  RST_tb = 1'b1;
 end
endtask

initial
 begin
  forever	 #(0.5*CLK_PERIOD)	CLK_tb = ~CLK_tb;
 end
 
initial
 begin
  forever	
   begin
	repeat(0.5*Prescale_tb)	@(posedge CLK_tb);
	CLK2_tb = ~CLK2_tb;
   end
 end


edge_counter_and_data_samp DUT(
.CLK(CLK_tb),
.RST(RST_tb),
.data_samp_en(data_samp_en_tb),
.RX_IN(RX_IN_tb),
.enable(enable_tb),
.Prescale(Prescale_tb),


.edge_cnt(edge_cnt_tb),
.bit_cnt(bit_cnt_tb),
.Sample_Available(Sample_Available_tb),
.sampled_bit(sampled_bit_tb),
.P_DATA(P_DATA_tb)
);
endmodule