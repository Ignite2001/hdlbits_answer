module SecADD #(
    parameter BitWid = 23
) (
    input clk,
    input rstn,
    input [BitWid-1 : 0] x_A,
    input [BitWid-1 : 0] x_B,
    input [BitWid-1 : 0] y_A,
    input [BitWid-1 : 0] y_B,
    input [BitWid-1 : 0] z_R,
    output [BitWid :0] s_A,
    output [BitWid :0] s_B
);
    wire [BitWid-1 : 0] Co_A;
    wire [BitWid-1 : 0] Co_B;
    wire [BitWid-1 : 0] Ci_A;
    wire [BitWid-1 : 0] Ci_B;
    assign Ci_A = {Co_A[BitWid-2 : 0], 1'b0};
    assign Ci_B = {Co_B[BitWid-2 : 0], 1'b0};

    genvar i;
    for (i = 0; i < BitWid; i = i + 1) begin: SecFA
        SecFA u0_FA (
            .clk(clk),
            .rstn(rstn),
            .x_A(x_A[i]),
            .x_B(x_B[i]),
            .y_A(y_A[i]),
            .y_B(y_B[i]),
            .Ci_A(Ci_A[i]),
            .Ci_B(Ci_B[i]),
            .z_R0(z_R[i]),
            .s_A(s_A[i]),
            .s_B(s_B[i]),
            .Co_A(Co_A[i]),
            .Co_B(Co_B[i])
        );
    end
    assign s_A[BitWid] = Co_A[BitWid-1];
    assign s_B[BitWid] = Co_B[BitWid-1];
endmodule