module AND
(
    data0_i,
    data1_i,
    bool_o
);

// Ports
input   data0_i, data1_i;
output  bool_o;

assign bool_o = (data0_i & data1_i);

endmodule
