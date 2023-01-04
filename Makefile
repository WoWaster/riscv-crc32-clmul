prefix = "riscv64-unknown-linux-gnu"
gem5_path = "../gem5"

all:
	$(prefix)-gcc -march=rv64gc_zbc -O3 -static main.c crc32_generic.c crc32_clmul.c crc32_clmul_asm.S -I$(gem5_path)/include -L$(gem5_path)/util/m5/build/riscv/out -lm5 -o main

run: all
	$(gem5_path)/build/RISCV/gem5.opt $(gem5_path)/configs/example/se.py --cmd=main --cpu-type=RiscvMinorCPU --ruby --l1d_size=64kB --l1i_size=64kB --mem-type=DDR4_2400_8x8

