void test_fusion(int *a, int *b, int n, int m) {
    if (n > 0) {
        int i = 0;
        do {
            a[i] = i * 2;
            i++;
        } while (i < n);
    }

    if (m > 0) {
        int i = 0;
        do {
            b[i] = a[i] + 1;
            i++;
        } while (i < m);
    }
}
