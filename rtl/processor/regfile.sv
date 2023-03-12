`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module regfile(
	input logic clk,
	input logic rst,
	input logic [4:0] rda_idx, rdb_idx, wr_idx,		// read/write index
	input logic [31:0] wr_data,            			// write data
	input logic wr_en,

	output logic[31:0] rda_out, rdb_out    			// read data
);
  
logic [31:0] registers [0:31];   

assign rda_out = registers[rda_idx];
assign rdb_out = registers[rdb_idx];

always_ff @(posedge clk or posedge rst) begin : Write_port
	if(rst) begin
		for(int i=0;i<32;i++) begin
			registers[i]<=0;
		end
	end
	else begin
		if(wr_idx != `ZERO_REG && wr_en) 
			registers[wr_idx] <=  wr_data;
	end
end
endmodule // regfile
