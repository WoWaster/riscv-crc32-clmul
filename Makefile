prefix = "riscv64-unknown-linux-gnu"
gem5_path = "../gem5"

all:
	$(prefix)-gcc -march=rv64gc_zbc -static main.c crc32_generic.c crc32_clmul.c crc32_clmul_asm.S -o main

run: all
	$(gem5_path)/build/RISCV/gem5.opt $(gem5_path)/configs/example/se.py --cmd=main --cpu-type=RiscvMinorCPU --ruby --mem-type=DDR4_2400_8x8
