module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;


Adder Add_PC1(
    .data0_in   (PC.pc_o),
    .data1_in   (4),
    .data_o     ()
);


Adder Add_PC2(
    .data0_in   ({Imm_Gen.imm_o[30:0], 1'b0}),
    .data1_in   (IF_ID.PC_o),
    .data_o     ()
);


MUX32 MUX_PC(
    .data0_i    (Add_PC1.data_o),
    .data1_i    (Add_PC2.data_o),
    .data2_i    (32'b0),
    .data3_i    (32'b0),
    .select_i   ({1'b0, AND.bool_o}), 
    .data_o     ()
);


MUX32 MUX_R1(
    .data0_i    (ID_EX.rs1_data_o),
    .data1_i    (MUX_WB.data_o),
    .data2_i    (EX_MEM.ALUout_o),
    .data3_i    (32'b0),
    .select_i   (Forward.ForwardA_o),
    .data_o     ()
);


MUX32 MUX_R2(
    .data0_i    (ID_EX.rs2_data_o),
    .data1_i    (MUX_WB.data_o),
    .data2_i    (EX_MEM.ALUout_o),
    .data3_i    (32'b0),
    .select_i   (Forward.ForwardB_o),
    .data_o     ()
);


MUX32 MUX_ALUSrc(
    .data0_i    (MUX_R2.data_o),
    .data1_i    (ID_EX.imm_o),
    .data2_i    (32'b0),
    .data3_i    (32'b0),
    .select_i   ({1'b0, ID_EX.ALUSrc_o}),
    .data_o     ()
);


MUX32 MUX_WB(
    .data0_i    (MEM_WB.ALUout_o),
    .data1_i    (MEM_WB.Memout_o),
    .data2_i    (32'b0),
    .data3_i    (32'b0),
    .select_i   ({1'b0, MEM_WB.MemtoReg_o}),
    .data_o     ()
);


Imm_Gen Imm_Gen(
    .instruc_i  (IF_ID.instruc_o[31:0]),
    .imm_o      ()
);


ALU ALU(
    .data0_i    (MUX_R1.data_o),
    .data1_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);


Zero Zero(
    .data0_i    (Registers.RS1data_o),
    .data1_i    (Registers.RS2data_o),
    .zero_o     ()
);


Control Control(
    .Op_i       (IF_ID.instruc_o[6:0]),
    .NoOP       (Hazard.NoOP_o),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .Branch_o   (),
    .MemRead_o  (),
    .MemWrite_o (),
    .MemtoReg_o (),
    .RegWrite_o ()
);


ALU_Control ALU_Control(
    .funct      (ID_EX.funct_o),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  ()
);


AND AND(
    .data0_i    (Control.Branch_o),
    .data1_i    (Zero.zero_o),
    .bool_o     ()
);


Forward Forward(
    .IDEX_rs1_addr_i    (ID_EX.rs1_addr_o),
    .IDEX_rs2_addr_i    (ID_EX.rs2_addr_o),
    .EXMEM_rd_addr_i    (EX_MEM.rd_addr_o),
    .MEMWB_rd_addr_i    (MEM_WB.rd_addr_o),
    .EXMEM_RegWrite_i   (EX_MEM.RegWrite_o),
    .MEMWB_RegWrite_i   (MEM_WB.RegWrite_o),
    .ForwardA_o         (),
    .ForwardB_o         ()
);


Hazard Hazard(
    .rst_i          (rst_i),
    .rs1_addr_i     (IF_ID.instruc_o[19:15]),
    .rs2_addr_i     (IF_ID.instruc_o[24:20]),
    .IDEX_MemRead_i (ID_EX.MemRead_o),
    .IDEX_rd_addr_i (ID_EX.rd_addr_o),
    .Stall_o        (),
    .PCWrite_o      (),
    .NoOP_o         ()
);


IF_ID IF_ID(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .IFID_Write_i   (~Hazard.Stall_o),
    .Flush_i        (AND.bool_o),
    .PC_i           (PC.pc_o),
    .instruc_i      (Instruction_Memory.instr_o[31:0]),
    .PC_o           (),
    .instruc_o      ()
);


ID_EX ID_EX(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .RegWrite_i (Control.RegWrite_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .MemRead_i  (Control.MemRead_o),
    .MemWrite_i (Control.MemWrite_o),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .rs1_data_i (Registers.RS1data_o),
    .rs2_data_i (Registers.RS2data_o),
    .rs1_addr_i (IF_ID.instruc_o[19:15]),
    .rs2_addr_i (IF_ID.instruc_o[24:20]),
    .rd_addr_i  (IF_ID.instruc_o[11:7]),
    .funct_i    ({IF_ID.instruc_o[31:25], IF_ID.instruc_o[14:12]}),
    .imm_i      (Imm_Gen.imm_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .rs1_data_o (),
    .rs2_data_o (),
    .rs1_addr_o (),
    .rs2_addr_o (),
    .rd_addr_o  (),
    .funct_o    (),
    .imm_o      ()
);


EX_MEM EX_MEM(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .RegWrite_i (ID_EX.RegWrite_o),
    .MemtoReg_i (ID_EX.MemtoReg_o),
    .MemRead_i  (ID_EX.MemRead_o),
    .MemWrite_i (ID_EX.MemWrite_o),
    .ALUout_i   (ALU.data_o),
    // .rs2_data_i (ID_EX.rs2_data_o),
    .rs2_data_i (MUX_R2.data_o),
    .rd_addr_i  (ID_EX.rd_addr_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    .ALUout_o   (),
    .rs2_data_o (),
    .rd_addr_o  ()
);


MEM_WB MEM_WB(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .RegWrite_i (EX_MEM.RegWrite_o),
    .MemtoReg_i (EX_MEM.MemtoReg_o),
    .ALUout_i   (EX_MEM.ALUout_o),
    .Memout_i   (Data_Memory.data_o),
    .rd_addr_i  (EX_MEM.rd_addr_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .ALUout_o   (),
    .Memout_o   (),
    .rd_addr_o  ()
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (Hazard.PCWrite_o),
    .pc_i       (MUX_PC.data_o),
    .pc_o       ()
);


Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    ()
);


Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (IF_ID.instruc_o[19:15]),
    .RS2addr_i  (IF_ID.instruc_o[24:20]),
    .RDaddr_i   (MEM_WB.rd_addr_o), 
    .RDdata_i   (MUX_WB.data_o),
    .RegWrite_i (MEM_WB.RegWrite_o), 
    .RS1data_o  (), 
    .RS2data_o  () 
);


Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (EX_MEM.ALUout_o),
    .MemRead_i  (EX_MEM.MemRead_o),
    .MemWrite_i (EX_MEM.MemWrite_o),
    .data_i     (EX_MEM.rs2_data_o),
    .data_o     ()
);


endmodule
