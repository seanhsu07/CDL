// 337 TA Provided Lab 4 Testbench
// This code serves as a starer test bench for the synchronizer design
// STUDENT: Replace this message and the above header section with an
// appropriate header based on your other code files

// 0.5um D-FlipFlop Timing Data Estimates:
// Data Propagation delay (clk->Q): 670ps
// Setup time for data relative to clock: 190ps
// Hold time for data relative to clock: 10ps

`timescale 1ns / 10ps

module tb_flex_counter();

  // Define local parameters used by the test bench
  localparam  CLK_PERIOD    = 1;
  localparam  NUM_INPUT_BITS  = 4;

  localparam  FF_SETUP_TIME = 0.190;
  localparam  FF_HOLD_TIME  = 0.100;
  localparam  CHECK_DELAY   = (CLK_PERIOD - FF_SETUP_TIME); // Check right before the setup time starts
  
  localparam  INACTIVE_VALUE     = 1'b0;
  localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
  
  // Declare DUT portmap signals
  reg tb_clk;
  reg tb_n_rst;
  reg tb_count_enable;
  reg tb_clear;
  reg [NUM_INPUT_BITS - 1 : 0] tb_rollover_val;
  reg [NUM_INPUT_BITS - 1 : 0] tb_count_out;
  reg tb_rollover_flag;
  
  // Declare test bench signals
  integer tb_test_num;
  string tb_test_case;
  integer tb_stream_test_num;
  string tb_stream_check_tag;
  
  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_n_rst = 1'b0;
	tb_clear = 1'b0;
	tb_rollover_val = 10;
	tb_count_enable = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_n_rst =1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input reg [NUM_INPUT_BITS - 1 : 0] expected_count_out;
    input  expected_rollover_flag;
    input string check_tag;
  begin
    if(expected_count_out == tb_count_out && expected_rollover_flag == tb_rollover_flag) begin // Check passed
      $info("Correct output %s during %s test case", check_tag, tb_test_case);
    end
    else begin // Check failed
      $error("Incorrect output %s during %s test case, %b == %b", check_tag, tb_test_case, expected_count_out, tb_count_out);
    end
  end
  endtask

  // Clock generation block
  always
  begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  // Task for standard DUT reset procedure
  task clear;
  begin

    // Maintain the reset forone cycle
     @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_clear = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    tb_clear = 1'b0;
    @(negedge tb_clk);
  end
  endtask
  
  // DUT Port map
  flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val), .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));
  
  // Test bench main process
  initial
  begin
    // Initialize all of the test inputs
	reset_dut();
    tb_n_rst  = 1'b1;              // Initialize to be inactive
    tb_test_num = 0;               // Initialize test case counter
    tb_test_case = "Test bench initializaton";
    tb_stream_test_num = 0;
    tb_stream_check_tag = "N/A";
    // Wait some time before starting first test case
    #(0.1);
    
    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    tb_n_rst  = 1'b0;    // Activate reset
    tb_count_enable = 1'b0;
    tb_clear = 1'b0;
    
    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    check_output( RESET_OUTPUT_VALUE, 0,
                  "after reset applied");
    
    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output( RESET_OUTPUT_VALUE, 0,
                  "after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(posedge tb_clk);
    #(2 * FF_HOLD_TIME);
    tb_n_rst  = 1'b1;   // Deactivate the chip reset
    #0.1;
    // Check that internal state was correctly keep after reset release
    check_output( RESET_OUTPUT_VALUE, 0 ,
                  "after reset was released");


    // ************************************************************************    
    // Test Case 3: Rollover with vale 5
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Rollover with vale 5";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_rollover_val = 5;
    reset_dut();
    tb_rollover_val = 5;
    // Handle setup violation test case stimulus
    // Timing violations require value transisitions on input
    // -> Need to start with input at oppositte value of main stimulus
    tb_count_enable = 1;
    // Allow value to feed in to design
    @(posedge tb_clk);

    // Wait for DUT to process the stimulus
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(negedge tb_clk); 
    tb_count_enable = 1'b0;
@(posedge tb_clk); 

    check_output(1, 0, "after processing delay");
    // ************************************************************************    
    // Test Case 4: Countinuous counting
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Continuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
    tb_count_enable = 0;
    tb_rollover_val = 10;
    reset_dut();
    @(posedge tb_clk);
    tb_count_enable = 1;
    // Wait until test is inside the setup time before the next rising clock edge
    #(CLK_PERIOD - (FF_SETUP_TIME * 0.5)); 
    // Change the input value

    // Wait for DUT to process the stimulus
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(negedge tb_clk); 

    // Move away from risign edge and allow for propagation delays before checking
tb_count_enable = 1'b0;
@(posedge tb_clk); 

    check_output(4'b1010, 1, "after processing delay");
    
    // ************************************************************************
    // Test Case 5: Discontinuous Counting
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Discontinuous counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
	tb_count_enable = 0;
	tb_rollover_val = 10;
    reset_dut();
    @(posedge tb_clk);
    tb_count_enable = 1;
    // Wait until test is inside the setup time before the next rising clock edge
    #(CLK_PERIOD - (FF_SETUP_TIME * 0.5)); 
    // Change the input value

    // Wait for DUT to process the stimulus
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
	tb_count_enable = 0;
    @(posedge tb_clk); 
	tb_count_enable = 1;
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    // Move away from risign edge and allow for propagation delays before checking
#(CHECK_DELAY);
    check_output(7, 0, "Dis. Count");
@(posedge tb_clk); 
    
    // STUDENT: Add your additional test cases here
    // ************************************************************************
    // Test Case 6: Clearing while counting
    // ************************************************************************
    @(negedge tb_clk); 
    tb_test_num = tb_test_num + 1;
    tb_test_case = "Clearing while counting";
    // Start out with inactive value and reset the DUT to isolate from prior tests
	tb_count_enable = 0;
	tb_rollover_val = 10;
    reset_dut();
    @(posedge tb_clk);
    tb_count_enable = 1;
    // Wait until test is inside the setup time before the next rising clock edge
    #(CLK_PERIOD - (FF_SETUP_TIME * 0.5)); 
    // Change the input value

    // Wait for DUT to process the stimulus
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
	tb_clear = 1;
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    @(posedge tb_clk); 
    // Move away from risign edge and allow for propagation delays before checking
#(CHECK_DELAY);
    check_output(0, 0, "end");
    @(posedge tb_clk); 
    tb_clear = 0;
@(posedge tb_clk); 
@(posedge tb_clk); 

  end
endmodule
