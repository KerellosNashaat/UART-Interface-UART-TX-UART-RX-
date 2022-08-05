`timescale 1ns/100ps

module UART_RX_tb ();

parameter	CLK_PERIOD = 5;
parameter	Test_Cases = 9;
parameter	Even_Parity_Test_Cases_index = 0;
parameter	Odd_Parity_Test_Cases_index = 3;
parameter	No_Parity_Test_Cases_index = 6;

reg 				CLK_RX_tb;
reg 				CLK_TX_tb;
reg 				RST_tb;
reg 	[4:0]		Prescale_tb;
reg 				RX_IN_tb;
reg					PAR_EN_tb;
reg 				PAR_TYP_tb;


wire				data_valid_tb;
wire	[7:0]		P_DATA_tb;



reg		[10:0]		input_data			[Test_Cases-1:0];
reg		[7:0]		Expected_output		[Test_Cases-1:0];

integer test_case_index;

initial
 begin
	// System Functions
	$dumpfile("UART_RX.vcd") ;       
	$dumpvars; 
	
	// Read Input Files
	$readmemb("inputs.txt",input_data);
	$readmemb("expected_output.txt",Expected_output);
	
	
	initialize();
	reset();
	      
	 
	// Test Cases
	
	$display("/**************************************************************************************/");
    $display("/*************************** Test Case 1: Using Even Parity ***************************/");
    $display("/**************************************************************************************/\n");
	for (test_case_index = Even_Parity_Test_Cases_index; test_case_index < Even_Parity_Test_Cases_index + 3; test_case_index = test_case_index + 1)
	 begin
	  put_data(input_data[test_case_index], 1'b1,1'b0) ;  
	  RX_IN_tb = 1'b1;
	  check_out(Expected_output[test_case_index],test_case_index) ;         
	 end
	 
	#(4*CLK_PERIOD);
	$display("/**************************************************************************************/");
    $display("/*************************** Test Case 2: Using Odd Parity ***************************/");
    $display("/**************************************************************************************/\n");
	for (test_case_index = Odd_Parity_Test_Cases_index; test_case_index < Odd_Parity_Test_Cases_index + 3; test_case_index = test_case_index + 1)
	 begin
	  put_data(input_data[test_case_index], 1'b1,1'b1) ;  
	  RX_IN_tb = 1'b1;
	  check_out(Expected_output[test_case_index],test_case_index) ;         
	 end
	 
	#(4*CLK_PERIOD);
	$display("/**************************************************************************************/");
    $display("/*************************** Test Case 3: Using No Parity *****************************/");
    $display("/**************************************************************************************/\n");
	for (test_case_index = No_Parity_Test_Cases_index; test_case_index < No_Parity_Test_Cases_index + 3; test_case_index = test_case_index + 1)
	 begin
	  put_data(input_data[test_case_index], 1'b0,1'b0) ;  
	  RX_IN_tb = 1'b1;
	  check_out(Expected_output[test_case_index],test_case_index) ;         
	 end
	#(4*CLK_PERIOD)
	$finish;
 end

task initialize;
 begin
  CLK_RX_tb = 1'b0;
  CLK_TX_tb = 1'b0;
  Prescale_tb = 5'd8;
  RX_IN_tb = 1'b1;
  PAR_EN_tb = 1'b0; 
  PAR_TYP_tb = 1'b0;
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

task put_data;
 input 	reg 		[10:0]		Recieved_Data;
 input	reg						parity_enable ;
 input	reg						parity_type ;
 integer iterator;
 begin
	PAR_EN_tb = parity_enable ;
	PAR_TYP_tb = parity_type ;
	
	for ( iterator = 10; iterator > -1; iterator = iterator - 1 )
	 begin
		@(posedge CLK_TX_tb)
		RX_IN_tb = Recieved_Data[iterator];
	 end
	 
	if (parity_enable)
	 begin
		@(posedge CLK_TX_tb)
		RX_IN_tb = Recieved_Data[iterator];
	 end
 end
endtask

task check_out ;
 input  reg  	   [7:0]  		   expec_out ;
 input  integer                    Test_Num ; 


 begin
  @(posedge data_valid_tb)
   if(P_DATA_tb == expec_out) 
    begin
     $display("Test Case %d is succeeded",Test_Num);
    end
   else
    begin
     $display("Test Case %d is failed", Test_Num);
    end
 end
endtask

initial
 begin
  forever	 #(0.5*CLK_PERIOD)	CLK_RX_tb = ~CLK_RX_tb;
 end
 
initial
 begin
  forever	
   begin
	repeat(0.5*Prescale_tb)	@(posedge CLK_RX_tb);
	CLK_TX_tb = ~CLK_TX_tb;
   end
 end



UART_RX DUT(
.CLK(CLK_RX_tb),
.RST(RST_tb),
.RX_IN(RX_IN_tb),
.Prescale(Prescale_tb),
.PAR_EN(PAR_EN_tb),
.PAR_TYP(PAR_TYP_tb),

.data_valid(data_valid_tb),
.P_DATA(P_DATA_tb)
);
endmodule