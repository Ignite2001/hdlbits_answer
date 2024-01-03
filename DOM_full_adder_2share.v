
module DOM_indep_FullAdder /*#(
    parameter 
)*/
(
    input clk,
    input rstn,
    input x_DomainA,
    input x_DomainB,
    input y_DomainA,
    input y_DomainB,
    input z_Random0,
    output q_DomainA,
    output q_DomainB
);
//calculation layer
    wire Inner_product_DomainA;
    wire Cross_product_DomainA;
    wire Inner_product_DomainB;
    wire Cross_product_DomainB;

    assign Inner_product_DomainA = x_DomainA & y_DomainA;
    assign Cross_product_DomainA = (x_DomainA & y_DomainB) ^ z_Random0;
    assign Inner_product_DomainB = x_DomainB & y_DomainB;
    assign Cross_product_DomainB = (x_DomainB & y_DomainA) ^ z_Random0;

//resharing layer
    reg Inner_product_DomainA_q1;
    reg Cross_product_DomainA_q1;
    reg Inner_product_DomainB_q1;
    reg Cross_product_DomainB_q1;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            Inner_product_DomainA_q1<=1'b0;
            Cross_product
        end
    end


endmodule