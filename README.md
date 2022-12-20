# CRC-32 optimized for RISC-V

CRC-32 optimized for RISC-V using `CLMUL(H)` instructions from Zbc extension

## How to run
### Requirements
* RISC-V gcc with linux target
* gem5 simulator

### GCC
GCC can be acquired [here](https://github.com/riscv-collab/riscv-gnu-toolchain).
You must use compile it with glibc, not newlib, so make sure you run
```bash
make linux
```
### gem5 
gem5 must be compiled from `develop` branch, due to [bug](https://gem5.atlassian.net/browse/GEM5-1276).
On my machine it was compiled from [this commit](https://gem5.googlesource.com/public/gem5/+/1b2252cbc0dbd2473f0e106775419dd8b87992f9).
Also it was complied with `opt` suffix, so make command looked like
```bash
scons build/RISCV/gem5.opt -j 12
```

### Running
To run test program, change your prefix of RISC-V toolchain and path to gem5 accordingly, then just run 
```
make run
```
