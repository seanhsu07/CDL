// $Id: $
// File name:   tb_protocol.sv
// Created:     10/1/2018
// Author:      Sean Hsu
// Lab Section: 3
// Version:     1.0  Initial Design Entry
// Description: Full ABH-Lite slave/bus model test bench

`timescale 1ns / 10ps

module tb_protocol();

// Timing related constants
localparam CLK_PERIOD = 10;
localparam BUS_DELAY  = 800ps; // Based on FF propagation delay

//*****************************************************************************
// Declare TB Signals (Bus Model Controls)
//*****************************************************************************
// Testing setup signals
bit [3:0]                    tb_rx_packet;
bit                          tb_buffer_reserved;
bit  [6:0]                   tb_tx_packet_data_size;
bit 			     tb_tx_busy;
bit [6:0] tb_buffer_occupancy;
bit tb_d_mode;
bit [1:0] tb_tx_packet;
bit tb_clear;
bit tb_tx_error;
bit tb_tx_transfer_active;
bit tb_rx_error;
bit tb_rx_transfer_active;
bit tb_rx_data_ready;

string                 tb_test_case;
integer                tb_test_case_num;
bit   [7:0] tb_test_data [];
string                 tb_check_tag;
logic                  tb_mismatch;
logic                  tb_check;

//*****************************************************************************
// General System signals
//*****************************************************************************
logic tb_clk;
logic tb_n_rst;

//*****************************************************************************
// Clock Generation Block
//*****************************************************************************
// Clock generation block
always begin
  // Start with clock low to avoid false rising edge events at t=0
  tb_clk = 1'b0;
  // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
  tb_clk = 1'b1;
  // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
  #(CLK_PERIOD/2.0);
end

//*****************************************************************************
// Bus Model Instance
//*****************************************************************************
protocol 
              ptc(.clk(tb_clk),
		.n_rst(tb_n_rst),
                  // Testing setup signals
                  .rx_packet(tb_rx_packet),
                  .buffer_reserved(tb_buffer_reserved),
                  .tx_packet_data_size(tb_tx_packet_data_size),
                  .buffer_occupancy(tb_buffer_occupancy),
                  .tx_busy(tb_tx_busy),

                  // Output Signals
                  .d_mode(tb_d_mode),
                  .tx_packet(tb_tx_packet),
                  .clear(tb_clear),
                  .tx_error(tb_tx_error),
                  .rx_error(tb_rx_error),
                  .rx_data_ready(tb_rx_data_ready),
                  .rx_transfer_active(tb_rx_transfer_active),
		  .tx_transfer_active(tb_tx_transfer_active));

//*****************************************************************************
// DUT Related TB Tasks
//*****************************************************************************
// Task for standard DUT reset procedure
task reset_dut;
begin
  // Activate the reset
  tb_n_rst = 1'b0;

  tb_buffer_reserved = 0;

  // Maintain the reset for more than one cycle
  @(posedge tb_clk);

  // Wait until safely away from rising edge of the clock before releasing
  @(negedge tb_clk);
  tb_n_rst = 1'b1;

  // Leave out of reset for a couple cycles before allowing other stimulus
  // Wait for negative clock edges, 
  // since inputs to DUT should normally be applied away from rising clock edges
  @(negedge tb_clk);
end
endtask

//*****************************************************************************
//*****************************************************************************
// Main TB Process
//*****************************************************************************
//*****************************************************************************
initial begin
  // Initialize Test Case Navigation Signals
  tb_test_case       = "Initialization";
  tb_test_case_num   = -1;
  tb_test_data       = new[1];
  tb_check_tag       = "N/A";
  tb_check           = 1'b0;
  tb_mismatch        = 1'b0;
  // Initialize all of the directly controled DUT inputs
  tb_n_rst          = 1'b1;
  // Initialize all of the bus model control inputs
  tb_rx_packet          = '0;
  tb_buffer_reserved  = 0;
  tb_tx_packet_data_size  = '0;
  tb_buffer_occupancy    = 0;
  tb_tx_busy     = 0;

  // Wait some time before starting first test case
  #(0.1);

  // Clear the bus model
  reset_dut();

  //*****************************************************************************
  // Power-on-Reset Test Case
  //*****************************************************************************
  // Update Navigation Info
/*  tb_test_case     = "Power-on-Reset";
  tb_test_case_num = tb_test_case_num + 1;
  
  // Reset the DUT
  reset_dut();

    if(tb_d_mode == 0) begin // Check passed
      $info("Correct output %s during %s test case", "d_mode", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case, %b == %b", "d_mode", tb_test_case, 0, tb_d_mode);
    end

  // No actual DUT -> Just a place holder currently
  
  //*****************************************************************************
  // Test Case: RX state
  //*****************************************************************************
  // Update Navigation Info\
  tb_test_case = "out token";
  tb_test_case_num = tb_test_case_num + 1;

  // goto RX
  tb_rx_packet = 4'b0001;
  tb_buffer_reserved = 0;
  tb_buffer_occupancy = 0;
  
  @(posedge tb_clk);
  @(negedge tb_clk); 
  
    if(tb_d_mode == 0 && tb_rx_transfer_active == 1) begin // Check passed
      $info("Correct output %s during %s test case", "d_mode and rx_transfer_active", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case, %b == %b", "d_mode and rx_transfer_active", tb_test_case, 1'b1, tb_rx_transfer_active);
    end

  //*****************************************************************************
  // Test Case: Receive data
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Receive data";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  tb_rx_packet = 4'b0001;
  tb_buffer_reserved = 0;
  tb_buffer_occupancy = 0;

  @(negedge tb_clk);

  tb_rx_packet = 4'b0011;

  @(negedge tb_clk);

  tb_rx_packet = 4'b1111;
  
  @(negedge tb_clk);

    if(tb_rx_data_ready == 1 && tb_tx_packet == 2'b00 && tb_d_mode == 1) begin // Check passed
      $info("Correct output %s during %s test case", "d_mode and rx_transfer_active", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case", "dr | tx | dmode", tb_test_case);
      $error("dr == %b ; tx == %b ; dmode == %b", tb_rx_data_ready , tb_tx_packet, tb_d_mode);
    end

  
  //*****************************************************************************
  // Test Case: Receive Data Error
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "RX";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  tb_rx_packet = 4'b0001;
  tb_buffer_reserved = 0;
  tb_buffer_occupancy = 0;

  @(negedge tb_clk);
  
  tb_rx_packet = 4'b1100;

  @(negedge tb_clk);

  tb_rx_packet = 4'b1111;

  @(negedge tb_clk);

    if(tb_rx_error == 1 && tb_tx_packet == 2'b01 && tb_d_mode == 1) begin // Check passed
      $info("Correct output %s during %s test case", "rxe & txp & dmode", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case", "rxe | txp | dmode", tb_test_case);
      $error("rxe == %b ; txp == %b ; dmode == %b", tb_rx_error , tb_tx_packet, tb_d_mode);
    end

  //*****************************************************************************
  // Test Case: Buffer Reserved
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "Buffer Reserved";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  // Enqueue the needed transactions
  // Create the Test Data for the burst
  tb_rx_packet = 4'b0001;
  tb_buffer_reserved = 1;
  tb_buffer_occupancy = 0;

  @(negedge tb_clk);

  tb_rx_packet = 4'b1111;

  @(negedge tb_clk);

    if(tb_rx_error == 1 && tb_tx_packet == 2'b01 && tb_d_mode == 1) begin // Check passed
      $info("Correct output %s during %s test case", " & txp & dmode", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case", "rxe | txp | dmode", tb_test_case);
      $error("rxe == %b ; txp == %b ; dmode == %b", tb_rx_error , tb_tx_packet, tb_d_mode);
    end

  
  //*****************************************************************************
  // Test Case: TX DATA
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "TX_Data";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

  tb_rx_packet = 4'b1001;
  tb_buffer_reserved = 0;
  tb_buffer_occupancy = 0;

  @(negedge tb_clk);

    if(tb_tx_transfer_active == 1 && tb_tx_packet == 2'b10 && tb_d_mode == 1) begin // Check passed
      $info("Correct output %s during %s test case", "txt & txp & dmode", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case", "rxe | txp | dmode", tb_test_case);
      $error("rxe == %b ; txp == %b ; dmode == %b", tb_rx_error , tb_tx_packet, tb_d_mode);
    end*/
  
  //*****************************************************************************
  // Test Case: TX Error
  //*****************************************************************************
  // Update Navigation Info
  tb_test_case     = "TX Error";
  tb_test_case_num = tb_test_case_num + 1;

  // Reset the DUT to isolate from prior test case
  reset_dut();

 tb_buffer_reserved = 1;
 @(negedge tb_clk);
  tb_rx_packet = 4'b1001;
 
  tb_buffer_occupancy = 0;

  @(negedge tb_clk);

    if(tb_tx_error == 1 && tb_tx_packet == 2'b01 && tb_d_mode == 1) begin // Check passed
      $info("Correct output %s during %s test case", "txe & txp & dmode", tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case", "rxe | txp | dmode", tb_test_case);
      $error("txe == %b ; txp == %b ; dmode == %b", tb_rx_error , tb_tx_packet, tb_d_mode);
    end
end

endmodule