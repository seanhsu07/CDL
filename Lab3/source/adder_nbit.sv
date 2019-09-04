// $Id: $
// File name:   adder_4bit.sv
// Created:     8/28/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 4 bit adder design. 
`timescale 1ns / 100ps
module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(	input wire [BIT_WIDTH - 1:0] a,
	input wire [BIT_WIDTH - 1:0] b, 
	input wire carry_in, 
	output wire overflow, 
	output wire [BIT_WIDTH - 1:0] sum
);

wire [BIT_WIDTH:0] carrys;
genvar i;

assign carrys[0] = carry_in;

generate
for(i = 0; i <= BIT_WIDTH - 1; i = i+1)
	begin
		adder_1bit IX (.a (a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		always @ (a[i], b[i], carrys[i])
		begin
			#(2) assert(((a[i] + b[i] + carrys[i]) % 2) == sum[i])
			else $error ("Output 's' not correct");
		end
	end
endgenerate

assign overflow = carrys[BIT_WIDTH];

endmodule
