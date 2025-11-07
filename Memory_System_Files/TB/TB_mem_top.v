//==============================================================
// Verification Testbench for top_mem_sys  (unchanged except load delay)
//==============================================================
`timescale 1ns/1ps

module tb_top_mem_sys;

// ---------------------------------------------
// DUT I/O
// ---------------------------------------------
reg         clk;
reg         ena;
reg  [31:0] store_data;
reg  [2:0]  func3;
reg  [5:0]  addrA;
wire [31:0] load_data;

top_mem_sys dut (
    .clk        (clk),
    .ena        (ena),
    .store_data (store_data),
    .func3      (func3),
    .addrA      (addrA),
    .load_data  (load_data)
);

// ---------------------------------------------
// Clock generation
// ---------------------------------------------
initial clk = 1'b0;
always #5 clk = ~clk; // 100 MHz simulated clock

// ---------------------------------------------
// Local Parameters: func3 Definitions
// ---------------------------------------------
localparam [2:0] FUNC_SB  = 3'b000,
                 FUNC_SH  = 3'b001,
                 FUNC_SW  = 3'b010,
                 FUNC_LB  = 3'b000,
                 FUNC_LH  = 3'b001,
                 FUNC_LW  = 3'b010,
                 FUNC_LBU = 3'b100,
                 FUNC_LHU = 3'b101;

// ---------------------------------------------
// Verification Support
// ---------------------------------------------
integer num_passed = 0;
integer num_failed = 0;

// ---------------------------------------------
// Utilities
// ---------------------------------------------
task automatic chk (input bit cond, input string msg);
begin
    if (cond) begin
        $display("  ✅ PASS: %s", msg);
        num_passed++;
    end
    else begin
        $display("  ❌ FAIL: %s", msg);
        num_failed++;
    end
end
endtask

task automatic store (input [31:0] data,
                      input [5:0]  addr,
                      input [2:0]  func);
begin
    @(negedge clk);
    ena        = 1;
    store_data = data;
    addrA      = addr;
    func3      = func;
    @(posedge clk);   // one full cycle for memory write
    #2; //hold time;
    ena        = 0;
end
endtask

// FIX #3 - add small delay before sampling load_data
task automatic load (input [5:0] addr,
                     input [2:0] func,
                     output [31:0] data_out);
begin
    @(negedge clk);
    addrA = addr;
    func3 = func;
    @(posedge clk);
    #1;                 // allow combinational read to settle
    data_out = load_data;
end
endtask

// ---------------------------------------------
// Test Sequence (unchanged)
// ---------------------------------------------
initial begin
    reg [31:0] rd_word;
    reg [31:0] rd_lb;
    reg [31:0] rd_lbu;
    reg [31:0] rd_lh;
    reg [31:0] rd_lhu;
    reg [31:0] rd_unaligned;

    $display("=====================================================");
    $display("        Functional Verification: top_mem_sys        ");
    $display("=====================================================");

    ena        = 0;
    store_data = 32'h0;
    addrA      = 0;
    func3      = 3'b000;
    @(posedge clk);

    //---------------------------------------------------
    // TESTS
    //---------------------------------------------------
    $display("\n[TEST 1] Word store/load");
    store(32'hAABBCCDD, 6'd8, FUNC_SW);
    @(posedge clk); // ensure memory settles
    load(6'd8, FUNC_LW, rd_word);
    chk(rd_word === 32'hAABBCCDD, "Word read data matches written value");

    $display("\n[TEST 2] Byte store / sign-extended load (LB)");
    store(32'h000000F4, 6'd9, FUNC_SB);
    @(posedge clk);
    load(6'd9, FUNC_LB, rd_lb);
    chk(rd_lb === 32'hFFFFFFF4, "LB sign-extend negative byte");

    $display("\n[TEST 3] Byte store / zero-extended load (LBU)");
    load(6'd9, FUNC_LBU, rd_lbu);
    chk(rd_lbu === 32'h000000F4, "LBU zero-extend unsigned byte");

    $display("\n[TEST 4] Halfword store / sign-extend load (LH)");
    store(32'h0000F00D, 6'd10, FUNC_SH);
    @(posedge clk);
    load(6'd10, FUNC_LH, rd_lh);
    chk(rd_lh === 32'hFFFFF00D, "LH sign-extend -0xF00D");

    $display("\n[TEST 5] Halfword store / zero-extend load (LHU)");
    load(6'd10, FUNC_LHU, rd_lhu);
    chk(rd_lhu === 32'h0000F00D, "LHU zero-extend 0xF00D");

    $display("\n[TEST 6] Multiple byte positions");
    store(32'h000000AA, 6'd4, FUNC_SB);
    store(32'h000000BB, 6'd5, FUNC_SB);
    store(32'h000000CC, 6'd6, FUNC_SB);
    store(32'h000000DD, 6'd7, FUNC_SB);
    @(posedge clk);
    load(6'd4, FUNC_LW, rd_unaligned);
    chk(rd_unaligned === 32'hDDCCBBAA, "Unaligned byte writes assemble correctly");

    // SUMMARY
    $display("\n=====================================================");
    $display("  TEST SUMMARY:  %0d PASSED,  %0d FAILED", num_passed, num_failed);
    if (num_failed == 0)
        $display("  ✅ ALL TESTS PASSED");
    else
        $display("  ❌ SOME TESTS FAILED");
    $display("=====================================================");
    #20;
    $finish;
end

endmodule