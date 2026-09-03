void test_fusion(int *a, int *b, int n) {
    if (n > 0) {
        for (int i = 0; i < n; i++) {
            a[i] = i * 2;
        }
    }

    if (n > 0) {
        for (int i = 0; i < n; i++) {
            b[i] = a[i] + 1;
        }
    }
}
