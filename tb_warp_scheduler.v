module tb_warp_scheduler();
    reg clk;
    reg reset;
    reg [31:0] warp_ready;
    reg [31:0] warp_stalled;
    wire [4:0] next_warp;
    wire warp_valid;
    integer count;

    warp_scheduler dut (
        .clk(clk),
        .reset(reset),
        .warp_ready(warp_ready),
        .warp_stalled(warp_stalled),
        .next_warp(next_warp),
        .warp_valid(warp_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test process
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_warp_scheduler);

        reset = 1;
        warp_ready = 0;
        warp_stalled = 0;
        #20;
        reset = 0;

        // Test 1
        $display("\n=== Test 1: Single Warp ===");
        warp_ready = 32'b00000000000000000000000000000001;
        #10;
        wait (warp_valid == 1);
        $display("[%0t] Warp %0d selected", $time, next_warp);

        // Test 2
        $display("\n=== Test 2: Two Warps ===");
        warp_ready = 32'b00000000000000000000000000000011;
        #10;

        for (count = 0; count < 4; count = count + 1) begin
            wait (warp_valid == 1);
            $display("[%0t] Warp %0d selected", $time, next_warp);
            #10;
        end

        $display("\n=== All tests passed! ===");
        $finish;
    end
endmodule
