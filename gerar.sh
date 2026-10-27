#!/bin/bash
# Gera assembly x86-64 (-O0 e -O2) e RISC-V (se o compilador existir)
FLAGS="-S -masm=intel -fno-asynchronous-unwind-tables -fno-dwarf2-cfi-asm"
mkdir -p build/O0 build/O2 build/riscv

for f in src/*.c; do
    n=$(basename "$f" .c)
    gcc $FLAGS -O0 "$f" -o "build/O0/$n.s" || exit 1
    gcc $FLAGS -O2 "$f" -o "build/O2/$n.s" || exit 1
    if command -v riscv64-linux-gnu-gcc >/dev/null 2>&1; then
        riscv64-linux-gnu-gcc -S -O0 "$f" -o "build/riscv/$n.s"
    fi
done
echo "Assembly gerado em build/"
