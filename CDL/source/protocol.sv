module protocol
(
	input wire clk,
	input wire n_rst,
	input logic [3:0] rx_packet,
	input logic buffer_reserved,
	input logic [6:0] tx_packet_data_size,
	input logic [6:0] buffer_occupancy,
	input logic tx_busy,
	output logic d_mode,
	output logic [1:0] tx_packet,
	output logic clear,
	output logic tx_error,
	output logic tx_transfer_active,
	output logic rx_error,
	output logic rx_transfer_active,
	output logic rx_data_ready
);

typedef enum bit [4:0]{ IDLE, RX, RX_DATA, RX_ACK ,ACK_WAIT, RX_ERR, RX_NCK, NCK_WAIT, BUF_RESERVED, TX_RESERVED, TX_NCK, TX_DATA, HOST_NCK, HOST_WAIT} stateType;
stateType state;
stateType nxt_state;

always_ff@(negedge n_rst, posedge clk) begin: REG_LOGIC
  if(n_rst==0) begin
    state<=IDLE;
  end
  else begin
    state<=nxt_state;
  end
end

always_comb
begin
  nxt_state=state;
  case(state)
    IDLE:begin
	if(rx_packet == 4'b0001 && buffer_reserved == 0 && buffer_occupancy == 0)begin
	  nxt_state= RX;
	end
	else if(rx_packet == 4'b0001 && (buffer_reserved != 0 || buffer_occupancy != 0))begin
	  nxt_state= BUF_RESERVED;
	end
	else if(rx_packet == 4'b1001 && buffer_reserved == 0 && tx_packet_data_size == buffer_occupancy)begin
	  nxt_state= TX_DATA;
	end
	else if(rx_packet == 4'b1001 && (buffer_reserved != 0 || tx_packet_data_size != buffer_occupancy))begin
	  nxt_state= TX_NCK;
	end
	else begin
	  nxt_state=IDLE;
	end
    end

    RX:begin
	if(rx_packet == 4'b0011 || rx_packet == 4'b1011)begin
	nxt_state = RX_DATA;
	end
	else if (rx_packet == 4'b1100) begin
	nxt_state = RX_ERR;
	end
	else begin
	nxt_state = RX;
	end
    end

    RX_DATA:begin
	if(rx_packet == 4'b1111) begin	//EOP
	  nxt_state=RX_ACK;
	end
	else if (rx_packet == 4'b1100) begin
	  nxt_state=RX_ERR;		//ERR
	end
	else begin
	nxt_state = RX_DATA;
	end
    end    

    RX_ACK:begin
       nxt_state=ACK_WAIT;
    end
    
    ACK_WAIT:begin
	if(tx_busy) begin
	  nxt_state=ACK_WAIT;
	end
       
	else begin
	  nxt_state=IDLE;
	end
    end

    RX_ERR:begin
       nxt_state=RX_NCK;
    end
    RX_NCK:begin
       nxt_state=NCK_WAIT;
    end

    NCK_WAIT:begin
	if (tx_busy) begin
	nxt_state = NCK_WAIT;
	end
	else begin
       nxt_state=IDLE;
	end
    end

    BUF_RESERVED:begin
	if(rx_packet == 4'b1111)begin
       nxt_state=TX_RESERVED;
	end
	else begin 
	nxt_state = BUF_RESERVED;
	end
    end

    TX_RESERVED:begin
       nxt_state= NCK_WAIT;
    end

    TX_NCK:begin
       nxt_state=NCK_WAIT;
    end

    TX_DATA:begin
       nxt_state=HOST_WAIT;
    end

    HOST_WAIT:begin
	if(rx_packet == 4'b0010)begin
	nxt_state = IDLE;
	end
	else if (rx_packet == 4'b1010)begin
	nxt_state = HOST_NCK;
	end
	else begin
	nxt_state = HOST_WAIT;
	end
    end

    HOST_NCK:begin
       nxt_state=NCK_WAIT;
    end

    default: nxt_state = IDLE;

  endcase
end

always_comb
begin: OUT_LOGIC
    if(state==IDLE)
    begin
	d_mode = 0;
	clear = 1;
	rx_data_ready = 0;
	rx_transfer_active = 0;
	rx_error = 0;
	tx_transfer_active = 0;
	tx_error = 0;
	tx_packet = 2'b11;
    end

    else if(state==RX)
    begin
	rx_transfer_active = 1;
	clear = 0;
    end

    else if(state==RX_DATA)
    begin
	rx_transfer_active = 1;
	clear = 0;	
    end

    else if(state==RX_ACK)
    begin
	rx_data_ready = 1;
	tx_packet = 2'b00;
	d_mode = 1;
	rx_transfer_active = 0;
    end

    else if(state==ACK_WAIT)
    begin
	d_mode = 1;
    end

    else if(state==RX_NCK)
    begin
	rx_data_ready = 0;
	rx_error = 1;
	clear = 1;
	tx_packet = 2'b01;
	d_mode = 1;
    end

    else if(state == TX_DATA)
    begin
	d_mode = 1;
	tx_transfer_active = 1;
	tx_packet = 2'b10;
    end

    else if(state == HOST_WAIT)
    begin
	d_mode = 0;
    end

    else if(state == HOST_NCK)
    begin
	d_mode = 1;
	tx_transfer_active = 1;
	tx_packet = 2'b10;
	clear = 1;
	tx_error = 1;
    end

    else if(state == TX_NCK)
    begin
	d_mode = 1;
	tx_transfer_active = 1;
	tx_packet = 2'b01;
	tx_error = 1;
	clear = 1;
    end

    else if(state == BUF_RESERVED)
    begin
	d_mode = 1;
    end

    else if(state == TX_RESERVED)
    begin
	d_mode = 1;
	tx_transfer_active = 1;
	tx_packet = 2'b01;
	rx_error = 1;
    end

end
endmodule
