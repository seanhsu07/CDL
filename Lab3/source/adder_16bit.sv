// 337 TA Provided Lab 2 8-bit adder wrapper file template
// This code serves as a template for the 8-bit adder design wrapper file 
// STUDENT: Replace this message and the above header section with an
// appropriate header based on your other code files

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

genvar i;

generate
	for (i=0; i <= 15; i = i + 1) begin 
		always @ (a[i], b[i], carry_in) begin
			assert((a[i] == 1) || (a[i] == 0))
			else $error("Input a is not a digital logic value");
			assert((b[i] == 1) || (b[i] == 0))
			else $error("Input b is not a digital logic value");
			assert((carry_in == 1) || (carry_in == 0))
			else $error("Input carry is not a digital logic value");
		end
	end
endgenerate

	adder_nbit #(.BIT_WIDTH(16)) IX (.a (a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));

endmodule
