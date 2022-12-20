/*
 * Constants
 */
#define CONSTANT_R3  0x1751997d0LL
#define CONSTANT_R4  0x0ccaa009eLL
#define CONSTANT_R5  0x163cd6124LL
#define MASK32 0xFFFFFFFF
#define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
#define CONSTANT_RU  0x1F7011641LL

/*
 * Register renames
 */
#define CRC a0
#define BUF a1
#define LEN a2
#define CONSTANT_1 a5
#define CONSTANT_2 a6
#define CONSTANT_3 a7

.section .text
.global _crc32_clmul
/**
 * CRC-32 calculation
 * CRC - initial CRC-32 value
 * BUF - buffer aligned to 16 bytes
 * LEN - size of buffer, should be 0 mod 16, and greater than 31
 *
 * uint32_t _crc32_clmul(uint64_t crc, const unsigned char *buf, uint64_t len)
 */
 
_crc32_clmul: 
    ld t0, 0(BUF) # xmm1[63:0]
    ld t1, 8(BUF) # xmm1[127:64]
    xor t0, t0, CRC

    addi LEN, LEN, -16
    addi BUF, BUF, 16

    li CONSTANT_1, CONSTANT_R3 
    li CONSTANT_2, CONSTANT_R4
    li CONSTANT_3, 16
    
loop_16: // Fold buffer into 128 bit
    clmulh t3, CONSTANT_2, t1 # xmm5[127:64]
    clmul t2, CONSTANT_2, t1 # xmm5[63:0]
    clmulh t1, CONSTANT_1, t0 # xmm1[127:64]
    clmul t0, CONSTANT_1, t0 # xmm1[63:0] 
    xor t0, t0, t2 # xmm1[63:0] 
    xor t1, t1, t3 # xmm1[127:64]

    ld t4, 0(BUF)
    xor t0, t0, t4
    ld t4, 8(BUF)
    xor t1, t1, t4

    addi LEN, LEN, -16
    addi BUF, BUF, 16
    bge LEN, CONSTANT_3, loop_16

fold_64:
    clmulh t3, t0, CONSTANT_2 # CONSTANT[127:64]
    clmul t2, t0, CONSTANT_2 # CONSTANT[63:0]
    mv t0, t1
    mv t1, t3
    xor t0, t0, t2

    srli t2, t0, 32
    slli t3, t1, 32
    or t2, t2, t3
    li CONSTANT_3, MASK32
    and t0, t0, CONSTANT_3
    li CONSTANT_1, CONSTANT_R5
    clmul t0, CONSTANT_1, t0 # xmm1[63:0]
    xor t0, t0, t2 # xmm1[63:0]

    mv t2, t0
    and t0, t0, CONSTANT_3
    li CONSTANT_1, CONSTANT_RU 
    clmul t0, t0, CONSTANT_1 # xmm1[63:0]
    and t0, t0, CONSTANT_3
    li CONSTANT_1, CRCPOLY_TRUE_LE_FULL
    clmul t0, t0, CONSTANT_1 # xmm1[63:0]
    xor t0, t0, t2
    srli CRC, t0, 32

    ret
