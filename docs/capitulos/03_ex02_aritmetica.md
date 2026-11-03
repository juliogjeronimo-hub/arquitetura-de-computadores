# Exemplo 2: Aritmética

## Código C

```c
int aritmetica(int x, int y) {
    int s = x - y;
    int m = x * y;
    int d = x / y;
    int r = x % y;
    int l = (x & y) | (x ^ y);
    int sh = (x << 2) + (y >> 1);
    return s + m + d + r + l + sh;
}

int dobro(int x) {
    return x * 2;
}
```

## Assembly gerado (x86-64, -O0)

```nasm
; ...
"aritmetica":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR 24[rbp], edx
	mov	eax, DWORD PTR 16[rbp]
	sub	eax, DWORD PTR 24[rbp]      ; s = x - y
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	imul	eax, DWORD PTR 24[rbp]     ; m = x * y
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	cdq
	idiv	DWORD PTR 24[rbp]          ; d = x / y (quociente em eax)
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	cdq
	idiv	DWORD PTR 24[rbp]          ; r = x % y (resto em edx)
	mov	DWORD PTR -16[rbp], edx
; ...
	lea	edx, 0[0+rax*4]           ; x << 2
	mov	eax, DWORD PTR 24[rbp]
	sar	eax                       ; y >> 1
	add	eax, edx
; ...
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int s = x - y;` | `mov eax, 16[rbp]` / `sub eax, 24[rbp]` | Subtração inteira |
| `int m = x * y;` | `imul eax, 24[rbp]` | Multiplicação com sinal |
| `int d = x / y;` | `cdq` / `idiv 24[rbp]` | Divisão; quociente em `eax` |
| `int r = x % y;` | `cdq` / `idiv 24[rbp]` | Mesma divisão; resto em `edx` |
| `(x & y) | (x ^ y)` | `or eax, 24[rbp]` | Operações lógicas bit a bit |
| `x << 2` | `lea edx, 0[0+rax*4]` | Deslocamento à esquerda via `lea` (×4) |
| `y >> 1` | `sar eax` | Deslocamento aritmético à direita |

## Explicação

Esta função concentra a aritmética de computadores do capítulo correspondente do livro-base. A multiplicação usa `imul`; a divisão usa `idiv`, que exige a extensão de sinal do dividendo com `cdq` (replica o bit de sinal de `eax` em `edx`, formando o operando de 64 bits `edx:eax`). O mesmo `idiv` produz quociente em `eax` e resto em `edx`, por isso o cálculo de `x / y` e `x % y` reaproveita a estrutura.

Um detalhe interessante é o deslocamento `x << 2`: em vez de uma instrução de *shift*, o GCC usa `lea edx, 0[0+rax*4]`, explorando o cálculo de endereço (base + índice×escala) para multiplicar por 4. Já `y >> 1` vira `sar eax` (deslocamento aritmético que preserva o sinal). As operações lógicas (`&`, `^`, `|`) mapeiam diretamente para `and`, `xor`, `or`.

Como se trata de `-O0`, cada subexpressão é guardada em sua própria variável de pilha (`-4[rbp]` a `-24[rbp]`) e recarregada ao final para a soma acumulada — totalizando 48 instruções.

## Comparação -O0 vs. -O2

```nasm
; ...
"aritmetica":
	mov	eax, ecx
	mov	r8d, ecx
	mov	r10d, ecx
	mov	r9d, edx
	imul	r10d, edx
	sub	r8d, edx
	cdq
	idiv	r9d
; ...
	lea	edx, [r9+rcx*4]
	add	eax, edx
	ret
```

Com `-O2` o GCC elimina completamente os acessos à pilha: os operandos permanecem em registradores (`ecx`, `edx`, e os auxiliares `r8d`, `r9d`, `r10d`), e os resultados parciais são acumulados sem ida à memória. A contagem cai de 48 para 20 instruções. A divisão ainda exige `cdq`/`idiv` (não há atalho barato), mas o restante é reorganizado para minimizar transferências.

Para `dobro(x)`, o contraste é nítido:

```nasm
"dobro":
	lea	eax, [rcx+rcx]
	ret
```

A multiplicação por 2 vira `lea eax, [rcx+rcx]` (soma do registrador consigo mesmo), evitando uma instrução de multiplicação.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. No x86-64, instruções como `imul eax, DWORD PTR 24[rbp]` operam diretamente sobre um operando em memória. Em RISC-V, a filosofia load/store obrigaria carregar `y` para um registrador com `lw` antes de `mul`. A divisão com `idiv` e extensão por `cdq` também é específica de x86; RISC-V usa instruções dedicadas (`div`, `rem`) sem o passo de extensão em par de registradores.

## Ligação com a ementa

- **I.12 Aritmética de computadores:** subtração, multiplicação (`imul`), divisão com sinal e resto (`idiv`/`cdq`), deslocamentos (`sar`, `lea` como ×4) e operações lógicas (`and`/`xor`/`or`).
