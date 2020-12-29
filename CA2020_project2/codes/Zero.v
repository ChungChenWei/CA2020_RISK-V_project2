module Zero
(
    data0_i,
    data1_i,
    zero_o
);

// Ports
input  [31:0] data0_i, data1_i;
output        zero_o;

assign zero_o = (data0_i == data1_i)? 1'b1 : 1'b0;

endmodule
