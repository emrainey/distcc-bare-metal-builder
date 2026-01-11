#include <stdint.h>
#include <stdio.h>

#define func_name(name, num) name##num

int func_name(gcd, TEST)(int a, int b) {
    if (b == 0) {
        return a;
    }
    return func_name(gcd, TEST)(b, a % b);
}
