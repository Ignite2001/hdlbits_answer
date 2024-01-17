`timescale  1ns / 1ps

module tb_SecADD;

// SecADD Parameters
parameter PERIOD  = 10;
parameter BitWid  = 23;

// SecADD Inputs
reg   clk                                  = 0 ;
reg   rstn                                 = 1 ;
reg   [BitWid-1 : 0]  x_A                  = 0 ;
reg   [BitWid-1 : 0]  x_B                  = 0 ;
reg   [BitWid-1 : 0]  y_A                  = 0 ;
reg   [BitWid-1 : 0]  y_B                  = 0 ;
reg   [BitWid-1 : 0]  z_R                = 0 ;

// SecADD Outputs
wire  [BitWid :0]  s_A                     ;
wire  [BitWid :0]  s_B                     ;

wire [BitWid : 0] x_unmasked               ;
wire [BitWid : 0] y_unmasked               ;
wire [BitWid : 0] s_unmasked               ;

assign x_unmasked = {1'b0, x_A ^ x_B};
assign y_unmasked = {1'b0, y_A ^ y_B};
assign s_unmasked = s_A ^ s_B;

//for debug input values
//wire is_ture= (s_unmasked==(x_unmasked+y_unmasked));

integer seed1=2;
initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*0.2) rstn  =  0;
    #(PERIOD*0.1) rstn  =  1;
end

SecADD #(
    .BitWid ( BitWid ))
 u_SecADD (
    .clk                     ( clk                    ),
    .rstn                    ( rstn                   ),
    .x_A                     ( x_A   [BitWid-1 : 0]   ),
    .x_B                     ( x_B   [BitWid-1 : 0]   ),
    .y_A                     ( y_A   [BitWid-1 : 0]   ),
    .y_B                     ( y_B   [BitWid-1 : 0]   ),
    .z_R                     ( z_R   [BitWid-1 : 0] ),

    .s_A                     ( s_A   [BitWid :0]      ),
    .s_B                     ( s_B   [BitWid :0]      )
);

integer i;
initial
begin
    #(PERIOD*10);
    for (i = 0; i<100; i=i+1) begin
    x_A = $random(seed1);
    x_B = $random(seed1) ^ x_A;
    y_A = $random(seed1);
    y_B = $random(seed1) ^ y_A;
    z_R = $random(seed1);
    #(PERIOD*23);
    end
    x_A = $random(seed1);
    x_B = (23'd1) ^ x_A;
    y_A = $random(seed1);
    y_B = (23'h7fffff) ^ y_A;
    #(PERIOD*23);
    #(PERIOD*10);
    $finish;
end

endmodule