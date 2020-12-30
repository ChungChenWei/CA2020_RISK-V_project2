module EX_MEM
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUout_i,
    rs2_data_i,
    rd_addr_i,
    mem_stall_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUout_o,
    rs2_data_o,
    rd_addr_o
);

// Interface
input          clk_i, rst_i;
input          RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, mem_stall_i;

input  [31:0]  ALUout_i, rs2_data_i;
input   [4:0]  rd_addr_i;

output         RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;

output [31:0]  ALUout_o, rs2_data_o;
output  [4:0]  rd_addr_o;
// memory
reg            RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;

reg    [31:0]  ALUout_o, rs2_data_o;
reg     [4:0]  rd_addr_o;

always@(posedge clk_i or posedge rst_i) begin
    // use all non-blocking
    if(~rst_i && ~mem_stall_i) begin
        RegWrite_o  <=  RegWrite_i;
        MemtoReg_o  <=  MemtoReg_i;
        MemRead_o   <=  MemRead_i;
        MemWrite_o  <=  MemWrite_i;
        ALUout_o    <=  ALUout_i;
        rs2_data_o  <=  rs2_data_i;
        rd_addr_o   <=  rd_addr_i;
    end
end

endmodule