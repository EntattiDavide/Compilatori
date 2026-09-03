#include <stdio.h>

void test_fusion(int *a, int *b, int *c, int n, int cond) {

    for (int i = 0; i < 100; i++) {
        a[i] = i * 2;
    }

    if (cond) {
        for (int i = 0; i < 100; i++) {
            b[i] = a[i] + 1;
        }
    }
}
