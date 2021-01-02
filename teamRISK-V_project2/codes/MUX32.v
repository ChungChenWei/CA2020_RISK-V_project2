module MUX32
(
    data0_i, 
    data1_i,
    data2_i, 
    data3_i,
    select_i,
    data_o
);

// Ports
input  [31:0] data0_i, data1_i, data2_i, data3_i;
input   [1:0] select_i;

output [31:0] data_o;
 
assign data_o = (select_i == 2'b00) ? data0_i :
                (select_i == 2'b01) ? data1_i : 
                (select_i == 2'b10) ? data2_i : 
                (select_i == 2'b11) ? data3_i : 32'bx;

endmodule