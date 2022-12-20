#include "crc32_generic.h"
#include <stdio.h>

#define CLMUL_MIN_LEN 32   // Minimum size of buffer for _crc32_clmul
#define CLMUL_CHUNK_LEN 16 // Length of chunk for clmul

extern uint32_t _crc32_clmul(uint64_t crc, const unsigned char *buf, uint64_t len);

uint32_t crc32_clmul(uint64_t crc, const unsigned char *buf, uint64_t len)
{
    if (len < CLMUL_MIN_LEN)
    {
        return crc32_generic(crc, buf, len);
    }

    uint64_t unaligned_length = len % CLMUL_CHUNK_LEN;

    if (unaligned_length)
    {
        crc = crc32_generic(crc, buf, unaligned_length);
    }
    crc ^= 0xFFFFFFFF;
    crc = _crc32_clmul(crc, buf + unaligned_length, len - unaligned_length);

    return crc ^ 0xFFFFFFFF;
}