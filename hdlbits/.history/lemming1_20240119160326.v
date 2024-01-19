module top_module (
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;
    reg cs, ns;
    always @(posedge clk or negedge areset) begin
        
    end
endmodule   