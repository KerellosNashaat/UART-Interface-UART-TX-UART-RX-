module edge_counter_and_data_samp (
input	wire 			CLK,
input	wire 			RST,
input	wire 			data_samp_en,
input	wire			RX_IN,
input	wire 	[4:0]	Prescale,
input	wire 			Counter_enable,

output	wire		[4:0]	edge_cnt,
output	wire		[3:0]	bit_cnt,
output	wire				Sample_Available,
output	wire				sampled_bit,

output	wire		[7:0]	P_DATA

);



edge_bit_counter U1(
.CLK(CLK),
.RST(RST),
.Counter_enable(Counter_enable),
.Prescale(Prescale),

.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt)
);

data_sampling U2(
.CLK(CLK),
.RST(RST),
.data_samp_en(data_samp_en),
.Prescale(Prescale),
.RX_IN(RX_IN),
.edge_cnt(edge_cnt),

.Sample_Available(Sample_Available),
.sampled_bit(sampled_bit)
);

deserializer	U3(
.CLK(CLK),
.RST(RST),
.deser_en(Sample_Available),
.sampled_bit(sampled_bit),

.P_DATA(P_DATA)
);


endmodule