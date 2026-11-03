# Exemplo 5: Laços while e do-while

## Código C

```c
int soma_while(int n) {
    int soma = 0;
    int i = 0;
    while (i < n) {
        soma += i;
        i++;
    }
    return soma;
}

int soma_dowhile(int n) {
    int soma = 0;
    int i = 0;
    do {
        soma += i;
        i++;
    } while (i < n);
    return soma;
}
```

## Assembly gerado (x86-64, -O0)

```nasm
; ...
"soma_while":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	jmp	.L2
.L3:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
.L2:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L3
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret
; ...
"soma_dowhile":
; ...
.L6:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L6
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `while (i < n)` | `.L2:` `cmp eax, 16[rbp]` / `jl .L3` | Testa a condição **antes** do corpo |
| `soma += i;` | `add DWORD PTR -4[rbp], eax` | Acumula `i` em `soma` |
| `i++` | `add DWORD PTR -8[rbp], 1` | Incrementa `i` |
| `do { ... } while` | `.L6:` corpo seguido de `cmp`/`jl .L6` | Testa a condição **depois** do corpo |

## Explicação

O `while` em `-O0` é praticamente idêntico ao `for` do exemplo anterior: inicializa as variáveis, salta para o teste em `.L2`, e só entra no corpo `.L3` se `i < n`. Isso é esperado, pois `for` e `while` com mesma semântica geram o mesmo esqueleto — o teste da condição vem antes do corpo.

A diferença estrutural aparece em `soma_dowhile`. Como a semântica do `do-while` garante ao menos uma execução do corpo, não há o `jmp` inicial para o teste: o fluxo entra direto em `.L6`, executa o corpo e só então avalia `cmp`/`jl .L6`. O teste fica no fim do laço e não há salto de entrada, poupando uma instrução de desvio por chamada quando o laço executa.

Ambas as versões somam diretamente em memória (`add DWORD PTR -4[rbp], eax`), o que novamente evidencia o alto número de acessos à pilha no código não otimizado.

## Comparação -O0 vs. -O2

```nasm
"soma_dowhile":
	mov	eax, 1
	lea	r8d, -1[rcx]
	xor	edx, edx
	cmp	eax, ecx
	jge	.L21
; ...
.L13:
	lea	edx, 1[rdx+rax*2]
	add	eax, 2
	cmp	eax, ecx
	jl	.L13
.L21:
	mov	eax, edx
	ret
```

Com `-O2`, `soma_while` recebe exatamente a mesma otimização de `soma_for` (processamento de dois valores por iteração com `lea`), confirmando que o compilador trata os dois laços como equivalentes. Já `soma_dowhile` ganha um tratamento um pouco maior (35 instruções contra 31 no `-O0`) por causa do desenrolamento e dos ajustes de paridade sobre o caso que sempre executa ao menos uma vez. Os acessos à memória das variáveis locais foram eliminados em ambos.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. Em RISC-V, tanto `while` quanto `do-while` seriam construídos com `blt`/`bge` entre registradores, carregando previamente as variáveis via `lw`. A economia do `do-while` (um salto a menos na entrada) existe igualmente em RISC. A soma em memória do x86 (`add [mem], reg`) continuaria exigindo, em RISC-V, o trio `lw`/`add`/`sw`.

## Ligação com a ementa

- **I.6 Tipos de instruções:** controle de fluxo com `cmp`/`jl` e o papel do `jmp` de entrada.
- **V.2.3 Dependência de controle:** o salto de repetição no fim do laço é a dependência que condiciona a vazão do pipeline.
