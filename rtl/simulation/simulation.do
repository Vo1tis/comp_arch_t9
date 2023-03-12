quit -sim
file delete -force work

vlib work
vlog -f files_rtl.f

vsim -novopt processor_tb
log -r /*

run -all