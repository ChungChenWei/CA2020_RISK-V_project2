module Forward
(
	IDEX_rs1_addr_i,
	IDEX_rs2_addr_i,
	EXMEM_rd_addr_i,
	MEMWB_rd_addr_i,
	EXMEM_RegWrite_i,
	MEMWB_RegWrite_i,
	ForwardA_o,
	ForwardB_o
);

// Ports
input   [4:0] IDEX_rs1_addr_i, IDEX_rs2_addr_i; 
input   [4:0] EXMEM_rd_addr_i, MEMWB_rd_addr_i;
input		  EXMEM_RegWrite_i, MEMWB_RegWrite_i;
output  [1:0] ForwardA_o, ForwardB_o;

// Wires
wire EX_hazardA, EX_hazardB;
wire MEM_hazardA, MEM_hazardB;

assign EX_hazardA = (EXMEM_RegWrite_i == 1'b1) && (EXMEM_rd_addr_i != 5'b0) && (EXMEM_rd_addr_i == IDEX_rs1_addr_i);
assign EX_hazardB = (EXMEM_RegWrite_i == 1'b1) && (EXMEM_rd_addr_i != 5'b0) && (EXMEM_rd_addr_i == IDEX_rs2_addr_i);
assign MEM_hazardA = (MEMWB_RegWrite_i == 1'b1) && (MEMWB_rd_addr_i != 5'b0) && (MEMWB_rd_addr_i == IDEX_rs1_addr_i);
assign MEM_hazardB = (MEMWB_RegWrite_i == 1'b1) && (MEMWB_rd_addr_i != 5'b0) && (MEMWB_rd_addr_i == IDEX_rs2_addr_i);

assign ForwardA_o = (EX_hazardA == 1) ? 2'b10 :
					(MEM_hazardA == 1) ? 2'b01 :
					2'b00;

assign ForwardB_o = (EX_hazardB == 1) ? 2'b10 :
					(MEM_hazardB == 1) ? 2'b01 :
					2'b00;  

endmodule