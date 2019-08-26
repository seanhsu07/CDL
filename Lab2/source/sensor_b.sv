// $Id: $
// File name:   sensor_b.sv
// Created:     8/25/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: behavioral style sensor error detector design

module sensor_b
(
	input wire [3:0] sensors,
	output reg error
);

always_comb 
	begin
		error = sensors[0] || sensors[1] & sensors[2] || sensors[1] & sensors[3]; 
	end

endmodule
