module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,

    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;     // [24] vaild [23] dirty [22:0] tag
output   [255:0]   data_o;    // 32 Bytes = 256 bits
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];
reg                LRU [0:15];

integer            i, j;

wire  hit0, hit1;

hit0  = tag[addr_i][0][24] && (tag[addr_i][0][22:0] == tag_i[22:0]);
hit1  = tag[addr_i][1][24] && (tag[addr_i][1][22:0] == tag_i[22:0]);
hit_o = hit0 or hit1;

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            LRU[i] <= 0;
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        // check tag -> hit
        if (hit0) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0][23] <= 1;
            tag[addr_i][0][24] <= 1;
            LRU[addr_i] <= 1;
        else if (hit1) begin
            data[addr_i][1] <= data_i;
            tag[addr_i][1][23] <= 1;
            tag[addr_i][1][24] <= 1;
            LRU[addr_i] <= 0;
        else begin
            if (LRU[addr_i]) begin
                data[addr_i][0] <= data_i;
                tag[addr_i][0][23] <= 1;
                tag[addr_i][0][24] <= 1;
            else begin
                data[addr_i][1] <= data_i;
                tag[addr_i][1][23] <= 1;
                tag[addr_i][1][24] <= 1;
            end
            LRU[addr_i] <= ~LRU[addr_i];
        end
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
data_o = hit0? data[addr_i][0]:
		 hit1? data[addr_i][1]:
		 data[addr_i][LRU[addr_i]];
tag_o =  hit0? tag[addr_i][0]:
		 hit1? tag[addr_i][1]:
		 tag[addr_i][LRU[addr_i]];
endmodule