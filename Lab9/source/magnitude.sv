module magnitude
(
 input wire [16:0] in,
 output wire [15:0] out
);

assign out = (in[16] == 1) ? (~in[15:0] + 1) : (in[15:0]);

endmodule