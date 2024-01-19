module top_module (
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    parameter WALKING_LEFT = 1'b0;
    parameter WALKING_RIGHT = 1'b1;
    reg cs, ns;
    always @(posedge clk or negedge areset) begin
        if(!areset)
            cs <= WALKING_LEFT;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
            WALKING_LEFT: begin
                
            endif(bump_left
            default: 
        endcase
    end
endmodule   