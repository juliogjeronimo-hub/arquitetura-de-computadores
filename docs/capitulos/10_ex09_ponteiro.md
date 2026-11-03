# Exemplo 9: Ponteiro

## Código C

```c
void incrementa(int *p) {
    *p = *p + 1;
}

int usa_ponteiro(void) {
    int x = 10;
    incrementa(&x);
    return x;
}
```

## Assembly gerado (x86-64, -O0)

O arquivo deste exemplo está anotado em sintaxe AT&T; o excerto abaixo preserva o código real.

```nasm
; ...
incrementa:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rcx, 16(%rbp)    ; p = rcx (ponteiro)
	movq	16(%rbp), %rax    ; rax = p
	movl	(%rax), %eax      ; eax = *p (desreferencia)
	leal	1(%rax), %edx     ; edx = *p + 1
	movq	16(%rbp), %rax    ; rax = p (recarrega)
	movl	%edx, (%rax)      ; *p = edx (escreve)
	nop
	popq	%rbp
	ret
; ...
usa_ponteiro:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	$10, -4(%rbp)     ; x = 10
	leaq	-4(%rbp), %rax    ; rax = &x
	movq	%rax, %rcx        ; 1º argumento
	call	incrementa        ; incrementa(&x)
	movl	-4(%rbp), %eax    ; return x
; ...
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int *p` (parâmetro) | `movq %rcx, 16(%rbp)` | Guarda o ponteiro (64 bits) no frame |
| `*p` (leitura) | `movq 16(%rbp), %rax` / `movl (%rax), %eax` | Carrega o endereço e desreferencia |
| `*p + 1` | `leal 1(%rax), %edx` | Soma 1 ao valor apontado |
| `*p = ...` (escrita) | `movl %edx, (%rax)` | Escreve no endereço apontado |
| `&x` | `leaq -4(%rbp), %rax` | Calcula o endereço de `x` |

## Explicação

Este exemplo mostra o endereçamento indireto. O ponteiro `p` é uma variável de 64 bits (por isso `movq`, não `movl`), pois armazena um endereço. A desreferência `*p` acontece em dois passos: primeiro `movq 16(%rbp), %rax` carrega o endereço contido em `p` para `rax`; depois `movl (%rax), %eax` usa esse endereço como base — os parênteses `(%rax)` indicam "o conteúdo da memória apontada por rax". Isso é o endereçamento indireto por registrador.

A escrita `*p = *p + 1` fecha o ciclo: após calcular o novo valor com `leal 1(%rax), %edx`, a instrução `movl %edx, (%rax)` grava de volta no endereço apontado. A distinção entre o valor do ponteiro (o endereço) e o valor apontado (o `int`) é o que o assembly torna explícito.

Em `usa_ponteiro`, a instrução-chave é `leaq -4(%rbp), %rax`: o operador `&x` de C vira o cálculo do endereço de `x` na pilha (`load effective address`), que é então passado como argumento. O `nop` em `incrementa` é apenas um preenchimento inócuo antes do epílogo.

## Comparação -O0 vs. -O2

```nasm
incrementa:
	addl	$1, (%rcx)
	ret
; ...
usa_ponteiro:
	movl	$11, %eax
	ret
```

Com `-O2`, `incrementa` colapsa em uma única instrução: `addl $1, (%rcx)` incrementa diretamente o valor apontado, sem `stack frame` nem leitura/escrita separadas. Em `usa_ponteiro`, o GCC faz *inlining* e análise de fluxo: percebe que `x` começa em 10, é incrementado uma vez e retornado, então calcula `11` em tempo de compilação e retorna `movl $11, %eax`. Toda a indireção some. A contagem cai de 22 para 4 instruções.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. O endereçamento indireto do x86, que permite `movl (%rax), %eax` e `addl $1, (%rcx)` (operar sobre memória apontada), em RISC-V exige a sequência load/store explícita: `lw` para ler o valor apontado, `addi` para incrementar e `sw` para gravar de volta. O cálculo de `&x` (`leaq`) corresponde a somar o deslocamento ao `sp`/`fp` com `addi`. É um contraste claro entre a riqueza de modos de endereçamento do CISC e a uniformidade do RISC.

## Ligação com a ementa

- **I.5 Endereçamento indireto:** a desreferência `*p` via `(%rax)` e a escrita `movl %edx, (%rax)` são exemplos diretos de endereçamento indireto por registrador.
