module top_module (
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);
    parameter WALKING_LEFT = 3'b000;
    parameter WALKING_RIGHT = 3'b001;
    parameter FALLING_LEFT = 3'b010;
    parameter FALLING_RIGHT = 3'b011;
    parameter DIGGING_LEFT = 3'b100;
    parameter DIGGING_RIGHT = 3'b101;
    parameter DEAD = 3'b111;

    reg [2:0] cs, ns;
    //wire [4:0] cnt_fall;
    wire over_flag;
    reg walk_left_nxt, walk_right_nxt, aaah_nxt,digging_nxt;

    counter u_cnt
    (
        .clk(clk),
        .areset(areset),
        .en(!ground),
        .over_flag(over_flag)
    );

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
                if(!ground)
                    ns = cs;
                else if (!over_flag)
                    ns = WALKING_LEFT;
                else
                    ns = DEAD;
            end
            FALLING_RIGHT: begin
                if(!ground)
                    ns = cs;
                else if (!over_flag)
                    ns = WALKING_RIGHT;
                else
                    ns = DEAD;
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
            DEAD: begin
                ns = cs;
            end
        default: ns = cs;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset)begin
            walk_left <= 1'b1;
            walk_right <=1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        else begin
            walk_left <= walk_left_nxt;
            walk_right <=walk_right_nxt;
            aaah <= aaah_nxt;
            digging <= digging_nxt;
        end
    end
    always @(*) begin
        case (ns)
            WALKING_LEFT:begin
                walk_left_nxt = 1'b1;
                walk_right_nxt = 1'b0;
                aaah_nxt =1'b0;
                digging_nxt = 1'b0;
            end 
            WALKING_RIGHT: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt = 1'b1;
                aaah_nxt = 1'b0;
                digging_nxt = 1'b0;
            end
            FALLING_LEFT: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt = 1'b0;
                aaah_nxt =1'b1;
                digging_nxt = 1'b0;
            end
            FALLING_RIGHT: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt = 1'b0;
                aaah_nxt =1'b1;
                digging_nxt = 1'b0;
            end
            DIGGING_LEFT: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt = 1'b0;
                aaah_nxt =1'b0;
                digging_nxt = 1'b1;
            end
            DIGGING_RIGHT: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt = 1'b0;
                aaah_nxt =1'b0;
                digging_nxt = 1'b1;
            end
            DEAD: begin
                walk_left_nxt = 1'b0;
                walk_right_nxt =1'b0;
                aaah_nxt = 1'b0;
                digging_nxt = 1'b0;
            end
        endcase
    end
endmodule   

module counter (
    input clk,
    input areset,
    input en,
    output reg over_flag
);
    reg [4:0] cnt_nxt;
    reg [4:0] cnt;

    always @(posedge clk or posedge areset) begin
        if(areset)
            cnt <= 5'b0;
        else
            cnt <= cnt_nxt;
    end
    always @(*) begin
        if(!en)
            cnt_nxt = 5'b0;
        else if(cnt<=5'd20)
            cnt_nxt = cnt + 1'b1;
        else
            cnt_nxt = cnt;
    end

    reg over_flag_nxt;
    always @(posedge clk or posedge areset) begin
        if(areset)
            over_flag <= 1'b0;
        else
            over_flag <= over_flag_nxt;
    end

    always @(*) begin
        if(!en)
            over_flag_nxt = 1'b0;
        else if(cnt<5'd20)
            over_flag_nxt=1'b0;
        else
            over_flag_nxt = 1'b1;
    end
endmodule