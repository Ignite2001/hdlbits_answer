module SecFA (
    input clk,
    input rstn,
    input x_A,
    input x_B,
    input y_A,
    input y_B,
    input Ci_A,
    input Ci_B,
    input z_R0,
//    input z_R1,
    output reg s_A,
    output reg s_B,
    output Co_A,
    output Co_B
);
//s=x^y^ci; co=x ^ ((x^y)*(x^ci))
// s_A, s_B directly output from registers;
// Co have 2 xor gate delays
    wire p1_A, p1_B, p2_A, p2_B; //p1=x^y, p2=x^ci
    wire s_q0_A, s_q0_B;
    wire q_A, q_B;               //output of p1 * p2
    reg x_q1_A, x_q1_B;

    assign p1_A = x_A ^ y_A;
    assign p1_B = x_B ^ y_B;
    assign p2_A = x_A ^ Ci_A;
    assign p2_B = x_B ^ Ci_B;

    assign s_q0_A = p1_A ^ Ci_A;
    assign s_q0_B = p1_B ^ Ci_B;

    SecAND_indep u0_AND (
        .clk(clk),
        .rstn(rstn),
        .x_A(p1_A),
        .x_B(p1_B),
        .y_A(p2_A),
        .y_B(p2_B),
        .z_R0(z_R0),
        .q_A(q_A),
        .q_B(q_B)
    );
    assign Co_A = x_q1_A ^ q_A;
    assign Co_B = x_q1_B ^ q_B;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            s_A <=1'b0;
            s_B <=1'b0;
        end
        else begin
            s_A <= s_q0_A;
            s_B <= s_q0_B;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x_q1_A <=1'b0;
            x_q1_B <=1'b0;
        end
        else begin
            x_q1_A <= x_A;
            x_q1_B <= x_B;
        end
    end

//s=x^y^ci; co=(x*y) ^ ((x^y)*ci)
/*  
    wire p_A, p_B, Cg_A,Cg_B;
    wire Cp_A, Cp_B;
    wire s_A_q0, s_B_q0;
    assign p_A = x_A ^ y_A;
    assign p_B = x_B ^ y_B;
    assign s_A_q0 = p_A ^ Ci_A;
    assign s_B_q0 = p_B ^ Ci_B;

    SecAND_indep u0_AND (
        .clk(clk),
        .rstn(rstn),
        .x_A(x_A),
        .x_B(x_B),
        .y_A(y_A),
        .y_B(y_B),
        .z_R0(z_R0),
        .q_A(Cg_A),
        .q_B(Cg_B)
    );

    SecAND_indep u1_AND (
        .clk(clk),
        .rstn(rstn),
        .x_A(p_A),
        .x_B(p_B),
        .y_A(Ci_A),
        .y_B(Ci_B),
        .z_R0(z_R1),
        .q_A(Cp_A),
        .q_B(Cp_B)
    );

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            s_A <=1'b0;
            s_B <=1'b0;
        end
        else begin
            s_A <= s_A_q0;
            s_B <= s_B_q0;
        end
    end

    //assign s_A = p_q1_A ^ Ci_A;
    //assign s_B = p_q1_B ^ Ci_B;

    assign Co_A = Cg_A ^ Cp_A;
    assign Co_B = Cg_B ^ Cp_B;
*/
endmodule