`define R_type 7'b0110011
`define I_type 7'b0010011
`define lw_op  7'b0000011
`define sw_op  7'b0100011
`define beq_op 7'b1100011
module Control
(
    Op_i,
    NoOP,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o
);

// Ports
input   [6:0] Op_i;
input 		  NoOP;
output  [1:0] ALUOp_o;
output        RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o,
			  ALUSrc_o, Branch_o;

assign RegWrite_o = (NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 1'b1 : 
				  	(Op_i == `I_type) ? 1'b1 :
				  	(Op_i == `lw_op) ? 1'b1 :
				  	(Op_i == `sw_op) ? 1'b0 :
				  	(Op_i == `beq_op) ? 1'b0 :
				 	1'b0;

assign MemtoReg_o = (NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 1'b0 : 
				  	(Op_i == `I_type) ? 1'b0 :
				  	(Op_i == `lw_op) ? 1'b1 :
				  	(Op_i == `sw_op) ? 1'bX :
				  	(Op_i == `beq_op) ? 1'bX :
				 	1'bx;

assign MemRead_o =  (NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 1'b0 : 
					(Op_i == `I_type) ? 1'b0 :
				  	(Op_i == `lw_op) ? 1'b1 :
				  	(Op_i == `sw_op) ? 1'b0 :
				  	(Op_i == `beq_op) ? 1'b0 :
				 	1'b0;

assign MemWrite_o = (NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 1'b0 : 
				  	(Op_i == `I_type) ? 1'b0 :
				  	(Op_i == `lw_op) ? 1'b0 :
				  	(Op_i == `sw_op) ? 1'b1 :
				  	(Op_i == `beq_op) ? 1'b0 :
				 	1'b0;

assign ALUOp_o = 	(NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 2'b10 : 
				 	(Op_i == `I_type) ? 2'b11 :
				 	(Op_i == `lw_op) ? 2'b00 :
				 	(Op_i == `sw_op) ? 2'b00 :
				 	(Op_i == `beq_op) ? 2'b01:
				 	2'b00;

assign ALUSrc_o = 	(NoOP == 1) ? 0 :
					(Op_i == `R_type) ? 1'b0 : 
				  	(Op_i == `I_type) ? 1'b1 :
				  	(Op_i == `lw_op) ? 1'b1 :
				  	(Op_i == `sw_op) ? 1'b1 :
				  	(Op_i == `beq_op) ? 1'b0 :
				 	1'b0;

assign Branch_o =   (NoOP == 1) ? 0 :
					(Op_i == `beq_op) ? 1'b1 : 1'b0;

endmodule
