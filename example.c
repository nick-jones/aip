#include <stdio.h>
#include "aip.h"

void example1() {
  char *formatted = "127.13.1.143";
  unsigned long ip;
  aip_pton4(formatted, &ip);
  printf("%s = %lu\n", formatted, ip);
}

void example2() {
  char formatted[AIP_V4_ADDRESSLEN];
  unsigned long ip = 2131558799;
  aip_ntop4(ip, formatted);
  printf("%lu = %s\n", ip, formatted);
}

int main() {
    example1();
    example2();
    return 0;
}
