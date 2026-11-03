# Introdução

## Objetivo

Este trabalho investiga como construções básicas da linguagem C são traduzidas para linguagem de montagem (assembly) pelo compilador GCC. A proposta é observar, em exemplos pequenos e controlados, de que forma operações aritméticas, decisões condicionais, laços, vetores, chamadas de função, recursão e ponteiros se materializam em instruções de máquina, registradores e acessos à memória.

O estudo apoia-se nos conceitos de Organização de Computadores apresentados por Hennessy & Patterson em *Organização e Projeto de Computadores: Interface Hardware/Software* (Elsevier, 2005), de forma a ligar a prática observada no assembly à teoria de formato de instrução, modos de endereçamento, pilha, convenção de chamada e pipeline.

## Metodologia

Para cada exemplo em C, o código-fonte foi compilado com GCC gerando assembly em dois níveis de otimização (`-O0` e `-O2`). A comparação entre esses dois níveis evidencia o trabalho do compilador: eliminação de acessos redundantes à memória, substituição de multiplicações por `lea`/deslocamentos, simplificação de laços e cálculo em tempo de compilação (*constant folding*).

Todo trecho de assembly citado neste documento foi extraído literalmente dos arquivos `.s` gerados. Excertos longos tiveram diretivas irrelevantes removidas (sinalizadas por `; ...`), preservando as instruções que importam para a explicação.

## Ferramentas

- **Compilador:** GCC (Rev4, MSYS2, versão 16.2.0), gerando código x86-64.
- **Sintaxe:** os exemplos foram gerados com `-masm=intel` (sintaxe Intel, `mov destino, origem`). Alguns arquivos foram posteriormente anotados em sintaxe AT&T com comentários didáticos, e são citados fielmente nesse formato.
- **Arquitetura-alvo principal:** x86-64 (CISC), com convenção de chamada do ambiente Windows/MSYS2.

## Comandos usados

O script `gerar.sh` reproduz a geração do assembly:

```bash
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
```

A flag `-S` interrompe a compilação na etapa de geração de assembly; `-masm=intel` seleciona a sintaxe Intel; as flags `-fno-asynchronous-unwind-tables` e `-fno-dwarf2-cfi-asm` suprimem diretivas de *unwinding* para deixar a saída mais legível.

## Organização do documento

O texto segue a ordem: fundamentos de arquitetura x86-64 (registradores, pilha, convenção de chamada); nove capítulos de exemplos práticos, cada um com código C, assembly real e explicação; análises comparativas entre `-O0` e `-O2` e entre as filosofias CISC e RISC; a ligação dos exemplos com o conceito de pipeline; e, por fim, conclusão e referências.
