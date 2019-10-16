module counter
(
 input wire clk,
 input wire n_rst,
 input wire cnt_up,
 input wire clear,
 output wire one_k_samples
);

flex_counter #(10) count_10
(
 .clk(clk),
 .n_rst(n_rst),
 .clear(clear),
 .count_enable(cnt_up),
 .rollover_val(10'd1000),
 .count_out(),
 .rollover_flag(one_k_samples)
);

endmodule