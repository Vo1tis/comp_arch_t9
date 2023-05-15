changelog:
--- --- ---

# LAB 3 #

15/5/23:

Final version

decode stage:
+ adjusted staller signal logic
+ adjusted forward signal logic and its effects
+ swapped forwarding's 'always_ff' block to an 'always_comb' one

--- --- ---

14/5/23:

v2.

decode stage:
+ adjusted some potential invalid 'forward' signal cases
+ moved forwarding operation from regfile to id_stage.sv

simulation:
+ all signals now run properly
+ new warning: ' GetModuleFileName: The specified module could not be found. '

v1.

decode stage:
+ stall now checks for old load type instructions

--- --- ---

10/5/23:

decode stage:
+ forward now checks for EX,MEM and WB stage Rd, in relation to new instruction's Rs1 and Rs2 registers.
+ staller now checks if new instruction is of load type; then checks Rs1's dependency to older Rd registers.

testbench:
+ new testbench added; checks for forwarding and RAW stalls

--- --- ---

9/5/23:

decode stage:
+ 'forward' signal added as output
+ 'staller' signal now affected by new 'forward' signal
				
processor.sv:
+ initialised 'forward' signal, and added inputs to ID stage for EX, MEM and WB stage rd's outgoing data
+ cleaned up a bit

regfile.sv:
+ ported inputs from decode stage: Rd's values and data from EX, MEM and WB stages
+ now forwarding Rd's data from EX, MEM or WB stage to new instruction's Rs1 or Rs2, if forward signal is one

modelsim simulation:
+ we do not get any register movement anymore :(

--- --- ---

# LAB 2 #

11/4/23:

Final

--- --- ---

10/4/23:

v2.

Troubleshooting pt.2

  working properly?

v1.

Troubleshooting pt.1

--- --- ---

9/4/23:

v2.

+ decode stage:		moved write_en staller to the correct module (line 205)
+ processor.sv:		fixed a (critical) typo
+ processor_tb.sv:	improved verilog in initial of simulation
+ multisim simulation now actually runs (yay)

v1.

+ fetch stage:		PC_enable is off when stalling
+ decode stage:		write_en is off when stalling (lines 22-31, line 221)

- decode stage: 	no longer changing PC state (when stalling) from here
- execute stage:	no longer affected by 'valid' signal

	processor.sv changes:

+ added stall conditions when PC stays unchanged (lines 166, 266)
+ zap and flush when stalling on if/id stage (lines 282-307)
+ zap and flush every previous stage if branching while a stall is active (lines 380-427)

	simulation:

+ updated the testbench stuff
+ new tb file & updated the processor_tb.sv file under rtl/simulation
+ needs some testing

--- --- ---

8/4/23:

v2.
+ moved all testbench stuff inside /create_tb/ directory
+ cleaned up a bit

v1.
(instr fetch stage is still unchanged)
+ decode stage: stalls rearranged (lines 21-27 & lines 293-309)
+ execute stage: PC doesnt change if new instructions aren't valid (line 72)
+ (subject to change) testbench file 'testhex.c', in main directory

--- --- ---

3/4/23:

+ attempt at Makefile
+ added stalls to instruction decode stage (id_stage.sv)

--- --- ---

# LAB 1 #

30/3/23:

+ replaced testbench files with a given one
+ cleaned up a bit

--- --- ---

15/3/23:

+ added some testbench options (+ test hex files for MUL and MULHU)
+ still need to figure out the signals testing stuff on modelsim

--- --- ---
13/3/23:

v2.
+ ex_stage.sv -> fixed some verilog stuff.
+ simulation.do -> removed vsim ' -novopt ' argument, as it doesnt work properly in modelsim 2020.1
+ simulation works fine now, but we dont know what is going on anymore :')


v1.
Not yet tested!
Added MUL (and MULHU) instructions.

+ sys_defs.vh -> defined MUL_INST and ALU_MUL, MULHU_INST and ALU_MULHU
+ id_stage.sv -> added R-type case for ALU_MUL and ALU_MULHU
+ ex_stage.sv -> implemented magic for ALU_MUL and ALU_MULHU

--- --- ---

12/3/23:

hello

update:cloned some stuff here and there

--- --- ---