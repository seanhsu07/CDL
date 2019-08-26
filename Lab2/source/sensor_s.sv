// $Id: $
// File name:   sensor_s.sv
// Created:     8/25/2019
// Author:      Sean Hsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: structural style sensor error detector design

module sensor_s
(
	input wire [3:0] sensors, 
	output wire error
);

reg int_and_1;
reg int_and_2;

AND2X1 A1 (.Y(int_and_1), .A(sensors[1]), .B(sensors[2]));
AND2X1 A2 (.Y(int_and_2), .A(sensors[1]), .B(sensors[3]));
or (error, int_and_1, int_and_2, sensors[0]);

endmodule
