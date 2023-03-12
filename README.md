changelog:

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
