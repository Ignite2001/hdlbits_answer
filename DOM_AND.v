module SecAND_indep (
    input clk,
    input rstn,
    input x_A,
    input x_B,
    input y_A,
    input y_B,
    input z_R0,
    output q_A,
    output q_B
);
/*
    This Module is implemented as described in DOM_indep multiplier with 2-stage pipeline style
*/
//calculation layer
    wire [1:0] Product_A;
    wire [1:0] Product_B;
    assign Product_A={x_A & y_A, (x_A & y_B) ^ z_R0};
    assign Product_B={x_B & y_B, (x_B & y_A) ^ z_R0};
//resharing layer
    reg [1:0] Product_A_q1;
    reg [1:0] Product_B_q1;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            Product_A_q1 <= 2'b00;
            Product_B_q1 <= 2'b00;
        end
        else begin
            Product_A_q1 <= Product_A;
            Product_B_q1 <= Product_B;
        end
    end
//integration layer
    assign q_A = ^Product_A_q1;
    assign q_B = ^Product_B_q1;
endmodule