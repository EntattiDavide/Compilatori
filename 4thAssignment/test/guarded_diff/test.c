void test_fusion(int *a, int *b, int n, int m) {
    if (n > 0) {
        for (int i = 0; i < n; i++) {
            a[i] = i * 2;
        }
    }

    if (m > 0) {
        for (int i = 0; i < m; i++) {
            b[i] = a[i] + 1;
        }
    }
}
