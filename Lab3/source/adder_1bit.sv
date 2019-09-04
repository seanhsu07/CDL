// $Id: $
// File name:   adder_1bit.sv
// Created:     8/28/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 1-bit full adder
`timescale 1ns / 100ps
module adder_1bit
(	input wire a,
	input wire b, 
	input wire carry_in, 
	output wire carry_out, 
	output wire sum
);

always @ (a)
begin
	#(2) assert((a == 1'b1) || (a == 1'b0))
	else $error ("Imput 'a' of component is not a digital logic value");
	#(2) assert((b == 1'b1) || (b == 1'b0))
	else $error ("Imput 'a' of component is not a digital logic value");
	#(2) assert((carry_in == 1'b1) || (carry_in == 1'b0))
	else $error ("Imput 'a' of component is not a digital logic value");

end


assign sum = carry_in ^ (a ^ b);
assign carry_out = ((~carry_in) & b & a) | (carry_in & (b | a));
endmodule
