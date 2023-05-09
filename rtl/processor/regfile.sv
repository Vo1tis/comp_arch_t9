`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module regfile(
	input logic clk,
	input logic rst,
	input logic [4:0] rda_idx, rdb_idx, wr_idx,		// read/write index
	input logic [31:0] wr_data,            			// write data
	input logic wr_en,
	
	input logic forward,
	
	input logic [4:0]	ex_stage_rd,
	input logic [4:0]	mem_stage_rd,
	input logic [4:0]	wb_stage_rd,
	
	input logic [31:0]	ex_stage_rdout,
	input logic [31:0]	mem_stage_rdout,
	input logic [31:0]	wb_stage_rdout,
	

	output logic[31:0] rda_out, rdb_out    			// read data
);
  
logic [31:0] registers [0:31];

logic[31:0] temp_a;
logic[31:0] temp_b;

assign rda_out = temp_a;//registers[rda_idx];
assign rdb_out = temp_b;//registers[rdb_idx];

always_ff @(posedge clk or posedge rst) begin : Write_port
	if(rst) begin
		for(int i=0;i<32;i++) begin
			registers[i]<=0;
		end
	end
	else begin
	
		if (wr_idx != `ZERO_REG && wr_en) begin
			registers[wr_idx] <=  wr_data;
		end
		
		// forward rs1 or rs2 from previous rds
		temp_a <= registers[rda_idx];
		temp_b <= registers[rdb_idx];
		
		if (forward) begin
		
			if (rda_idx == ex_stage_rd) begin // ex_stage
				temp_a <= ex_stage_rdout; // ex_alu_result_out
			end else begin
				if (rda_idx == mem_stage_rd) begin // mem_stage
					temp_a <= mem_stage_rdout; // mem_result_out
				end else begin
					if (rda_idx == wb_stage_rd) begin // wb_stage
						temp_a <= wb_stage_rdout;// wb_reg_wr_data_out
					end
				end
			end
			
			if (rdb_idx == ex_stage_rd) begin // ex_stage
				temp_b <= ex_stage_rdout;
			end else begin
				if (rdb_idx == mem_stage_rd) begin // mem_stage
					temp_b <= mem_stage_rdout;
				end else begin
					if (rdb_idx == wb_stage_rd) begin // wb_stage
						temp_b <= wb_stage_rdout;
					end
				end
			end

		end
			
	end
end


endmodule // regfile
