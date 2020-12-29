module MEM_WB
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    ALUout_i,
    Memout_i,
    rd_addr_i,
    mem_stall_i,

    RegWrite_o,
    MemtoReg_o,
    ALUout_o,
    Memout_o,
    rd_addr_o
);

// Interface
input          clk_i, rst_i;
input          RegWrite_i, MemtoReg_i, mem_stall_i;

input  [31:0]  ALUout_i, Memout_i;
input   [4:0]  rd_addr_i;

output         RegWrite_o, MemtoReg_o;

output [31:0]  ALUout_o, Memout_o;
output  [4:0]  rd_addr_o;
// memory
reg            RegWrite_o, MemtoReg_o;

reg    [31:0]  ALUout_o, Memout_o;
reg     [4:0]  rd_addr_o;

always@(posedge clk_i or posedge rst_i) begin
    // use all non-blocking
    if(~rst_i || ~mem_stall_i) begin
        RegWrite_o  <=  RegWrite_i;
        MemtoReg_o  <=  MemtoReg_i;
        ALUout_o    <=  ALUout_i;
        Memout_o    <=  Memout_i;
        rd_addr_o   <=  rd_addr_i;
    end
end

endmodule