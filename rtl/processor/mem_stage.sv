`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module mem_stage(
    input logic   		clk,              // system clk
    input logic   		rst,              // system rst
    input logic [31:0] 	ex_mem_regb,        // regB value from reg file (store data)
    input logic [31:0] 	ex_mem_alu_result,  // incoming ALU result from EX
    input logic   		ex_mem_rd_mem,      // read memory? (from decoder)
    input logic      	ex_mem_wr_mem,      // write memory? (from decoder)
    input logic [31:0] 	Dmem2proc_data,
    input logic         ex_mem_valid_inst,

    output logic [31:0]	mem_result_out,    	// outgoing instruction result (to MEM/WB)
    output logic [1:0] 	proc2Dmem_command,	
    output logic [31:0] proc2Dmem_addr,    	// Address sent to data-memory
	output logic [31:0] proc2Dmem_data     	// Data sent to data-memory
);

// Determine the command that must be sent to mem
assign proc2Dmem_command = 	(ex_mem_wr_mem & ex_mem_valid_inst) ? `BUS_STORE : (ex_mem_rd_mem & ex_mem_valid_inst) ? `BUS_LOAD : `BUS_NONE;

// The memory address is calculated by the ALU
assign proc2Dmem_addr = ex_mem_alu_result;
assign proc2Dmem_data = ex_mem_regb;

// Assign the result-out for next stage
assign mem_result_out = (ex_mem_rd_mem) ? Dmem2proc_data : ex_mem_alu_result;

endmodule // module mem_stage
