`ifdef MODEL_TECH
	`include "../sys_defs.vh"
`endif

module processor_tb;

logic clk;
logic rst;    

logic [4:0]  	pipeline_commit_wr_idx;
logic [31:0] 	pipeline_commit_wr_data;
logic [31:0] 	pipeline_commit_NPC;
logic           pipeline_commit_wr;

logic [31:0] 	instruction;
logic [31:0] 	pc_addr;
logic [1:0]     im_command;

logic [31:0] 	mem2proc_data;
logic [31:0] 	proc2Dmem_addr;
logic [1:0] 	proc2Dmem_command;
logic [31:0]    proc2mem_data;

// Outputs from IF-Stage 
logic [31:0] 	if_PC_out;
logic [31:0] 	if_NPC_out;
logic [31:0] 	if_IR_out;
logic           if_valid_inst_out;

// Outputs from IF/ID Pipeline Register
logic [31:0] 	if_id_PC;
logic [31:0] 	if_id_NPC;
logic [31:0] 	if_id_IR;
logic           if_id_valid_inst;

// Outputs from ID/EX Pipeline Register
logic [31:0] 	id_ex_PC;
logic [31:0] 	id_ex_NPC;
logic [31:0] 	id_ex_IR;
logic   		id_ex_valid_inst;


// Outputs from EX/MEM Pipeline Register
logic [31:0] 	ex_mem_NPC;
logic [31:0] 	ex_mem_IR;
logic   		ex_mem_valid_inst;


// Outputs from MEM/WB Pipeline Register
logic [31:0] 	mem_wb_NPC;
logic [31:0] 	mem_wb_IR;
logic   		mem_wb_valid_inst;

processor proc_module(.clk(clk),
                      .rst(rst),
                      .pipeline_commit_wr_idx(pipeline_commit_wr_idx),
                      .pipeline_commit_wr_data(pipeline_commit_wr_data),
                      .pipeline_commit_NPC(pipeline_commit_NPC),
                      .pipeline_commit_wr(pipeline_commit_wr),
                      .instruction(instruction),
                      .pc_addr(pc_addr),
                      .im_command(im_command),
                      .mem2proc_data(mem2proc_data),
                      .proc2Dmem_addr(proc2Dmem_addr),
                      .proc2Dmem_command(proc2Dmem_command),
                      .proc2mem_data(proc2mem_data),
                      .if_PC_out(if_PC_out),
                      .if_NPC_out(if_NPC_out),
                      .if_IR_out(if_IR_out),
                      .if_valid_inst_out(if_valid_inst_out),
                      .if_id_PC(if_id_PC),
                      .if_id_NPC(if_id_NPC),
                      .if_id_IR(if_id_IR),
                      .if_id_valid_inst(if_id_valid_inst),
                      .id_ex_PC(id_ex_PC),
                      .id_ex_NPC(id_ex_NPC),
                      .id_ex_IR(id_ex_IR),
                      .id_ex_valid_inst(id_ex_valid_inst),
                      .ex_mem_NPC(ex_mem_NPC),
                      .ex_mem_IR(ex_mem_IR),
                      .ex_mem_valid_inst(ex_mem_valid_inst),
                      .mem_wb_NPC(mem_wb_NPC),
                      .mem_wb_IR(mem_wb_IR),
                      .mem_wb_valid_inst(mem_wb_valid_inst));

logic [3:0] mem2proc_response_im;
logic [3:0] mem2proc_tag_im;

logic [3:0] mem2proc_response_dm;
logic [3:0] mem2proc_tag_dm;

logic [31:0] im_data;
assign im_data=0;

mem IM(.clk(clk),
       .proc2mem_addr(pc_addr),
       .proc2mem_data(im_data),
       .proc2mem_command(im_command),
       .mem2proc_response(mem2proc_response_im),
       .mem2proc_data(instruction),
       .mem2proc_tag(mem2proc_tag_im));

mem DM(.clk(clk),
       .proc2mem_addr(proc2Dmem_addr),
       .proc2mem_data(proc2mem_data),
       .proc2mem_command(proc2Dmem_command),
       .mem2proc_response(mem2proc_response_dm),
       .mem2proc_data(mem2proc_data),
       .mem2proc_tag(mem2proc_tag_dm));

initial begin
	clk=0;
	forever #5 clk=~clk;
end

initial begin
    $readmemh("testshex.txt",IM.unified_memory);
    $readmemh("testshex.txt",DM.unified_memory);
end

initial begin
    rst=1;
    @(posedge clk);
    rst=0;
    for(int i=0;i<50000;i++) begin
        @(posedge clk);    
    end
    $stop;
end


endmodule