// $Id: $
// File name:   adder_1bit.sv
// Created:     8/28/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 1-bit full adder

module adder_1bit
(	input wire a,
	input wire b, 
	input wire carry_in, 
	output wire carry_out, 
	output wire sum
);

assign sum = carry_in ^ (a ^ b);
assign carry_out = ((~carry_in) & b & a) | (carry_in & (b | a));
endmodule
