module UART_RX #(parameter UART_WIDTH = 8) (
input	wire 			CLK,
input	wire 			RST,
input	wire			RX_IN,
input	wire 	[4:0]	Prescale,
input	wire 			PAR_EN,
input	wire 			PAR_TYP,


output	wire				data_valid,
output	wire		[UART_WIDTH -1 : 0]	P_DATA //in order to change UART WIDTH, you have to consider the modifications in the RX_FSM
);

wire				Counter_enable, Data_samp_en, Deser_en, par_check_en, Sample_Av, stop_check_en;
wire				par_error, start_glitch, stop_error, Sampled_bit, start_check_en, RST_parity;
wire		[4:0]	Edge_cnt;
wire		[3:0]	Bit_cnt;


edge_bit_counter U1(
.CLK(CLK),
.RST(RST),
.Counter_enable(Counter_enable),
.Prescale(Prescale),

.edge_cnt(Edge_cnt),
.bit_cnt(Bit_cnt)
);

data_sampling U2(
.CLK(CLK),
.RST(RST),
.data_samp_en(data_samp_en),
.Prescale(Prescale),
.RX_IN(RX_IN),
.edge_cnt(Edge_cnt),

.Sample_Available(Sample_Av),
.sampled_bit(Sampled_bit)
);

deserializer #( .WIDTH(UART_WIDTH) ) U3(
.CLK(CLK),
.RST(RST),
.deser_en(Deser_en),
.sampled_bit(Sampled_bit),

.P_DATA(P_DATA)
);

parity_check 	U4(
.CLK(CLK),
.RST(RST),
.par_check_en(par_check_en),
.PAR_TYP(PAR_TYP),
.Sample_Available(Sample_Av),
.sampled_bit(Sampled_bit),
.RST_parity(RST_parity),

.par_error(par_error)
);

start_check	U5(
.CLK(CLK),
.RST(RST),
.start_check_en(start_check_en),
.sampled_bit(Sampled_bit),

.start_glitch(start_glitch)
);

stop_check	U6 (
.CLK(CLK),
.RST(RST),
.stop_check_en(stop_check_en),
.sampled_bit(Sampled_bit),

.stop_error(stop_error)
);

RX_FSM	U7 (
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.RX_IN(RX_IN),
.Sample_Available(Sample_Av),
.bit_cnt(Bit_cnt),
.par_error(par_error),
.start_glitch(start_glitch),
.stop_error(stop_error),

.Counter_enable(Counter_enable),
.data_samp_en(data_samp_en),
.deser_en(Deser_en),
.par_check_en(par_check_en),
.start_check_en(start_check_en),
.stop_check_en(stop_check_en),
.RST_parity(RST_parity),
.data_valid(data_valid)
);
endmodule