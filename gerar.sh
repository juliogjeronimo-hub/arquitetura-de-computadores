#!/bin/bash
# Gera assembly x86-64 (-O0 e -O2) e RISC-V (se o compilador existir)
# Usa MSYS2 UCRT64 para gerar RISC-V

FLAGS="-S -masm=intel -fno-asynchronous-unwind-tables -fno-dwarf2-cfi-asm"
RISCV_FLAGS="-S -O0 -fno-asynchronous-unwind-tables -fno-dwarf2-cfi-asm"
mkdir -p build/O0 build/O2 build/riscv

# Detectar se estamos no MSYS2
if [ -f /ucrt64/bin/riscv64-unknown-elf-gcc ]; then
    RISCV_CC="/ucrt64/bin/riscv64-unknown-elf-gcc"
else
    RISCV_CC="riscv64-unknown-elf-gcc"
fi

for f in src/*.c; do
    n=$(basename "$f" .c)
    echo "Gerando $n..."

    # x86-64 O0
    gcc $FLAGS -O0 "$f" -o "build/O0/$n.s" || { echo "Erro em $n O0"; exit 1; }

    # x86-64 O2
    gcc $FLAGS -O2 "$f" -o "build/O2/$n.s" || { echo "Erro em $n O2"; exit 1; }

    # RISC-V (se disponivel)
    if command -v $RISCV_CC >/dev/null 2>&1 || [ -f /ucrt64/bin/riscv64-unknown-elf-gcc ]; then
        $RISCV_CC $RISCV_FLAGS "$f" -o "build/riscv/$n.s"
    fi
done

echo ""
echo "Assembly gerado em build/:"
echo "  build/O0/   - x86-64 sem otimizacao"
echo "  build/O2/   - x86-64 com otimizacao"
echo "  build/riscv/ - RISC-V (se toolchain instalado)"
