module tb;
reg [2:0] temp=3'd7;
reg [100:0] a={{50{1'b1}},{50{1'b0}}};

wire test = a[temp*8];

endmodule