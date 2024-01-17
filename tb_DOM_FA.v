`timescale  1ns / 1ps

module tb_SecFA;

// SecFA Parameters
parameter PERIOD  = 10;


// SecFA Inputs
reg   clk                                  = 0 ;
reg   rstn                                 = 1 ;
reg   x_A                                  = 0 ;
reg   x_B                                  = 0 ;
reg   y_A                                  = 0 ;
reg   y_B                                  = 0 ;
reg   Ci_A                                 = 0 ;
reg   Ci_B                                 = 0 ;
reg   z_R0                                 = 0 ;
//reg   z_R1                                 = 0 ;

// SecFA Outputs
wire  s_A                                  ;
wire  s_B                                  ;
wire  Co_A                                 ;
wire  Co_B                                 ;


//signals for test
wire [1:0] res = {Co_A^Co_B, s_A^s_B};
wire x_unmasked = x_A ^ x_B;
wire y_unmasked = y_A ^ y_B;
wire Ci_unmasked = Ci_A ^ Ci_B;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*0.2) rstn  =  0;
    #(PERIOD*0.1) rstn  =  1;
end

SecFA  u_SecFA (
    .clk                     ( clk    ),
    .rstn                    ( rstn   ),
    .x_A                     ( x_A    ),
    .x_B                     ( x_B    ),
    .y_A                     ( y_A    ),
    .y_B                     ( y_B    ),
    .Ci_A                    ( Ci_A   ),
    .Ci_B                    ( Ci_B   ),
    .z_R0                    ( z_R0   ),
//    .z_R1                    ( z_R1   ),

    .s_A                     ( s_A    ),
    .s_B                     ( s_B    ),
    .Co_A                    ( Co_A   ),
    .Co_B                    ( Co_B   )
);


integer i;
initial
begin
    #(PERIOD * 10);
    for ( i = 0; i<=127; i=i+1) begin
        
        x_A = (i>>3) & 1;
        x_B = ((i>>0) & 1) ^ x_A;
        y_A = (i>>4) & 1;
        y_B = ((i>>1) & 1) ^ y_A;
        Ci_A = (i>>3) & 1;
        Ci_B = ((i>>2) & 1) ^ Ci_A;
        //{z_R1,z_R0} = $random(seed1+6);
        z_R0 = (i>>6) & 1;
        
        /*
        x_A = 1;
        x_B = 1 ^ x_A;
        y_A = 1;
        y_B = 1 ^ y_A;
        Ci_A = 1;
        Ci_B = 1 ^ Ci_A;
        //{z_R1,z_R0} = $random(seed1+6);
        z_R0 = 1;
        */
        #(PERIOD);
    end
    #(PERIOD*10);
    $finish;
end

endmodule