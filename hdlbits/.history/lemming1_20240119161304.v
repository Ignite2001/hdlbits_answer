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
    reg walk_left_nxt, walk_right_nxt;
    always @(posedge clk or negedge areset) begin
        if(!areset)
            cs <= WALKING_LEFT;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
            WALKING_LEFT: begin 
                if(bump_left)
                    ns = WALKING_RIGHT;
                else
                    ns = WALKING_LEFT;
            end
            WALKING_RIGHT: begin
                if(bump_right)
                    ns = WALKING_LEFT;
                else
                    ns = WALKING_RIGHT;
            end
        endcase
    end

    always @(posedge clk) begin
        case (ns)
            WALKING_LEFT:begin
                walk_left_nxt <= 1'b1;
                walk_right_nxt <= 1'b0;
            end 
            WALKING_RIGHT: begin
                walk_left_nxt <= 1'b0;
                walk_right_nxt <= 1'b1;
            end
        endcase
    end

    assign walk_left = walk_left_nxt;
    assign walk_right = walk_right_nxt;
endmodule   