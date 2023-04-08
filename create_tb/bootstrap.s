.global _start
_start:
li a0,32768
mv sp,a0
jal main
hang: j hang
