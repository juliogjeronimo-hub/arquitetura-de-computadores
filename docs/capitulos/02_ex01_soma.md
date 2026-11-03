# Exemplo 1: Soma simples

## Código C

```c
int soma_simples(void) {
    int a = 5;
    int b = 3;
    int c = a + b;
    return c;
}
```

## Assembly gerado (x86-64, -O0)

```nasm
; ...
"soma_simples":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR -4[rbp], 5
	mov	DWORD PTR -8[rbp], 3
	mov	edx, DWORD PTR -4[rbp]
	mov	eax, DWORD PTR -8[rbp]
	add	eax, edx
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	leave
	ret
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int a = 5;` | `mov DWORD PTR -4[rbp], 5` | Grava o literal 5 na variável local `a` |
| `int b = 3;` | `mov DWORD PTR -8[rbp], 3` | Grava o literal 3 na variável local `b` |
| `int c = a + b;` | `mov edx, -4[rbp]` / `mov eax, -8[rbp]` / `add eax, edx` / `mov -12[rbp], eax` | Carrega `a` e `b`, soma e guarda em `c` |
| `return c;` | `mov eax, DWORD PTR -12[rbp]` | Coloca `c` em `eax` (registrador de retorno) |

## Explicação

A função não recebe parâmetros, mas usa três variáveis locais. O prólogo `push rbp` / `mov rbp, rsp` / `sub rsp, 16` monta o *stack frame* e reserva 16 bytes. As variáveis `a`, `b` e `c` ocupam, respectivamente, os endereços `-4[rbp]`, `-8[rbp]` e `-12[rbp]`, usando endereçamento relativo à base do quadro.

A soma não é feita em memória: o compilador primeiro carrega os operandos em registradores (`edx` recebe `a`, `eax` recebe `b`) e só então executa `add eax, edx`. Isso reflete a natureza registrador-registrador da operação aritmética, embora os dados venham da pilha.

Por fim, o valor calculado é gravado em `c` e imediatamente recarregado para `eax`, pois a convenção de chamada espera o retorno nesse registrador. O `leave` desfaz o quadro e `ret` devolve o controle. Note o trabalho redundante típico de `-O0`: valores vão à memória e voltam logo em seguida.

## Comparação -O0 vs. -O2

```nasm
; ...
"soma_simples":
	mov	eax, 8
	ret
```

Com `-O2`, o resultado é drástico: como todos os valores são constantes conhecidas em tempo de compilação, o GCC calcula `5 + 3 = 8` e retorna o literal diretamente em `eax`. Desaparecem o *stack frame*, os acessos à memória e a própria operação de soma. É um caso puro de *constant folding*: 12 instruções em `-O0` contra 2 em `-O2`.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. Numa arquitetura RISC (load/store), mesmo esta função mínima exigiria instruções separadas para carregar imediatos e somar em registradores (`li`/`addi`/`add`), já que operações aritméticas atuam somente sobre registradores. No x86-64 (CISC), em `-O0`, a instrução `mov` já aceita mover um imediato diretamente para a memória (`mov DWORD PTR -4[rbp], 5`), algo que em RISC-V demandaria carregar o imediato em um registrador e depois armazená-lo com `sw`.

## Ligação com a ementa

- **I.4 Formato da instrução:** a `mov` com imediato e com operando de memória ilustra formatos distintos de instrução.
- **I.5 Endereçamento:** uso de endereçamento relativo à base (`-4[rbp]`) para variáveis locais.
- **I.6 Tipos de instruções:** combinação de transferência de dados (`mov`), aritmética (`add`) e controle (`ret`).
