`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module if_stage  (input logic 	      clk,             // system clk
				  input logic 	      rst,             // system rst
				  input logic 	      mem_wb_valid_inst, 
			      input logic   	  ex_take_branch_out,// taken-branch signal
				  input logic [31:0]  ex_target_PC_out,  // target pc: use if take_branch is TRUE
				  input logic [31:0]  Imem2proc_data,    // Data coming back from instruction-memory
					
				  output logic [31:0] proc2Imem_addr,    // Address sent to Instruction memory
				  output logic [31:0] if_PC_out,         // current PC
				  output logic [31:0] if_NPC_out,        // PC + 4
			      output logic [31:0] if_IR_out,         // fetched instruction out
				  output logic        if_valid_inst_out  // when low, instruction is garbage
				  );

logic [31:0] PC_reg; 				   // PC we are currently fetching
logic [31:0] PC_plus_4;
logic [31:0] next_PC;
logic 	PC_enable;

assign proc2Imem_addr ={PC_reg[31:2], 2'b0};


assign if_IR_out = Imem2proc_data;

// default next PC value
assign PC_plus_4 = PC_reg + 4;

// next PC 
assign next_PC = (ex_take_branch_out) ? ex_target_PC_out : PC_plus_4;

// stall PC
assign PC_enable = if_valid_inst_out | ex_take_branch_out;

// Pass PC down pipeline w/instruction
assign if_PC_out = PC_reg;
assign if_NPC_out = PC_plus_4;

// This register holds the PC value
always_ff @(posedge clk) begin
	if(rst)
		PC_reg <= 0;       // initial PC value is 0
	else if(PC_enable)
		PC_reg <= next_PC; // transition to next PC
end 


always_ff @(posedge clk) begin
	if (rst)
		if_valid_inst_out <= 1; 
	else
		if_valid_inst_out <= mem_wb_valid_inst;
end

endmodule  // module if_stage
