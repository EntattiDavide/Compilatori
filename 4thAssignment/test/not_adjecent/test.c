#include <stdio.h>
void test_fusion(int *a, int *b, int *c, int *d, int n, int cond) {
    
    // --- CICLO 1 ---
    // Candidato base
    for (int i = 0; i < 100; i++) {
        a[i] = i * 2;
    }

    // --- CICLO 2 ---
    // VIOLA: areAdjacent
    printf("Interruzione tra i cicli\n"); 
    for (int i = 0; i < 100; i++) {
        c[i] = i * 3;
    }
}