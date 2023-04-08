changelog:
--- --- ---

# LAB 2 #

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