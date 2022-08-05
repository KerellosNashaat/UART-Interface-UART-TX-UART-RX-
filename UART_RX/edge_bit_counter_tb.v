`timescale 1ns/100ps

module edge_bit_counter_tb ();

parameter	CLK_PERIOD = 5;

reg 				CLK_tb;
reg 				CLK2_tb;
reg 				RST_tb;
reg 				enable_tb;
reg 		[4:0]	Prescale_tb;

wire  		[4:0]	edge_cnt_tb;
wire  		[3:0]	bit_cnt_tb;



initial
 begin
	initialize();
	reset();
	enable_tb = 1'b1; 
	
	
	
	 #(30*CLK_PERIOD)
	 $finish;
 end

task initialize;
 begin
  CLK_tb = 1'b0;
  CLK2_tb = 1'b1;
  enable_tb = 1'b0; 
  Prescale_tb = 5'd8;
  
 end
endtask 

task reset;
 begin
  RST_tb = 1'b1;
  #(5*CLK_PERIOD)
  RST_tb = 1'b0;
  #(5*CLK_PERIOD)
  RST_tb = 1'b1;
 end
endtask

initial
 begin
  forever	 #(0.5*CLK_PERIOD)	CLK_tb = ~CLK_tb;
 end
 
initial
 begin
  forever	 #(Prescale_tb*0.5*CLK_PERIOD)	CLK2_tb = ~CLK2_tb;
 end


edge_bit_counter DUT(
.CLK(CLK_tb),
.RST(RST_tb),
.enable(enable_tb),
.Prescale(Prescale_tb),

.edge_cnt(edge_cnt_tb),
.bit_cnt(bit_cnt_tb)
);
endmodule