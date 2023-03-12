`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module wb_stage(
	input logic [31:0] mem_wb_mem_result,
	input logic [31:0] mem_wb_alu_result,
	input logic mem_wb_rd_mem,
	input logic mem_wb_valid_inst,
	
	output logic [31:0] wb_reg_wr_data_out
);

assign wb_reg_wr_data_out = (mem_wb_rd_mem & mem_wb_valid_inst) ? mem_wb_mem_result : mem_wb_alu_result;

endmodule