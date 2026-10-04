#include <stdio.h>
#include <string.h>

int crc32_buffer(const unsigned char *buffer,
                 const int           *length,
                 unsigned long       *result)
{
    unsigned int  bit;
    unsigned int  i;
    unsigned long crc;

    crc = 0xFFFFFFFFUL;

    for (i = 0; i < *length; i++) {
        crc ^= (unsigned long)buffer[i];

        for (bit = 0; bit < 8; bit++) {
            if (crc & 1)
                crc = (crc >> 1) ^ 0xEDB88320UL;
            else
                crc >>= 1;
        }
    }

    *result = crc ^ 0xFFFFFFFFUL;
    return 0;
}

int main(void)
{
    return 0;
}
