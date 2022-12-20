#include <stdio.h>
#include <stdint.h>
#include "crc32_generic.h"

int main()
{
    char str[] = "0123456789ABCDEF0123456789ABCDEF";
    uint32_t len = 32;

    uint32_t crc = crc32_generic(0, str, len);
    printf("%x\n", crc);

    crc = crc32_clmul(0, str, len);
    printf("%x\n", crc);
    return 0;
}