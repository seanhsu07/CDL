module fir_filter
(
	input wire clk,
	input wire n_reset, 
	input logic [15:0] sample_data,
	input logic [15:0] fir_coefficient,
	input wire load_coeff,
	input wire data_ready, 
	output logic one_k_samples,
	output logic modwait, 
	output logic [15:0] fir_out, 
	output logic err
);

	logic count_up;
	logic clear;
	logic [16:0] dpout;
	logic [2:0] op;
	logic [3:0] src1;
	logic [3:0] src2;
	logic [3:0] dest;
	logic overflow;
	logic s_dr;
	logic s_lc;

controller ct(
	.clk(clk),
	.n_rst(n_reset), 
	.dr(s_dr), 
	.lc(s_lc), 
	.overflow(overflow),
	.cnt_up(count_up), 
	.clear(clear),
	.modwait(modwait),
	.op(op), 
	.src1(src1),
	.src2(src2),
	.dest(dest),
	.err(err)
);

magnitude sign(
	.in(dpout),
	.out(fir_out)
);

datapath dp(
	.clk(clk),
	.n_reset(n_reset),
	.op(op),
	.src1(src1),
	.src2(src2),
	.dest(dest),
	.ext_data1(sample_data),
	.ext_data2(fir_coefficient),
	.outreg_data(dpout),
	.overflow(overflow)
);

counter cnt(
	.clk(clk),
	.n_rst(n_reset),
	.cnt_up(count_up),
	.clear(clear),
	.one_k_samples(one_k_samples)
);

endmodule
