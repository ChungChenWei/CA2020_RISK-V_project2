module Hazard
(
    rst_i,

    IDEX_MemRead_i,
    IDEX_rd_addr_i, 
    rs1_addr_i,
    rs2_addr_i,

    PCWrite_o,
    NoOP_o,
    Stall_o
);
input          rst_i;
input          IDEX_MemRead_i;
input   [4:0]  IDEX_rd_addr_i;
input   [4:0]  rs1_addr_i, rs2_addr_i;

output         PCWrite_o;
output         NoOP_o;
output         Stall_o;

assign Stall_o   = (IDEX_MemRead_i == 1 && (IDEX_rd_addr_i == rs1_addr_i || IDEX_rd_addr_i == rs2_addr_i))? 1 : 0;

assign PCWrite_o = ~Stall_o;
assign NoOP_o    = Stall_o;

endmodule