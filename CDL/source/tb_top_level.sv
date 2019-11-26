// $Id: $
// File name:   tb_top_level.sv
// Created:     2/5/2013
// Author:      Olufiyisola Ogunkoya
// Lab Section: 003
// Version:     1.0  Initial Design Entry
// Description: starter top level test bench provided for CDL receiver

`timescale 1ns / 10ps

module tb_top_level();

  // Define parameters
  parameter CLK_PERIOD        = 10;
  parameter NORM_DATA_PERIOD  = (8 * CLK_PERIOD);
 
  localparam OUTPUT_CHECK_DELAY = (CLK_PERIOD - 0.2);
  localparam WORST_FAST_DATA_PERIOD = (NORM_DATA_PERIOD * 0.96);
  localparam WORST_SLOW_DATA_PERIOD = (NORM_DATA_PERIOD * 1.04);
 
  //  DUT inputs
  reg tb_clk;
  reg tb_n_rst;
  reg tb_d_plus;
  reg tb_d_minus;
 
  // DUT outputs
  wire [7:0] tb_rx_packet;
  wire [3:0] tb_rx_data;
  wire tb_store_rx_packet;
 
  // Test bench debug signals
  // Overall test case number for reference
  integer tb_test_num;
  string  tb_test_case;
  // Test case 'inputs' used for test stimulus
  reg [8:0] tb_test_data;
  reg       tb_test_stop_bit;
  time       tb_test_bit_period;
  reg        tb_test_data_read;
  // Test case expected output values for the test case
  reg [7:0] tb_expected_rx_packet;
  reg [3:0] tb_expected_rx_data;
  reg       tb_expected_store_rx_packet;
 
  // DUT portmap
  rcv_block DUT
  (
    .clk(tb_clk),
    .n_rst(tb_n_rst),
    .d_plus(tb_d_plus),
    .d_minus(tb_d_minus),
    .rx_packet(tb_rx_packet),
    .rx_data(tb_rx_data),
    .store_rx_packet(tb_store_rx_packet)
  );
 
  // Tasks for regulating the timing of input stimulus to the design
  task send_packet;
    input  [7:0] data;
    input  stop_bit;
    input  time data_period;
   
    integer i;
  begin
    // First synchronize to away from clock's rising edge
    @(negedge tb_clk)
   
    // Send start bit
    tb_d_plus = 1'b0;
    tb_d_minus = 1'b1;
    #data_period;
   
    // Send data bits
    for(i = 0; i < 8; i = i + 1)
    begin
      tb_d_plus = data[i];
      tb_d_minus = ~(data[i]);
      #data_period;
    end
  end
  endtask

  task send_payload_packet;
    input  [8:0] data;
    input  stop_bit;
    input  time data_period;
   
    integer i;
  begin
    // First synchronize to away from clock's rising edge
    @(negedge tb_clk)
   
    // Send data bits
    for(i = 0; i < 9; i = i + 1)
    begin
      tb_d_plus = data[i];
      tb_d_minus = ~(data[i]);
      #data_period;
    end
  end
  endtask
 
  task send_eop;
    input  [2:0] data;
    input  time data_period;
   
    integer i;
  begin
    // First synchronize to away from clock's rising edge
    @(negedge tb_clk)
   
    // Send data bits
    for(i = 0; i < 2; i = i + 1)
    begin
      tb_d_plus = data[i];
      tb_d_minus = data[i];
      #data_period;
    end
  end
  endtask

  task reset_dut;
  begin
    // Activate the design's reset (does not need to be synchronize with clock)
    tb_n_rst = 1'b0;
   
    // Wait for a couple clock cycles
    @(posedge tb_clk);
    @(posedge tb_clk);
   
    // Release the reset
    @(negedge tb_clk);
    tb_n_rst = 1;
   
    // Wait for a while before activating the design
    @(posedge tb_clk);
    @(posedge tb_clk);
  end
  endtask
 
  task check_outputs;
  begin
    // Don't need to syncrhonize relative to clock edge for this design's outputs since they should have been stable for quite a while given the 2 Data Period gap between the end of the packet and when this should be used to check the outputs
   
    // Data recieved should match the data sent
    assert(tb_expected_rx_packet == tb_rx_packet)
      $info("Test case %0d: Test data correctly received", tb_test_num);
    else
      $error("Test case %0d: Test data was not correctly received", tb_test_num);  
    assert(tb_expected_rx_data == tb_rx_data)
      $info("Test case %0d: packet type correct", tb_test_num);
    else
      $error("Test case %0d: packet type incorrect", tb_test_num);
  end
  endtask
 
  always
  begin : CLK_GEN
    tb_clk = 1'b0;
    #(CLK_PERIOD / 2);
    tb_clk = 1'b1;
    #(CLK_PERIOD / 2);
  end

  // Actual test bench process
  initial
  begin : TEST_PROC
    // Initialize all test bench signals
    tb_test_num                 = -1;
    tb_test_case                = "TB Init";
    tb_test_data                = '1;
    tb_test_stop_bit            = 1'b1;
    tb_test_bit_period          = NORM_DATA_PERIOD;
    tb_test_data_read           = 1'b0;
    tb_expected_rx_packet       = '1;
    tb_expected_rx_data         = '0;
    tb_expected_store_rx_packet = 1'b0;
    // Initilize all inputs to inactive/idle values
    tb_n_rst      = 1'b1; // Initially inactive
    tb_d_plus = 1'b1; // Initially idle
    tb_d_minus  = 1'b0; // Initially inactive
    // Get away from Time = 0
    #0.1;
   
    // Test case 0: Basic Power on Reset
    tb_test_num  = 0;
    tb_test_case = "Power-on-Reset";
   
    // Power-on Reset Test case: Simply populate the expected outputs
    // These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
    tb_test_data        = '1;
    tb_test_stop_bit    = 1'b1;
    tb_test_bit_period  = NORM_DATA_PERIOD;
    tb_test_data_read   = 1'b0;
   
    // Define expected ouputs for this test case
    // Note: expected outputs should all be inactive/idle values
    // For a good packet RX Data value should match data sent
    tb_expected_rx_data       = '0;    
    // DUT Reset
    reset_dut;
   
    // Check outputs
    check_outputs();
   
    // Test case 1: Full ACK Packet Sent
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Full ACK Packet sent";
   
    // Setup packet info for debugging/verificaton signals
    tb_test_data       = 9'b001010101;
    tb_test_stop_bit   = 1'b1;
    tb_test_bit_period = NORM_DATA_PERIOD;
   
    // Define expected ouputs for this test case
    // For a good packet RX Data value should match data sent
    tb_expected_rx_packet       = 8'b10110100;
    tb_expected_rx_data         = 4'b1111;    
    // DUT Reset
    reset_dut;
   
    // Send packet
    // Send packet
    send_payload_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
    tb_test_data       = 9'b100111001;
    send_payload_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
    tb_test_data       = 3'b000;
    send_eop(tb_test_data,tb_test_bit_period);
    #(tb_test_bit_period * 2);
     check_outputs();


    // Test case 2: Corrupted Sync Byte
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Bad Sync Byte Sent";
   
    // Setup packet info for debugging/verificaton signals
    tb_test_data       = 9'b000011111;
    tb_test_stop_bit   = 1'b1;
    tb_test_bit_period = NORM_DATA_PERIOD;
   
    // Define expected ouputs for this test case
    // For a good packet RX Data value should match data sent
    tb_expected_rx_packet       = 8'b11111111;
    tb_expected_rx_data       =  4'b1100;    
    // DUT Reset
    reset_dut;
   
    // Send packet
    send_payload_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
    // Wait for 2 data periods to allow DUT to finish processing the packet
    #(tb_test_bit_period * 2);
   
    // Check outputs
    check_outputs();
    tb_d_plus = 1'b1;
    #tb_test_bit_period;
    // Test case 3: Full ACK Packet Sent
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Full OUT TOKEN Packet ID Sent";
   
    // Setup packet info for debugging/verificaton signals
    tb_test_data       = 9'b001010101;
    tb_test_stop_bit   = 1'b1;
    tb_test_bit_period = NORM_DATA_PERIOD;
   
    // Define expected ouputs for this test case
    // For a good packet RX Data value should match data sent
    tb_expected_rx_packet       = 8'b10110100;
    tb_expected_rx_data         = 4'b1111;    
    // DUT Reset
    reset_dut;
   
    // Send packet
    // Send packet
    send_payload_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
    tb_test_data       = 9'b101111101;
    send_payload_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
    tb_test_data       = 3'b000;
    send_eop(tb_test_data,tb_test_bit_period);
    #(tb_test_bit_period * 2);
     check_outputs();


end
endmodule