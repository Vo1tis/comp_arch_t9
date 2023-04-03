testhex.dmp: testhex.elf
		riscv64-unknown-elf-objdump -d testhex.elf>testhex.dmp
testhex.elf: testhex.c
		riscv64-unknown-elf-gcc -03 -Wall -nostdlib -march=rv32imav -mabi=ilp32 testhex.c -o testhex.elf
clean:
		rm testhex.elf testhex.dmp
