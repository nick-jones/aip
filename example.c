#include <stdio.h>
#include "aip.h"

int main() {
    char *formatted = "127.0.0.1";
    unsigned long ip;
    int res = aip_pton4(formatted, &ip);
    printf("%s = %lu\n", formatted, ip);
    return res;
}
