#!/bin/bash

echo "=== BUILD ==="
cd build
make || exit 1
cd ..

tests=(
    correct_fusion
    different_trip_count
    guarded_diff
    guarded_same
    negative_dependencies
    not_adjecent
    not_control_flow_equivalent
)

for test in "${tests[@]}"; do
    echo
    echo "========================================"
    echo "TEST: $test"
    echo "========================================"

    cd "test/$test" || exit 1

    echo "[1/4] Clang..."
    clang -O0 -Xclang -disable-O0-optnone -S -emit-llvm \
        test.c -o test.O0.ll || exit 1

    echo "[2/4] mem2reg..."
    opt -passes=mem2reg test.O0.ll -S -o test.m2r.ll || exit 1

    if [ "$test" = "guarded_same" ] || [ "$test" = "guarded_diff" ]; then
        echo "[3/4] loop-rotate..."
        opt -passes=loop-rotate test.m2r.ll -S -o test.rotated.ll || exit 1

        INPUT="test.rotated.ll"
    else
        echo "[3/4] Nessuna rotazione..."
        INPUT="test.m2r.ll"
    fi

    echo "[4/4] Loop fusion + verifier..."
    opt -load-pass-plugin=../../build/libMyLoopFusion.so \
        -passes="my-loop-fusion" \
        -S "$INPUT" -o OptimizedTest.ll || exit 1

    opt -passes=verify OptimizedTest.ll -disable-output || exit 1

    LOOP_COUNT=$(grep -c '!llvm.loop' OptimizedTest.ll)

    case "$test" in
        correct_fusion)
            EXPECTED=1
            ;;
        different_trip_count)
            EXPECTED=2
            ;;
        guarded_same)
            EXPECTED=1
            ;;
        guarded_diff)
            EXPECTED=2
            ;;
        negative_dependencies)
            EXPECTED=2
            ;;
        not_adjecent)
            EXPECTED=2
            ;;
        not_control_flow_equivalent)
            EXPECTED=2
            ;;
    esac

    if [ "$LOOP_COUNT" -eq "$EXPECTED" ]; then
        if [ "$EXPECTED" -eq 1 ]; then
            echo "RESULT: PASS - loop fusion effettuata"
        else
            echo "RESULT: PASS - loop fusion correttamente rifiutata"
        fi
    else
        echo "RESULT: FAIL"
        echo "  Loop trovati: $LOOP_COUNT"
        echo "  Loop attesi:  $EXPECTED"
        cd ../..
        exit 1
    fi

    cd ../..
done

echo
echo "========================================"
echo "=== TUTTI I TEST SUPERATI ==="
echo "========================================"
