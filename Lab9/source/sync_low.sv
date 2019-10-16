module sync_low
(
	input wire clk,
	input wire n_rst, 
	input wire async_in,
	output reg sync_out
);

reg meta = 0;

always_ff @ (posedge clk, negedge n_rst)
begin: sync
	if(1'b0 == n_rst) begin
		meta <= 1'b0;
		sync_out <= 1'b0;
	end
	else begin
		meta <= async_in;
		sync_out <= meta;
	end
end
endmodule
