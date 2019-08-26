// $Id: $
// File name:   sensor_d.sv
// Created:     8/25/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: dataflow style sensor error detector

module sensor_d
(
	input wire [3:0] sensors,
	output wire error
);

assign error = (sensors[0] || (sensors[1] & sensors[2]) || (sensors[1] & sensors[3])) ? 1 : 0;

endmodule
