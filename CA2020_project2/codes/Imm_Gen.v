module Imm_Gen
(
    instruc_i,
    imm_o
);

input  [31:0] instruc_i;
output [31:0] imm_o;

assign imm_o = (instruc_i[5] == 0) ? {{20{instruc_i[31]}}, instruc_i[31:20]} :
               (instruc_i[6] == 0) ? {{20{instruc_i[31]}}, instruc_i[31:25], instruc_i[11:7]} :
                                     {{20{instruc_i[31]}}, instruc_i[31], instruc_i[7], instruc_i[30:25], instruc_i[11:8]};

endmodule