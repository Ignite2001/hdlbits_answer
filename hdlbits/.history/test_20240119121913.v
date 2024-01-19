module tb;
reg [2:0] temp=3'd7;
reg [100:0] a={{50{1'b1}},{50{1'b0}}};

wire test = a[temp*8];
reg [7:0] b = 8'b01010101;
wire [3:0] cnt_1_in_b = b[7]+b[6]+b[5]+b[4]+b[3]+b[2]+b[1]+b[0];
endmodule