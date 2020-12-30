module ID_EX
(
    clk_i,
    rst_i,

    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    rs1_data_i,
    rs2_data_i,
    rs1_addr_i,
    rs2_addr_i,
    rd_addr_i,
    funct_i,
    imm_i,
    mem_stall_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    rs1_data_o,
    rs2_data_o,
    rs1_addr_o,
    rs2_addr_o,
    rd_addr_o,
    funct_o,
    imm_o
);

// Interface
input          clk_i, rst_i;
input          RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, mem_stall_i;
input          ALUSrc_i;
input   [1:0]  ALUOp_i;

input  [31:0]  rs1_data_i, rs2_data_i;
input   [4:0]  rs1_addr_i, rs2_addr_i, rd_addr_i;
input   [9:0]  funct_i;
input  [31:0]  imm_i;

output         RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
output         ALUSrc_o;
output  [1:0]  ALUOp_o;

output [31:0]  rs1_data_o, rs2_data_o;
output  [4:0]  rs1_addr_o, rs2_addr_o, rd_addr_o;
output  [9:0]  funct_o;
output [31:0]  imm_o;
// memory
reg            RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
reg            RegWrite;
reg            ALUSrc_o;
reg     [1:0]  ALUOp_o;

reg    [31:0]  rs1_data_o, rs2_data_o;
reg     [4:0]  rs1_addr_o, rs2_addr_o, rd_addr_o;
reg     [9:0]  funct_o;
reg    [31:0]  imm_o;

always@(posedge clk_i or posedge rst_i) begin
    // use all non-blocking
    if(~rst_i && ~mem_stall_i) begin
        RegWrite_o  <=  RegWrite_i;
        MemtoReg_o  <=  MemtoReg_i;
        MemRead_o   <=  MemRead_i;
        MemWrite_o  <=  MemWrite_i;
        ALUOp_o     <=  ALUOp_i;
        ALUSrc_o    <=  ALUSrc_i;
        rs1_data_o  <=  rs1_data_i;
        rs2_data_o  <=  rs2_data_i;
        rs1_addr_o  <=  rs1_addr_i;
        rs2_addr_o  <=  rs2_addr_i;
        rd_addr_o   <=  rd_addr_i;
        funct_o     <=  funct_i;
        imm_o       <=  imm_i;
    end
end

endmodule