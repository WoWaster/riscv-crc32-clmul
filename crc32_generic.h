#include <stdint.h>

uint32_t crc32_generic(uint64_t crc, const unsigned char *buf, uint64_t len);
uint32_t crc32_clmul(uint64_t crc, const unsigned char *buf, uint64_t len);
