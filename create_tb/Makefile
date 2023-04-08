testhex.dmp: testhex.elf
		riscv64-unknown-elf-elf2hex --bit-width 32 --input testhex.elf --output testhex.txt
		riscv64-unknown-elf-objdump -d testhex.elf>testhex.dmp
testhex.elf: testhex.c lscript bootstrap.s
		riscv64-unknown-elf-gcc -O3 -Wall -nostdlib -march=rv32imav -mabi=ilp32 -T lscript bootstrap.s testhex.c -o testhex.elf
clean:
		rm testhex.elf testhex.dmp
