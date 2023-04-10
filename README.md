changelog:
--- --- ---

# LAB 2 #

10/4/23:

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