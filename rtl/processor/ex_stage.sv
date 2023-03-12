`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module ex_stage(
input logic 		clk,               // system clk
input logic 		rst,               // system rst
input logic [31:0]  id_ex_PC,            // PC
input logic [31:0] 	id_ex_imm,
input logic [31:0]  id_ex_rega,          // register A value from reg file
input logic [31:0]  id_ex_regb,          // register B value from reg file
input logic [1:0] 	id_ex_opa_select,    // opA mux select from decoder
input logic [1:0] 	id_ex_opb_select,    // opB mux select from decoder
input logic [4:0]   id_ex_alu_func,      // ALU function select from decoder
input logic 		id_ex_valid_inst,
//branch
input logic [31:0]  pc_add_opa,
input logic [2:0]   id_ex_funct3,
input logic 		uncond_branch,
input logic 		cond_branch,
//output
output logic 		ex_take_branch_out,
output logic [31:0] ex_target_PC_out,
output logic [31:0] ex_alu_result_out    // The arithmetic result. Needs to be renamed
);

logic [31:0] alu_opa, alu_opb;

logic brcond_result;

logic [31:0] br_cond_opa, br_cond_opb;

logic [31:0] opa_mux_out, opb_mux_out;

logic [31:0] alu_result;

always_comb begin : opA_mux
	case (id_ex_opa_select)
		`ALU_OPA_IS_PC:   opa_mux_out = id_ex_PC;
		`ALU_OPA_IS_ZR:   opa_mux_out = 32'b0;
		default:         opa_mux_out = id_ex_rega;
	endcase
end

always_comb begin : opB_mux
	case (id_ex_opb_select)
		`ALU_OPB_IS_IMM: 		opb_mux_out = id_ex_imm;
		`ALU_OPB_IS_4:			opb_mux_out = 32'h4;
		default: 				opb_mux_out = id_ex_regb;
	endcase 
end

assign alu_opa=opa_mux_out;
assign alu_opb=opb_mux_out;

assign br_cond_opa=id_ex_rega;
assign br_cond_opb=id_ex_regb;

alu alu_0 (// Inputs
		  .opa(alu_opa),
		  .opb(alu_opb),
		  .br_cond_opa(br_cond_opa),
		  .br_cond_opb(br_cond_opb),
		  .func(id_ex_alu_func),
		  .id_ex_funct3(id_ex_funct3),
		  .result(alu_result),
		  .brcond_result(brcond_result));

assign ex_target_PC_out = pc_add_opa + id_ex_imm;

assign ex_take_branch_out = (uncond_branch | (cond_branch & brcond_result)) & id_ex_valid_inst;
//

assign ex_alu_result_out=alu_result;


endmodule // module ex_stage

//
// The ALU
//
// given the command code CMD and proper operands A and B, compute the
// result of the instruction
//
// This module is purely combinational
//

module alu(
input logic [31:0] opa, opb,
input logic [31:0] br_cond_opa, br_cond_opb,
input logic [4:0] func,
input logic [2:0] id_ex_funct3,

output logic [31:0] result,
output logic brcond_result
);

logic [63:0] temp;

//result 
always_comb begin
	case (func)
		//R-TYPE
		`ALU_ADD: 	result = opa + opb;
		`ALU_SUB: 	result = opa - opb;
		`ALU_XOR: 	result = opa ^ opb;
		`ALU_OR:  	result = opa | opb;
		`ALU_AND: 	result = opa & opb;
		`ALU_SLL: 	result = opa << opb[4:0];
		`ALU_SRL: 	result = opa >> opb[4:0];
		`ALU_SRA: 	result = $signed(opa) >>> opb[4:0]; 
		`ALU_SLT: 	result = {31'd0, ($signed(opa)< $signed(opb))};
		`ALU_SLTU:	result = {31'd0, (opa < opb)};
		default: 	result = 32'hbaadbeef;  
	endcase	
end

//br condition
always_comb begin
	case (id_ex_funct3[2:1])
		2'b00: brcond_result = (br_cond_opa == br_cond_opb);         // BEQ: (rs1 == rs2) ?
		2'b10: brcond_result = $signed(br_cond_opa)< $signed(br_cond_opb);	// BLT: (rs1 < rs2)
		2'b11: brcond_result = br_cond_opa < br_cond_opb;   		    // BLTU: (unsigned(rs1) < unsigned(rs2))
		default: brcond_result = `FALSE;
	endcase
	//negate cond if func[0] is set
 	if(id_ex_funct3[0]) 
		brcond_result = ~brcond_result;

end

endmodule // alu