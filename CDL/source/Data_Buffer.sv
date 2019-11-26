module Data_Buffer
(
	input wire clk,
	input wire n_rst,
	input logic clear,
	input logic store_rx_packet_data,
	input logic [7:0] rx_packet_data,
	input logic get_tx_packet_data,
	input logic [1:0] data_size,
	input logic [31:0] tx_data,
	input logic store_tx_data,
	input logic get_rx_data,
	input logic buffer_reserved,

	output logic [6:0] buffer_occupancy,
	output logic [7:0] tx_packet_data,
	output logic [31:0] rx_data
);

reg [6:0] read_pointer;
reg [6:0] write_pointer;
reg [63:0][7:0] buffer;
reg [63:0][7:0] nxt_buffer;

assign buffer_occupancy = write_pointer - read_pointer;

always_comb begin
	if(store_rx_packet_data) begin
	nxt_buffer[write_pointer] = rx_packet_data;
	end
	else if(store_tx_data) begin
	nxt_buffer[31:0] = tx_data;
	end
end

always_comb begin
	if(get_tx_packet_data) begin
	tx_packet_data = buffer[read_pointer];
	end
	else if(get_rx_data) begin
	rx_data = {buffer[read_pointer], buffer[read_pointer + 1], buffer[read_pointer + 2] , buffer[read_pointer + 3]};
	end
end

always_ff@(negedge n_rst, posedge clk)begin
	if(n_rst == 0 || clear) begin
	buffer = '0;
	end
	else begin
	buffer = nxt_buffer;
	end
end

always_ff@(negedge n_rst, posedge clk) begin
	if(n_rst == 0)begin
		write_pointer = 0;
		read_pointer = 0;
	end
	if(clear) begin
		write_pointer = 0;
		read_pointer = 0;
	end
	if (store_tx_data == 1) begin
		write_pointer = 0;
	end
	else begin
		if(get_tx_packet_data)begin
		read_pointer = read_pointer + 1;
		end
		else if (get_rx_data)begin
			if(data_size == 2'b00) begin
			read_pointer = read_pointer + 1;
			end
			else if (data_size == 2'b10) begin
			read_pointer = read_pointer + 2;
			end
			else if (data_size == 2'b11) begin
			read_pointer = read_pointer + 4;
			end
		end
		else if(store_rx_packet_data)begin
		write_pointer = write_pointer + 1;
		end
		else if (store_tx_data)begin
			if(data_size == 2'b00) begin
			write_pointer = write_pointer + 1;
			end
			else if (data_size == 2'b10) begin
			write_pointer = write_pointer + 2;
			end
			else if (data_size == 2'b11) begin
			write_pointer = write_pointer + 4;
			end
		end
		else begin
		read_pointer = read_pointer;
		write_pointer = write_pointer;
		end
	end
end

endmodule