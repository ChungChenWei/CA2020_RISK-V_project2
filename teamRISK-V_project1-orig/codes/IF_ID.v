module IF_ID
(
    clk_i,
    rst_i,

    IFID_Write_i,
    Flush_i,
    PC_i,
    instruc_i,

    PC_o,
    instruc_o
);

// Interface
input          clk_i, rst_i;
input          IFID_Write_i, Flush_i;

input  [31:0]  PC_i, instruc_i;
output [31:0]  PC_o, instruc_o;
// memory
reg    [31:0]  PC_o, instruc_o;

always@(posedge clk_i or posedge rst_i) begin
    // If write is set
    if(IFID_Write_i) begin 
        PC_o       <=  PC_i;
        instruc_o  <=  instruc_i;
    end
    // If flush is set
    if(Flush_i) begin
        PC_o       <=  32'b0;
        instruc_o  <=  32'b0;
    end
end

endmodule