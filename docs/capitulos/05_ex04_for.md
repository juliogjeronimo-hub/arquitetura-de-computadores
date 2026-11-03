# Exemplo 4: Laço for

## Código C

```c
int soma_for(int n) {
    int soma = 0;
    for (int i = 0; i < n; i++) {
        soma += i;
    }
    return soma;
}
```

## Assembly gerado (x86-64, -O0)

```nasm
; ...
"soma_for":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR -4[rbp], 0        ; soma = 0
	mov	DWORD PTR -8[rbp], 0        ; i = 0
	jmp	.L2
.L3:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax      ; soma += i
	add	DWORD PTR -8[rbp], 1        ; i++
.L2:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L3                        ; se i < n, repete
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret
```

## Correspondência C → Assembly

| Linha em C | Instruções assembly | O que faz |
|---|---|---|
| `int soma = 0;` | `mov DWORD PTR -4[rbp], 0` | Inicializa `soma` |
| `int i = 0;` | `mov DWORD PTR -8[rbp], 0` | Inicializa `i` |
| `i < n` (teste) | `.L2:` `cmp eax, 16[rbp]` / `jl .L3` | Testa a condição no fim do laço |
| `soma += i;` | `add DWORD PTR -4[rbp], eax` | Acumula `i` em `soma` |
| `i++` | `add DWORD PTR -8[rbp], 1` | Incrementa `i` |

## Explicação

O GCC organiza o `for` com o teste da condição no final do laço — padrão conhecido como *loop rotation*. Logo após inicializar `soma` e `i`, executa `jmp .L2`, que salta direto para a avaliação da condição. Se `i < n`, cai em `.L3` (o corpo); caso contrário, prossegue para o retorno. Essa estrutura garante que o corpo não seja executado quando `n <= 0`.

No corpo (`.L3`), `soma += i` é feito em duas instruções: carrega `i` em `eax` e usa `add DWORD PTR -4[rbp], eax`, que soma um registrador diretamente a um operando de memória — uma conveniência do CISC. O incremento `i++` é um `add` sobre a posição de memória de `i`.

O bloco `.L2` concentra a dependência de controle do laço: `cmp` compara `i` com `n` e `jl` decide se há nova iteração. A cada volta, o processador precisa do resultado dessa comparação para saber o próximo endereço a buscar.

## Comparação -O0 vs. -O2

```nasm
"soma_for":
	test	ecx, ecx
	jle	.L4
	xor	eax, eax
	xor	edx, edx
	test	cl, 1
	je	.L3
; ...
.L3:
	lea	edx, 1[rdx+rax*2]
	add	eax, 2
	cmp	ecx, eax
	jne	.L3
.L1:
	mov	eax, edx
	ret
```

Com `-O2`, o laço é transformado agressivamente. O GCC aplica *strength reduction* e *loop unrolling* parcial: processa dois valores de `i` por iteração (`add eax, 2`) e calcula a soma acumulada com `lea edx, 1[rdx+rax*2]`, substituindo a soma iterativa por aritmética de endereço. Há ainda um teste de paridade (`test cl, 1`) para tratar o número ímpar de iterações. Curiosamente, a contagem de instruções estáticas sobe (16 para 18), mas o número de instruções **executadas por iteração** cai, pois cada volta cobre dois valores. Isso ilustra que menos instruções no arquivo não é o mesmo que menos trabalho em tempo de execução — e vice-versa.

## Comparação CISC vs. RISC

Assembly RISC-V não gerado neste trabalho; comparação teórica. Em RISC-V, `soma += i` não poderia somar diretamente a um operando de memória: seria preciso `lw` para carregar `soma`, `add` entre registradores e `sw` para gravar de volta. O x86 condensa isso em `add DWORD PTR -4[rbp], eax`. No teste do laço, RISC-V combina comparação e salto em uma única instrução (`blt`), enquanto o x86 usa o par `cmp` + `jl`.

## Ligação com a ementa

- **I.2 Ciclo de instrução:** a repetição do laço evidencia busca/decodificação/execução a cada iteração.
- **V.2.3 Dependência de controle:** o salto `jl .L3` no fim do laço é a dependência de controle que o preditor de desvios do pipeline procura antecipar.
