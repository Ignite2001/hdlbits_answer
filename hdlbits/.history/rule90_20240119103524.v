module top_module (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
/*
    parameter IDLE = 1'b0;
    parameter S1 =   1'b1;

    reg ns;
    reg cs;
    always @(*) begin
        case (cs)
            IDLE: begin
                if(load)
                    ns = S1;
                else
                    ns = IDLE;
            end
            S1: 
                ns = S1;
        endcase
    end

    always @(posedge clk) begin
        
    end
*/
    reg [511:0] regfile;
    reg flag_start;
    always @(posedge clk) begin
        if(load) begin
            regfile <= data;
            flag_start <= 1'b1;
        end
    end

    reg [511:0] regfile_nxt;
    wire [513:0] regtemp;
    assign regtemp = {1'b0, regfile, 1'b0};

        always @(*) begin
            
        end
    always @(posedge clk) begin
        if(flag_start)

        
    end

endmodule