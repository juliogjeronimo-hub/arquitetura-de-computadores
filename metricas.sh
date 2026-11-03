#!/bin/bash
mkdir -p docs
out=docs/metricas.md
cnt() {
    if [ -f "$1" ]; then grep -cE '^\s+[a-z]' "$1"; else echo "n/d"; fi
}
echo "| Exemplo | Instruções x86 -O0 | Instruções x86 -O2 | Instruções RISC-V -O0 |" > "$out"
echo "|---|---|---|---|" >> "$out"
for f in src/*.c; do
    n=$(basename "$f" .c)
    echo "| $n | $(cnt build/O0/$n.s) | $(cnt build/O2/$n.s) | $(cnt build/riscv/$n.s) |" >> "$out"
done
