module flex_counter
#(
	NUM_CNT_BITS = 4
)
(
	input wire clk, 
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS - 1 : 0] rollover_val,
	output reg [NUM_CNT_BITS - 1 : 0] count_out,
	output reg rollover_flag
);

reg [NUM_CNT_BITS - 1 : 0] temp_count = 0;
reg temp_flag = 1'b0;

always_ff @ (posedge clk, negedge n_rst) begin
  if(n_rst == 1'b0) begin
    count_out <= 0;
    rollover_flag <= 0;
  end
  else begin
    count_out <= temp_count;
      rollover_flag <= temp_flag;
  end
end

always_comb begin
temp_count = count_out;
temp_flag = rollover_flag;
if (clear) begin
	temp_count = 0;
	temp_flag = 1'b0;
end
else begin
	if (count_enable) begin
		temp_flag = 0;
		temp_count = temp_count + 1;
		if (temp_count == rollover_val) begin
			temp_flag = 1'b1;
		end
		else if (rollover_flag) begin
			temp_count = 1;
		end
	end
end
end

endmodule
