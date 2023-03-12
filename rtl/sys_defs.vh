//Size of a word
`define WORD_SIZE 32

//////////////////////////////////////////////
//
// Memory/testbench attribute definitions
//
//////////////////////////////////////////////


`define NUM_MEM_TAGS           8
`define MEM_LATENCY_IN_CYCLES  0

`define MEM_SIZE_IN_BYTES      (32768)
`define MEM_32BIT_LINES        (`MEM_SIZE_IN_BYTES/4)


// returns a zero value, and any write to this register is thrown away
//
`define ZERO_REG        5'd00

//
// useful boolean single-bit definitions
//
`define FALSE  	1'h0
`define TRUE  	1'h1

//
// Basic NOOP instruction.  Allows pipline registers to clearly be reset with
// an instruction that does nothing instead of Zero which is really a PAL_INST
//
`define NOOP_INST 32'h00000013

//
//Instruction types {Opcode}
//
`define R_TYPE 			7'b0110011
`define I_ARITH_TYPE 	7'b0010011
`define I_LD_TYPE 		7'b0000011
`define I_JAL_TYPE 		7'b1100111
`define S_TYPE 			7'b0100011
`define B_TYPE 			7'b1100011
`define J_TYPE 			7'b1101111
`define U_LD_TYPE 		7'b0110111
`define U_AUIPC_TYPE 	7'b0010111
`define I_BREAK_TYPE	7'b1110011

//
//{funct3, funct7}, R-TYPE
//
`define ADD_INST    {3'h0, 7'h00}
`define SUB_INST    {3'h0, 7'h20}
`define XOR_INST    {3'h4, 7'h00}
`define OR_INST     {3'h6, 7'h00}
`define AND_INST    {3'h7, 7'h00}
`define SLL_INST    {3'h1, 7'h00}
`define SRL_INST    {3'h5, 7'h00}
`define SRA_INST    {3'h5, 7'h20}
`define SLT_INST    {3'h2, 7'h00}
`define SLTU_INST   {3'h3, 7'h00}

//
//{funct3}, I-TYPE
//
`define ADDI_INST   3'h0
`define XORI_INST   3'h4
`define ORI_INST    3'h6
`define ANDI_INST   3'h7
`define SLLI_INST   3'h1
`define SRLI_INST   3'h5
`define SRAI_INST   3'h5
`define SLTI_INST   3'h2
`define SLTIU_INST  3'h3
`define JALR_INST   3'h0
`define LW_INST     3'h2

//
//{funct3}, S-TYPE
//
`define SW_INST 3'h2

//
//{funct3}, B-TYPE
//
`define BEQ_INST    3'h0
`define BNE_INST    3'h1
`define BLT_INST    3'h4
`define BGE_INST    3'h5
`define BLTU_INST   3'h6
`define BGEU_INST   3'h7




//
// ALU opA input mux selects
//
`define ALU_OPA_IS_REGA  2'h0
`define	ALU_OPA_IS_PC    2'h1
`define	ALU_OPA_IS_ZR    2'h2

//
// ALU opB input mux selects
//
`define	ALU_OPB_IS_REGB   2'h0
`define	ALU_OPB_IS_IMM    2'h1
`define ALU_OPB_IS_4	  2'h2

//
// Destination register select
//
`define DEST_IS_REGC   1'b0
`define	DEST_NONE      1'b1

//
// ALU function code input
//
`define	ALU_ADD   5'h00
`define	ALU_SUB   5'h01
`define	ALU_XOR   5'h02
`define	ALU_OR    5'h03
`define	ALU_AND   5'h04
`define	ALU_SLL   5'h05
`define	ALU_SRL   5'h06
`define	ALU_SRA   5'h07
`define	ALU_SLT   5'h08
`define	ALU_SLTU  5'h09

//
// Memory bus commands control signals
// 
`define	BUS_NONE    2'h0
`define	BUS_LOAD    2'h1
`define	BUS_STORE  	2'h2