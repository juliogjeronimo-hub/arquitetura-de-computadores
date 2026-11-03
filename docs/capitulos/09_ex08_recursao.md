# Exemplo 8: Recursão

## Código C

```c
int fatorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * fatorial(n - 1);
}
```

## Assembly gerado (x86-64, -O0)

O arquivo deste exemplo está anotado em sintaxe AT&T; o excerto abaixo preserva o código real.

```nasm
; ...
fatorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp         ; shadow space
	movl	%ecx, 16(%rbp)    ; n = ecx
	cmpl	$1, 16(%rbp)      ; compara n com 1
	jg	.L2                ; se n > 1, caso recursivo
	movl	$1, %eax          ; caso base: return 1
	jmp	.L3
.L2:
	movl	16(%rbp), %eax
	subl	$1, %eax          ; n - 1
	movl	%eax, %ecx        ; argumento da chamada recursiva
	call	fatorial          ; fatorial(n - 1)
	imull	16(%rbp), %eax    ; n * fatorial(n-1)
.L3:
	addq	$32, %rsp
	popq	%rbp
	ret
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `if (n <= 1)` | `cmpl $1, 16(%rbp)` / `jg .L2` | Testa o caso base |
| `return 1;` | `movl $1, %eax` / `jmp .L3` | Caso base retorna 1 |
| `n - 1` | `subl $1, %eax` | Calcula o argumento da recursão |
| `fatorial(n - 1)` | `movl %eax, %ecx` / `call fatorial` | Chamada recursiva |
| `n * fatorial(n-1)` | `imull 16(%rbp), %eax` | Multiplica pelo `n` guardado no frame |

## Explicação

A recursão combina decisão condicional e chamada de função. Primeiro, `cmpl $1, 16(%rbp)` com `jg .L2` separa o caso base (n ≤ 1, retorna 1) do caso recursivo. Esta é a condição de parada, essencial para que a recursão termine.

No caso recursivo, o valor `n - 1` é preparado em `ecx` e `call fatorial` é executado. É aqui que o papel da pilha fica evidente: cada chamada recursiva cria um novo *stack frame*, de modo que o `n` de cada nível fica preservado em sua própria posição `16(%rbp)`. Quando a chamada retorna com o resultado em `eax`, a instrução `imull 16(%rbp), %eax` multiplica esse resultado pelo `n` do nível corrente — e é por isso que `n` precisava estar guardado no frame, intacto após a chamada.

A profundidade da recursão corresponde à profundidade da pilha: para `fatorial(5)` há cinco frames empilhados antes do primeiro retorno. Isso ilustra diretamente o uso da memória (pilha) como suporte da execução.

## Comparação -O0 vs. -O2

```nasm
fatorial:
	movl	$1, %eax
	cmpl	$1, %ecx
	jle	.L1
.L2:
	imull	%ecx, %eax
	subl	$1, %ecx
	cmpl	$1, %ecx
	jne	.L2
.L1:
	ret
```

Com `-O2`, o GCC aplica *tail-call elimination* convertendo a recursão em um **laço iterativo**. Não há mais `call fatorial`: o acumulador `eax` começa em 1 e, a cada volta de `.L2`, multiplica por `ecx` e decrementa `ecx` até chegar a 1. A pilha de frames desaparece, eliminando o custo das chamadas e o risco de estouro de pilha. A contagem cai de 16 para 8 instruções, e o comportamento assintótico de memória passa de O(n) para O(1).

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. Em RISC-V, a versão recursiva salvaria o endereço de retorno (`ra`) e o `n` corrente na pilha antes de cada `jal fatorial`, pois `jal` sobrescreve `ra`. O x86 esconde parte desse trabalho no `call`/`ret`. A transformação em laço feita pelo `-O2` seria igualmente possível em RISC-V, resultando em código muito semelhante com `mul`/`addi` e um desvio condicional.

## Ligação com a ementa

- **I.3 Memória:** a pilha de chamadas cresce com a profundidade da recursão, mostrando o uso da memória como estrutura de suporte à execução.
- **I.9 Máquinas multinível:** a recursão de alto nível é sustentada pelo protocolo de chamada de baixo nível (`call`/`ret`, frames).
