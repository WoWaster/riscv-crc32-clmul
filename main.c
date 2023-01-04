#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <gem5/m5ops.h>
#include "crc32_generic.h"

#define BENCH_COUNT 100
#define BUFFER_SIZE 8192
#define USE_CLMUL 1
#define SEED 1234

int main()
{
    uint8_t *buffer = calloc(BUFFER_SIZE, sizeof(uint8_t));
    srand(SEED);

    for (size_t i = 0; i < BENCH_COUNT; i++)
    {
        for (size_t j = 0; j < BUFFER_SIZE; j++)
        {
            buffer[j] = rand() % UINT8_MAX;
        }

        m5_reset_stats(0, 0);
#if USE_CLMUL
        crc32_clmul(0, buffer, BUFFER_SIZE);
#else
        crc32_generic(0, buffer, BUFFER_SIZE);
#endif
        m5_dump_stats(0, 0);
    }

    free(buffer);

    return 0;
}