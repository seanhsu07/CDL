// $Id: $
// File name:   stp_sr_4_msb.sv
// Created:     9/14/2018
// Author:      Tim Pritchett
// Lab Section: 9999
// Version:     1.0  Initial Design Entry
// Description: 4-bit MSB Serial to Parallel shift register 
//              (Defaults for Flex StP SR)

module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
  input wire clk,
  input wire n_rst,
  input wire serial_in,
  input wire shift_enable,
  output reg [NUM_BITS - 1:0] parallel_out 
);

reg [(NUM_BITS - 1): 0] next_state;

always_ff @ (posedge clk, negedge n_rst) begin
if (n_rst == 0) begin
	parallel_out <= '1;
end else begin
	parallel_out <= next_state;
end
end

always_comb begin
	next_state = '0;
	if (!shift_enable) begin
		next_state = parallel_out;
	end else begin
		if(SHIFT_MSB == 1) begin
			next_state = {parallel_out[NUM_BITS - 2 : 0], serial_in};
		end else begin
			next_state = {serial_in, parallel_out[NUM_BITS - 1 : 1]};
		end
	end
end
endmodule