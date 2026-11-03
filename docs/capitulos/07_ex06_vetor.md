# Exemplo 6: Vetor

## Código C

```c
int soma_vetor(void) {
    int v[10];
    for (int i = 0; i < 10; i++) {
        v[i] = i * 2;
    }
    int soma = 0;
    for (int i = 0; i < 10; i++) {
        soma += v[i];
    }
    return soma;
}
```

## Assembly gerado (x86-64, -O0)

O arquivo deste exemplo está anotado em sintaxe AT&T; o excerto abaixo preserva o código real.

```nasm
; ...
soma_vetor:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp          ; Aloca 64 bytes: v[10] (40 bytes) + variáveis
	movl	$0, -4(%rbp)      ; i = 0
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax    ; eax = i
	leal	(%rax,%rax), %edx ; edx = i * 2
	movl	-4(%rbp), %eax
	cltq                    ; estende eax para 64 bits em rax
	movl	%edx, -64(%rbp,%rax,4)  ; v[i] = i*2
	addl	$1, -4(%rbp)      ; i++
.L2:
	cmpl	$9, -4(%rbp)
	jle	.L3
; ...
.L5:
	movl	-12(%rbp), %eax
	cltq
	movl	-64(%rbp,%rax,4), %eax  ; eax = v[i]
	addl	%eax, -8(%rbp)    ; soma += v[i]
; ...
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int v[10];` | `subq $64, %rsp` | Reserva espaço do vetor no *stack frame* |
| `v[i] = i * 2;` | `leal (%rax,%rax), %edx` / `movl %edx, -64(%rbp,%rax,4)` | Calcula `i*2` e grava em `v[i]` |
| `i < 10` (teste) | `cmpl $9, -4(%rbp)` / `jle .L3` | Repete enquanto `i <= 9` |
| `soma += v[i];` | `movl -64(%rbp,%rax,4), %eax` / `addl %eax, -8(%rbp)` | Lê `v[i]` e acumula |

## Explicação

O vetor `v[10]` é alocado na pilha; o prólogo reserva 64 bytes (40 para os dez inteiros, mais variáveis e alinhamento). O acesso a cada elemento usa o endereçamento indexado com escala: `-64(%rbp,%rax,4)` calcula `rbp - 64 + i×4`, onde a escala 4 corresponde ao tamanho de um `int`. Esse é o modo de endereçamento típico para arranjos, central no estudo de tipos de endereçamento.

A instrução `cltq` estende o índice `i` de 32 para 64 bits antes de usá-lo como componente de 64 bits do endereço, garantindo que o cálculo do deslocamento seja feito corretamente. A multiplicação `i*2` é novamente otimizada mesmo em `-O0` para `leal (%rax,%rax), %edx` (soma do registrador com ele mesmo).

Os dois laços — um para preencher e outro para somar — percorrem o mesmo vetor sequencialmente, explorando a localidade espacial: elementos vizinhos na memória são acessados em ordem, favorecendo o uso da cache. A localidade temporal aparece no acúmulo em `soma`, uma posição reutilizada a cada iteração.

## Comparação -O0 vs. -O2

```nasm
soma_vetor:
	subq	$56, %rsp
	movq	.LC0(%rip), %xmm0
	movq	.LC1(%rip), %xmm2
; ...
.L2:
	movdqa	%xmm0, %xmm1
	paddd	%xmm2, %xmm0
	pslld	$1, %xmm1
	movq	%xmm1, -8(%rax)
	cmpq	%rdx, %rax
	jne	.L2
	movdqu	16(%rsp), %xmm0
	paddd	(%rsp), %xmm0
; ...
	movd	%xmm0, %eax
	ret
```

Com `-O2`, o GCC **vetoriza** o laço usando registradores SSE de 128 bits (`xmm0`, `xmm1`, `xmm2`). As instruções `paddd` (soma de inteiros empacotados) e `pslld` (deslocamento à esquerda empacotado) processam quatro inteiros de uma vez, e a soma final usa `psrldq` para reduzir o vetor a um escalar. É um salto qualitativo: deixa de ser código escalar e passa a explorar paralelismo de dados (SIMD). A contagem cai de 27 para 25 instruções, mas o ganho real está em fazer quatro operações por instrução.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. O acesso indexado com escala `-64(%rbp,%rax,4)` é um único modo de endereçamento no x86. Em RISC-V, seria necessário calcular o endereço explicitamente: multiplicar/deslocar o índice (`slli` por 2 para ×4), somar à base e então usar `lw`/`sw`. A vetorização SSE do `-O2` tem paralelo nas extensões vetoriais do RISC-V (RVV), mas não faz parte do conjunto base de 32 registradores inteiros.

## Ligação com a ementa

- **I.5 Tipos de endereçamento:** endereçamento indexado com escala (`base + índice×4`) para acesso a arranjos.
- **III.2 Localidade espacial e temporal:** varredura sequencial do vetor (espacial) e reuso de `soma` (temporal), base do bom aproveitamento de cache.
