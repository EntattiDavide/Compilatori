void test_fusion(int *a, int *b, int n, int m) {

    if (n > 0) {
        for (int i = 0; i < 100; i++) {
            a[i] = i * 2;
        }
    }

    if (m > 0) {
        for (int i = 0; i < 100; i++) {
            b[i] = a[i] + 1;
        }
    }
}
