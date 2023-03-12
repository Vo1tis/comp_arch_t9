`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

//Decoder

module inst_decoder(
input [31:0] 		inst,
input logic valid_inst_in,  // ignore inst when low, outputs will
					        // reflect noop (except valid_inst)

output logic [1:0] 	opa_select,
output logic [1:0] 	opb_select,
output logic        dest_reg, // mux selects
output logic [4:0]  alu_func,
output logic 		rd_mem,wr_mem, cond_branch, uncond_branch,
output logic 		illegal,    // non-zero on an illegal instruction
output logic 		valid_inst  // for counting valid instructions executed
);

assign valid_inst =valid_inst_in & ~illegal;

always_comb begin
	// - invalid instructions should clear valid_inst.
	// - These defaults are equivalent to a noop
	// * see sys_defs.vh for the constants used here
	opa_select = `ALU_OPA_IS_REGA;
	opb_select = `ALU_OPB_IS_REGB;
	alu_func = `ALU_ADD;
	dest_reg = `DEST_NONE;
	rd_mem = `FALSE;
	wr_mem = 1'b0;
	cond_branch = `FALSE;
	uncond_branch = `FALSE;
	illegal = `FALSE;

	case (inst[6:0])
		`R_TYPE: begin
			opa_select = `ALU_OPA_IS_REGA;
			opb_select = `ALU_OPB_IS_REGB;
			dest_reg = `DEST_IS_REGC;

			case({inst[14:12], inst[31:25]})
				`ADD_INST  : alu_func = `ALU_ADD;   
				`SUB_INST  : alu_func = `ALU_SUB;    
				`XOR_INST  : alu_func = `ALU_XOR;   
				`OR_INST   : alu_func = `ALU_OR;   
				`AND_INST  : alu_func = `ALU_AND;   
				`SLL_INST  : alu_func = `ALU_SLL;   
				`SRL_INST  : alu_func = `ALU_SRL;   
				`SRA_INST  : alu_func = `ALU_SRA;   
				`SLT_INST  : alu_func = `ALU_SLT;   
				`SLTU_INST : alu_func = `ALU_SLTU;
				default: illegal = `TRUE;
			endcase 
		end //R-TYPE

		`I_ARITH_TYPE: begin
			opa_select = `ALU_OPA_IS_REGA;
			opb_select = `ALU_OPB_IS_IMM;
			dest_reg = `DEST_IS_REGC;

			case(inst[14:12])
				`ADDI_INST : alu_func = `ALU_ADD;
				`XORI_INST : alu_func = `ALU_XOR;
				`ORI_INST  : alu_func = `ALU_OR;
				`ANDI_INST : alu_func = `ALU_AND;
				`SLLI_INST : alu_func = `ALU_SLL;
				`SRLI_INST, `SRAI_INST: begin
					//This checks if any of the bits are 1 
					//to distinguish between the 2 instructions
					//because one has imm[5:11] = inst[25:30] = 0x00 and the other 0x20
					//If the ISA changes this check might need to be modified
					alu_func = |inst[31:25] ? `ALU_SRA : `ALU_SRL;
				end
				`SLTI_INST  : alu_func = `ALU_SLT;
				`SLTIU_INST : alu_func = `ALU_SLTU;
				default: illegal = `TRUE;
			endcase 
		end //I_ARITH_TYPE

		`I_LD_TYPE: begin
			opa_select = `ALU_OPA_IS_REGA;
			opb_select = `ALU_OPB_IS_IMM;
			dest_reg = `DEST_IS_REGC;
			rd_mem = `TRUE;
			alu_func = `ALU_ADD;
			illegal=(inst[14:12]!=2)?`TRUE:`FALSE;			
		end //I_LD_TYPE

		`S_TYPE: begin
			opa_select = `ALU_OPA_IS_REGA;
			opb_select = `ALU_OPB_IS_IMM;
			alu_func = `ALU_ADD;
			
			case(inst[14:12])
				`SW_INST:   wr_mem = `TRUE;
				default: illegal = `TRUE;
			endcase
		end //S_TYPE
		
		`B_TYPE: begin
			opa_select = `ALU_OPA_IS_PC;
			opb_select = `ALU_OPB_IS_IMM;
			cond_branch = `TRUE;
			
			case(inst[14:12])
				3'd2, 3'd3: illegal = `TRUE;
				default: alu_func = `ALU_ADD;
			endcase
		end //B_TYPE
		
		`J_TYPE: begin
			opa_select = `ALU_OPA_IS_PC;
			opb_select = `ALU_OPB_IS_4;
			dest_reg = `DEST_IS_REGC;
			alu_func = `ALU_ADD;
			uncond_branch = `TRUE;
		end //J-TYPE
		
		`I_JAL_TYPE: begin
			opa_select = `ALU_OPA_IS_PC;
			opb_select = `ALU_OPB_IS_4;
			dest_reg = `DEST_IS_REGC;
			alu_func = `ALU_ADD;
			uncond_branch = `TRUE;
			
			illegal = (inst[14:12] != 3'h0) ? `TRUE : `FALSE;
		end //I_JAL_TYPE
		
		`U_LD_TYPE: begin
			opa_select = `ALU_OPA_IS_ZR;
			opb_select = `ALU_OPB_IS_IMM;
			dest_reg = `DEST_IS_REGC;
			alu_func = `ALU_ADD;
		end //U_LD_TYPE
		
		`U_AUIPC_TYPE: begin
			opa_select = `ALU_OPA_IS_PC;
			opb_select = `ALU_OPB_IS_IMM;
			dest_reg = `DEST_IS_REGC;
			alu_func = `ALU_ADD;
		end //U_AUIPC_TYPE
		
		`I_BREAK_TYPE: begin
			illegal = (inst[31:20] != 12'h1); //if imm=0x1 it is a ebreak (environmental break)
		end
		
		default: illegal = `TRUE;
	endcase 
end 
endmodule // inst_decoder



//Instruction Decode Stage 
module id_stage(
input logic 		clk,              		// system clk
input logic 		rst,              		// system rst
input logic [31:0] 	if_id_IR,            	// incoming instruction
input logic [31:0]	if_id_PC,
input logic	        mem_wb_valid_inst,   	 	//Does the instruction write to rd?
input logic	        mem_wb_reg_wr,   	 	//Does the instruction write to rd?
input logic [4:0]	mem_wb_dest_reg_idx, 	//index of rd
input logic [31:0] 	wb_reg_wr_data_out, 	// Reg write data from WB Stage
input logic         if_id_valid_inst,

output logic [31:0] id_ra_value_out,    	// reg A value
output logic [31:0] id_rb_value_out,    	// reg B value
output logic [31:0]	id_immediate_out,		// sign-extended 32-bit immediate
output logic [31:0] pc_add_opa,

output logic [1:0] 	id_opa_select_out,    	// ALU opa mux select (ALU_OPA_xxx *)
output logic [1:0] 	id_opb_select_out,    	// ALU opb mux select (ALU_OPB_xxx *)

output logic 		id_reg_wr_out,
output logic [2:0] 	id_funct3_out,
output logic [4:0] 	id_dest_reg_idx_out,  	// destination (writeback) register index (ZERO_REG if no writeback)
output logic [4:0]  id_alu_func_out,        // ALU function select (ALU_xxx *)
output logic       	id_rd_mem_out,          // does inst read memory?
output logic 	    id_wr_mem_out,          // does inst write memory?
output logic 		cond_branch,
output logic        uncond_branch,
output logic       	id_illegal_out,
output logic       	id_valid_inst_out	  	// is inst a valid instruction to be counted for CPI calculations?
);
   
logic dest_reg_select;
logic [31:0] rb_val;

//instruction fields read from IF/ID pipeline register
logic[4:0] ra_idx; 
logic[4:0] rb_idx; 
logic[4:0] rc_idx; 

assign ra_idx=if_id_IR[19:15];	// inst operand A register index
assign rb_idx=if_id_IR[24:20];	// inst operand B register index
assign rc_idx=if_id_IR[11:7];  // inst operand C register index
// Instantiate the register file used by this pipeline

logic write_en;
assign write_en=mem_wb_valid_inst & mem_wb_reg_wr;

regfile regf_0(.clk		(clk),
			   .rst		(rst),
			   .rda_idx	(ra_idx),
			   .rda_out	(id_ra_value_out), 
			   .rdb_idx	(rb_idx),
			   .rdb_out	(rb_val), 
			   .wr_en	(write_en),
			   .wr_idx	(mem_wb_dest_reg_idx),
			   .wr_data	(wb_reg_wr_data_out));

assign id_rb_value_out=rb_val;

// instantiate the instruction inst_decoder
inst_decoder inst_decoder_0(.inst	        (if_id_IR),
							.valid_inst_in  (if_id_valid_inst),
							.opa_select		(id_opa_select_out),
							.opb_select		(id_opb_select_out),
							.alu_func		(id_alu_func_out),
							.dest_reg		(dest_reg_select),
							.rd_mem			(id_rd_mem_out),
							.wr_mem			(id_wr_mem_out),
							.cond_branch	(cond_branch),
							.uncond_branch	(uncond_branch),
							.illegal		(id_illegal_out),
							.valid_inst		(id_valid_inst_out));

always_comb begin : write_to_rd
	case(if_id_IR[6:0])
		`R_TYPE, `U_LD_TYPE, `U_AUIPC_TYPE		: id_reg_wr_out = `TRUE;
		`I_ARITH_TYPE, `I_LD_TYPE, `I_JAL_TYPE	: id_reg_wr_out = `TRUE;
		`J_TYPE									: id_reg_wr_out = `TRUE;
		default: id_reg_wr_out = `FALSE;
	endcase
end

// mux to generate dest_reg_idx based on
// the dest_reg_select output from inst_decoder
always_comb begin
	if(dest_reg_select==`DEST_IS_REGC)
		id_dest_reg_idx_out = rc_idx;
	else
		id_dest_reg_idx_out = `ZERO_REG;
end

//ultimate "take branch" signal: unconditional, or conditional and the condition is true


//set up possible immediates:
//jmp_disp: 20-bit sign-extended immediate for jump displacement;
//up_imm: 20-bit immediate << 12;
//br_disp: sign-extended 12-bit immediate * 2 for branch displacement 
//mem_disp: sign-extended 12-bit immediate for memory displacement 
//alu_imm: sign-extended 12-bit immediate for ALU ops
logic[31:0] jmp_disp;
logic[31:0] up_imm;	
logic[31:0] br_disp; 	
logic[31:0] mem_disp; 
logic[31:0] alu_imm;	

assign jmp_disp={{12{if_id_IR[31]}}, if_id_IR[19:12], if_id_IR[20], if_id_IR[30:21], 1'b0};
assign up_imm = {if_id_IR[31:12], 12'b0};
assign br_disp = {{20{if_id_IR[31]}}, if_id_IR[7], if_id_IR[30:25], if_id_IR[11:8], 1'b0};
assign mem_disp = {{20{if_id_IR[31]}}, if_id_IR[31:25], if_id_IR[11:7]};
assign alu_imm = {{20{if_id_IR[31]}}, if_id_IR[31:20]};


always_comb begin : immediate_mux
	case(if_id_IR[6:0])
		`S_TYPE: id_immediate_out = mem_disp;
		`B_TYPE: id_immediate_out = br_disp;
		`J_TYPE: id_immediate_out = jmp_disp;
		`U_LD_TYPE, `U_AUIPC_TYPE: id_immediate_out = up_imm;
		default:id_immediate_out = alu_imm;
	endcase
end

assign pc_add_opa =(if_id_IR[6:0] == `I_JAL_TYPE)? id_ra_value_out:if_id_PC;


//target PC to branch to

assign id_funct3_out = if_id_IR[14:12];

endmodule // module id_stage