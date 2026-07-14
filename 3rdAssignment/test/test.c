void licm_test(int a, int b, int c, int n, int m, int* arr) {
    // VARIABILE ESTERNA
    int outer_val = a + b; //%7
    int w = 0;

    for (int i = 0; i < n; i++) {
        // 'inv_outer' è invariante per il loop interno (j), ma anche per quello esterno (i).
        // Un buon pass LICM lo sposterebbe nel preheader del loop i.
        int inv_outer = a * b; //%11 to %8

        for (int j = 0; j < m; j++) {
            // inv_inner è invariante per entrambi i loop.
            int inv_inner = inv_outer + c; //%20 to %14
            
            arr[j] = inv_inner + j;
        }

        //spostato anche icmp per l'if
        int x, y;
        if (a > 0) {//%22 to &9
            // x non domina l'uscita del loop (perché questo ramo potrebbe essere saltato).
            // Ma è inutilizzato all'uscita, va spostato.
            x = b + c; //%27 to %13
            arr[i] = x;
        } else {
            y = b * c; //%28 to %10
            arr[i] = y;
        }

        // 'z' si trova in un blocco che viene eseguito DOPO l'if-else.
        // Se questo blocco si trova su ogni percorso che porta all'uscita,
        // allora 'z' domina le uscite e può essere spostato
        int z = a + b + c; // %32 %33 to %11 %12
        arr[i] += z;

        // 'w' è invariante, ma il loop ha un'uscita anticipata.
        // 'w' non domina tute le uscite, ed è utilizzato fuori dal loop
        // quindi non può essere spostato.
        if (arr[i] > 100) break; 
        w = a - b; //Non viene spostato
        arr[i] -= w;
    }
    arr[0] = w;
}