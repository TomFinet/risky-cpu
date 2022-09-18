#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define b(x) int_to_bstring(x)

const char* int_to_bstring(uint x) {
    static char b[sizeof(x)*8] = {0};
    int y;
    long long z;

    for (z = 1LL<<sizeof(int)*8-1, y = 0; z > 0; z >>= 1, y++) {
        b[y] = (((x & z) == z) ? '1' : '0');
    }
    b[y] = 0;

    return b;
}