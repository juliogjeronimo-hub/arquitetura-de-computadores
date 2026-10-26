# Explicação do Assembly — `main.s`

Este documento descreve, bloco a bloco, o que o arquivo `build/main.s` faz. O assembly foi gerado a partir de `src/main.c` com:

```bash
gcc -S -O0 -masm=intel src/main.c -o build/main.s
```

O programa pede dois números ao usuário, mostra cada um e imprime a soma.

## Convenções úteis para ler o código

- **Sintaxe Intel**: o destino vem antes da origem — `mov rcx, rax` significa `rcx = rax`.
- **Convenção de chamada do Windows x64**:
  - Inteiros/ponteiros: 1º arg em `rcx`, 2º em `rdx`, 3º em `r8`, 4º em `r9`.
  - Ponto flutuante: `xmm0`–`xmm3`. Em funções variádicas (como `printf`), o `double` também é copiado para o registrador inteiro correspondente.
- **Variáveis locais**: acessadas por offset a partir de `rbp` (ex.: `rbp-8`).
- **`-O0`**: sem otimização, então aparecem várias cópias `movapd` redundantes.

---

## Bloco 1 — Cabeçalho e diretivas

```asm
.file   "main.c"
.intel_syntax noprefix
.text
.section .rdata,"dr"
```

| Diretiva | Função |
|----------|--------|
| `.file` | Nome do fonte original |
| `.intel_syntax noprefix` | Usa sintaxe Intel (sem `%`/`$`) |
| `.text` | Seção de código executável |
| `.section .rdata,"dr"` | Seção de dados somente leitura |

---

## Bloco 2 — Strings constantes

```asm
.LC0: .ascii "Digite o primeiro numero: \0"
.LC1: .ascii "%lf\0"
.LC2: .ascii "Digite o segundo numero: \0"
.LC3: .ascii "\12Primeiro numero: %.2f\12\0"
.LC4: .ascii "Segundo numero: %.2f\12\0"
.LC5: .ascii "Soma: %.2f\12\0"
```

Todos os textos do programa ficam aqui, na `.rdata`.

- `\0` marca o fim da string.
- `\12` é o código octal de `\n` (nova linha).
- `%lf` é o formato que o `scanf` usa para ler um `double`; `%.2f` formata com 2 casas decimais na saída.

---

## Bloco 3 — Prólogo da função `main`

```asm
push    rbp
mov     rbp, rsp
sub     rsp, 48
...
call    "__main"
```

Monta o *stack frame* e prepara a execução:

1. `push rbp` + `mov rbp, rsp` — salva e estabelece o novo frame.
2. `sub rsp, 48` — reserva 48 bytes: **16** para as variáveis `numero1` e `numero2` (8 cada) + **32** de *shadow space* exigido pela ABI do Windows x64.
3. `call "__main"` — inicializa o runtime C (CRT) do MinGW.

As diretivas `.seh_*` registram o frame para o tratamento de exceções do Windows (SEH); não geram código executável.

---

## Bloco 4 — Ler o primeiro número

```asm
lea     rax, .LC0[rip]     ; "Digite o primeiro numero: "
mov     rcx, rax
call    "printf"

lea     rax, -8[rbp]       ; &numero1
lea     rcx, .LC1[rip]     ; "%lf"
mov     rdx, rax
call    "scanf"
```

Imprime o primeiro prompt e lê o valor digitado. O endereço de `numero1` (`rbp-8`) vai em `rdx` (2º argumento do `scanf`).

---

## Bloco 5 — Ler o segundo número

```asm
lea     rax, .LC2[rip]     ; "Digite o segundo numero: "
mov     rcx, rax
call    "printf"

lea     rax, -16[rbp]      ; &numero2
lea     rcx, .LC1[rip]     ; "%lf"
mov     rdx, rax
call    "scanf"
```

Mesma lógica do bloco anterior, agora para `numero2`, armazenado em `rbp-16`.

---

## Bloco 6 — Imprimir os dois números

```asm
movsd   xmm0, QWORD PTR -8[rbp]   ; carrega numero1
movq    rdx, xmm1                 ; double também em rdx (printf é variádica)
lea     rax, .LC3[rip]            ; "\nPrimeiro numero: %.2f\n"
mov     rcx, rax
call    "printf"
```

(o bloco para `numero2` usa `rbp-16` e a string `.LC4`)

Cada `double` é carregado num registrador SSE (`xmm`) e, por ser `printf` variádica, também copiado para `rdx`. As instruções `movapd` repetidas são apenas artefatos do `-O0` — com otimização elas desapareceriam.

---

## Bloco 7 — Calcular e imprimir a soma

```asm
movsd   xmm1, QWORD PTR -8[rbp]    ; numero1
movsd   xmm0, QWORD PTR -16[rbp]   ; numero2
addsd   xmm0, xmm1                 ; xmm0 = numero1 + numero2
movq    rdx, xmm1
lea     rax, .LC5[rip]             ; "Soma: %.2f\n"
mov     rcx, rax
call    "printf"
```

A instrução `addsd` ("add scalar double") soma os dois valores de ponto flutuante. O resultado é formatado e impresso.

---

## Bloco 8 — Epílogo e retorno

```asm
mov     eax, 0      ; return 0
add     rsp, 48     ; libera o espaço reservado no prólogo
pop     rbp         ; restaura o frame anterior
ret                 ; retorna para a CRT, que encerra o processo
```

Desfaz o que o prólogo montou e devolve `0` como código de saída.

---

## Bloco 9 — Símbolos externos

```asm
.def "__main"; ...
.def "printf"; ...
.def "scanf";  ...
```

Declara as funções externas (`__main`, `printf`, `scanf`) que serão resolvidas na etapa de **linkagem**, quando o objeto é unido às bibliotecas do sistema para formar o executável.

---

## Fluxo resumido

```
Prólogo → __main
   → printf + scanf  (numero1)
   → printf + scanf  (numero2)
   → printf          (numero1)
   → printf          (numero2)
   → addsd + printf  (soma)
Epílogo → return 0
```
