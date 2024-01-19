module top_module (
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right,
    output aaah
);
    parameter WALKING_LEFT = 2'b00;
    parameter WALKING_RIGHT = 2'b01;
    parameter FALLING_LEFT = 2'b10;
    parameter FALLING_RIGHT = 2'b11 ;
    reg cs, ns;
    reg walk_left_nxt, walk_right_nxt, aaah_nxt;
    always @(posedge clk or posedge areset) begin
        if(areset)
            cs <= WALKING_LEFT;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
            WALKING_LEFT: begin
                if(!ground)
                    ns = FALLING_LEFT;
                else if(bump_left)
                    ns = WALKING_RIGHT;
                else
                    ns = cs;
                end
            WALKING_RIGHT: begin
                if(!ground)
                    ns = FALLING_RIGHT;
                else if(bump_right)
                    ns = WALKING_LEFT;
                else
                    ns = cs;
            end
            FALLING_LEFT: begin
                if(ground)
                    ns = WALKING_LEFT;
                else
                    ns = cs;
            end
            FALLING_RIGHT: begin
                if(ground)begin
                    ns = WALKING_RIGHT;
                end
            end
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset)begin
            walk_left_nxt <= 1'b1;
            walk_right_nxt <=1'b0;
        end
        else
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