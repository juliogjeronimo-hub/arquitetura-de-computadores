# Exemplo 7: Função e chamada

## Código C

```c
int soma(int a, int b) {
    return a + b;
}

int chamada(void) {
    return soma(4, 6);
}
```

## Assembly gerado (x86-64, -O0)

O arquivo deste exemplo está anotado em sintaxe AT&T; o excerto abaixo preserva o código real.

```nasm
; ...
soma:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%ecx, 16(%rbp)    ; a = ecx
	movl	%edx, 24(%rbp)    ; b = edx
	movl	16(%rbp), %edx    ; edx = a
	movl	24(%rbp), %eax    ; eax = b
	addl	%edx, %eax        ; eax = a + b
	popq	%rbp
	ret
; ...
chamada:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp         ; shadow space
	movl	$6, %edx          ; 2º argumento
	movl	$4, %ecx          ; 1º argumento
	call	soma              ; resultado em eax
	addq	$32, %rsp
	popq	%rbp
	ret
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int soma(int a, int b)` | `movl %ecx, 16(%rbp)` / `movl %edx, 24(%rbp)` | Salva parâmetros recebidos em `ecx`/`edx` |
| `return a + b;` | `addl %edx, %eax` | Soma e deixa o resultado em `eax` |
| `soma(4, 6)` | `movl $6, %edx` / `movl $4, %ecx` / `call soma` | Prepara argumentos e chama |
| retorno | `addq $32, %rsp` / `popq %rbp` / `ret` | Desfaz o frame e retorna |

## Explicação

Este exemplo mostra o mecanismo de chamada de função. Em `chamada`, antes de `call soma`, os argumentos são colocados nos registradores da convenção: o 1º (`4`) em `ecx`, o 2º (`6`) em `edx`. A instrução `call` empilha o endereço de retorno e desvia para `soma`; ao final, `ret` desempilha esse endereço e retorna o controle.

A reserva `subq $32, %rsp` cria o *shadow space* — uma região de 32 bytes que a convenção de chamada do ambiente Windows exige que o chamador disponibilize para a função chamada. Dentro de `soma`, os parâmetros chegam em `ecx`/`edx` e são copiados para o *stack frame* (`16(%rbp)`, `24(%rbp)`) antes de serem somados, comportamento típico de `-O0`.

Essa separação entre preparação de argumentos, transferência de controle e retorno de valor é a essência da linguagem de montagem como interface entre níveis (máquina multinível): o código de alto nível `soma(4,6)` vira um protocolo concreto de registradores e pilha.

## Comparação -O0 vs. -O2

```nasm
soma:
	leal	(%rcx,%rdx), %eax
	ret
; ...
chamada:
	movl	$10, %eax
	ret
```

Com `-O2`, `soma` reduz-se a `leal (%rcx,%rdx), %eax` — uma única instrução que soma os dois parâmetros diretamente dos registradores, sem salvar nada na pilha. O caso mais marcante é `chamada`: o GCC faz *inlining* de `soma(4,6)` e, como os argumentos são constantes, calcula `4 + 6 = 10` em tempo de compilação. O `call` desaparece por completo e a função retorna o literal `movl $10, %eax`. A contagem cai de 18 para 4 instruções no total.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. A mecânica é semelhante: RISC-V passa os primeiros argumentos em registradores (`a0`, `a1`) e usa `jal`/`ret` para chamada e retorno, com o endereço de retorno guardado no registrador `ra` (e não implicitamente na pilha como o `call` do x86 faz). A principal diferença é que o x86 empilha o endereço de retorno automaticamente no `call`, enquanto RISC-V o deixa em um registrador, refletindo a filosofia de instruções mais simples e uniformes.

## Ligação com a ementa

- **I.7 Linguagem de montagem:** o protocolo de chamada (argumentos em registradores, `call`/`ret`, valor em `eax`) é a tradução concreta da chamada de função.
- **I.9 Máquinas multinível:** a chamada de alto nível `soma(4,6)` é realizada por convenções de baixo nível, ilustrando a estratificação de níveis da máquina.
