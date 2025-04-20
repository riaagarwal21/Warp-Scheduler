module warp_scheduler (
    input clk,
    input reset,
    input [31:0] warp_ready,
    input [31:0] warp_stalled,
    output reg [4:0] next_warp,
    output reg warp_valid
);
    reg [4:0] current_ptr;
    wire [31:0] warp_eligible;

    assign warp_eligible = warp_ready & ~warp_stalled;

    integer i;
    reg [4:0] selected;
    reg found;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_ptr <= 0;
            next_warp <= 0;
            warp_valid <= 0;
        end else begin
            found = 0;
            selected = 0;
            warp_valid = 0;

            for (i = 0; i < 32; i = i + 1) begin
                if (!found && warp_eligible[(current_ptr + i) % 32]) begin
                    selected = (current_ptr + i) % 32;
                    found = 1;
                end
            end

            if (found) begin
                next_warp <= selected;
                warp_valid <= 1;
                current_ptr <= (selected + 1) % 32;
            end
        end
    end
endmodule
