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
    reg [511:0] regfile_nxt;
    reg flag_start;
    always @(posedge clk) begin
        if(load) begin
            regfile <= data;
            flag_start <= 1'b1;
        end
        else if(flag_start)
            regfile <= regfile_nxt;
    end


    wire [513:0] regtemp;
    assign regtemp = {1'b0, regfile, 1'b0};


    generate
        genvar i;
        for (i = 0; i < 512; i = i + 1) begin: xor_unit
            always @(*) begin
            regfile_nxt[i] = regtemp[i] ^ regtemp[i+2];
        end
    end
    endgenerate



    assign q = regfile;
endmodule