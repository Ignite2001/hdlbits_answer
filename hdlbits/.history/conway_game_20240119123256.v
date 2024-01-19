module top_module (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
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
    reg [255:0] regfile;
    reg [255:0] regfile_nxt;
    reg flag_start;
    always @(posedge clk) begin
        if(load) begin
            regfile <= data;
            flag_start <= 1'b1;
        end
        else if(flag_start)
            regfile <= regfile_nxt;
    end

    reg [4:0] num_neighbor[255:0];
    //wire [7:0] neighbor;
    //assign regtemp = {1'b0, regfile, 1'b0};
    reg [7:0] neighbor[255:0];
    reg [3:0] i_mod16_upper[255:0];
    reg [3:0] i_mod16_lower[255:0];
    reg [3:0] j_mod16_left[255:0];
    reg [3:0] j_mod16_right[255:0];


    generate
        genvar i,j;
        for (i = 0; i < 16; i = i + 1) begin: logic_unit_row
            for (j = 15; j >= 0; j =j - 1) begin: logic_unit
            //row 0: left i+2, center i+1, right i;
                always @(*) begin
                    i_mod16_lower[i*16+j] = i + 4'd1;
                    i_mod16_upper[i*16+j] = i - 4'd1;
                    j_mod16_left[i*16+j]  = j + 4'd1;
                    j_mod16_right[i*16+j] = j - 4'd1;
                end

                always @(*) begin
                    neighbor[i*16+j] = {regfile[(i_mod16_upper[i*16+j])*16+j_mod16_left[i*16+j]],    regfile[(i_mod16_upper[i*16+j])*16+j],     regfile[(i_mod16_upper[i*16+j])*16+j_mod16_right[i*16+j]],
                                regfile[i*16+j_mod16_left[i*16+j]],                                                 regfile[i*16+j_mod16_right[i*16+j]],
                                regfile[(i_mod16_lower[i*16+j])*16+j_mod16_left[i*16+j]],     regfile[(i_mod16_lower[i*16+j])*16+j],    regfile[(i_mod16_lower[i*16+j])*16+j_mod16_right[i*16+j]]};  
                end

                always @(*) begin
                    num_neighbor[i*16+j] = neighbor[7]+neighbor[6]+neighbor[5]+neighbor[4]+neighbor[3]+neighbor[2]+neighbor[1]+neighbor[0];
                end

                always @(*) begin
                    case (num_neighbor[i*16+j])
                        4'b0010: regfile_nxt[i*16+j] = regfile[i*16+j];
                        4'b0011: regfile_nxt[i*16+j] = 1'b1;
                        default: regfile_nxt[i*16+j] = 1'b0;
                    endcase
                end

            end
        end
    endgenerate



    assign q = regfile;
endmodule