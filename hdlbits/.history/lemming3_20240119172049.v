module top_module (
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    parameter WALKING_LEFT = 3'b000;
    parameter WALKING_RIGHT = 3'b001;
    parameter FALLING_LEFT = 3'b010;
    parameter FALLING_RIGHT = 3'b011;
    parameter DIGGING_LEFT = 3'b100;
    parameter DIGGING_RIGHT = 3'b101;
    parameter DEAD = 3'b111;

    reg [2:0] cs, ns;
    reg walk_left_nxt, walk_right_nxt, aaah_nxt,digging_nxt;
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
                else if(dig)
                    ns = DIGGING_LEFT;
                else if(bump_left)
                    ns = WALKING_RIGHT;
                else
                    ns = cs;
                end
            WALKING_RIGHT: begin
                if(!ground)
                    ns = FALLING_RIGHT;
                else if(dig)
                    ns = DIGGING_RIGHT;
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
                if(ground)
                    ns = WALKING_RIGHT;
                else
                    ns = cs;
            end
            DIGGING_LEFT: begin
                if(!ground)
                    ns = FALLING_LEFT;
                else
                    ns = cs;
            end
            DIGGING_RIGHT: begin
                if(!ground)
                    ns = FALLING_RIGHT;
                else
                    ns = cs;
            end
            default: ns = 3'b111;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset)begin
            walk_left_nxt <= 1'b1;
            walk_right_nxt <=1'b0;
            aaah_nxt <= 1'b0;
            digging_nxt <= 1'b0;
        end
        else
            case (ns)
                WALKING_LEFT:begin
                    walk_left_nxt <= 1'b1;
                    walk_right_nxt <= 1'b0;
                    aaah_nxt <=1'b0;
                    digging_nxt <= 1'b0;
                end 
                WALKING_RIGHT: begin
                    walk_left_nxt <= 1'b0;
                    walk_right_nxt <= 1'b1;
                    aaah_nxt <= 1'b0;
                    digging_nxt <= 1'b0;
                end
                FALLING_LEFT: begin
                    walk_left_nxt <= 1'b0;
                    walk_right_nxt <= 1'b0;
                    aaah_nxt <=1'b1;
                    digging_nxt <= 1'b0;
                end
                FALLING_RIGHT: begin
                    walk_left_nxt <= 1'b0;
                    walk_right_nxt <= 1'b0;
                    aaah_nxt <=1'b1;
                    digging_nxt <= 1'b0;
                end
                DIGGING_LEFT: begin
                    walk_left_nxt <= 1'b0;
                    walk_right_nxt <= 1'b0;
                    aaah_nxt <=1'b0;
                    digging_nxt <= 1'b1;
                end
                DIGGING_RIGHT: begin
                    walk_left_nxt <= 1'b0;
                    walk_right_nxt <= 1'b0;
                    aaah_nxt <=1'b0;
                    digging_nxt <= 1'b1;
                end
            endcase
    end

    assign walk_left = walk_left_nxt;
    assign walk_right = walk_right_nxt;
    assign aaah       = aaah_nxt;
    assign digging    = digging_nxt;
endmodule   

module counter (
    input clk,
    input areset,
    input en,
    output [4:0] cnt
);
    reg [4:0] cnt_nxt;
    always @(posedge clk or posedge areset) begin
        if(areset)
            cnt_nxt <= 5'b0;
        else if(en)
            cnt_nxt <= cnt + 1'b1;
    end
    assign cnt = en? cnt_nxt : 5'b0;
endmodule