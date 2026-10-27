# Referência de Comandos Assembly x86-64 (Sintaxe Intel)

Este documento descreve objetivamente os comandos assembly utilizados nos exemplos da Etapa 2.

---

## Diretivas do Assembler

| Diretiva | Função |
|----------|--------|
| `.file` | Especifica o nome do arquivo fonte |
| `.intel_syntax noprefix` | Usa sintaxe Intel sem prefixos `%` ou `$` |
| `.text` | Inicia seção de código executável |
| `.globl` | Torna um símbolo visível ao linker |
| `.def` / `.endef` | Define metadados COFF para depuração |
| `.ident` | Identifica o compilador que gerou o código |

---

## Instruções de Movimentação de Dados

### `mov dest, src`
Move dados de origem para destino. Não afeta flags.

**Exemplos:**
- `mov eax, 5` — carrega 5 em eax
- `mov DWORD PTR -4[rbp], 5` — escreve 5 na memória em [rbp-4]
- `mov edx, DWORD PTR -4[rbp]` — carrega valor de memória em edx

**Tipos de operandos:**
- `DWORD PTR` — acesso a 4 bytes (32 bits)
- `-4[rbp]` — acesso indireto: endereço em rbp, com offset de -4 bytes

---

## Instruções de Operações Aritméticas

### `add dest, src`
Soma src em dest, armazena resultado em dest. Afeta flags (Zero, Carry, etc.).

**Exemplos:**
- `add eax, edx` — eax = eax + edx
- `add [rbp-4], 1` — incrementa valor em memória (se operando for registrador)

---

## Instruções de Controle de Fluxo

### `jmp label`
Salta incondicionalmente para label (utilizado em loops e desvios).

**Exemplo:** `jmp .L2` — salta para rótulo .L2

### `je label` / `jne label` / `jle label` / `jl label`
Saltos condicionais após comparação ou teste.

- `je` — Jump if Equal (salta se Zero flag = 1)
- `jne` — Jump if Not Equal (salta se Zero flag = 0)
- `jle` — Jump if Less or Equal (salta se resultado ≤ 0)
- `jl` — Jump if Less (salta se resultado < 0)

**Exemplo:** `cmp eax, edx; jl loop_start` — se eax < edx, volta ao início do loop

### `cmp dest, src`
Compara subtração dest - src sem armazenar resultado, apenas afeta flags.

**Exemplo:** `cmp i, n; jl .L2` — se i < n, continua loop

---

## Instruções de Pilha

### `push reg`
Decrementa RSP em 8 bytes e armazena registrador na pilha.

**Exemplo:** `push rbp` — salva frame pointer anterior

### `pop reg`
Carrega valor do topo da pilha em registrador e incrementa RSP em 8 bytes.

**Exemplo:** `pop rbp` — restaura frame pointer

### `leave`
Equivalente a `mov rsp, rbp; pop rbp`. Desfaz o frame da função.

---

## Instruções de Chamada e Retorno

### `call label`
Empilha o endereço da próxima instrução e salta para label (chamada de função).

**Exemplo:** `call printf` — chama a função printf

### `ret`
Desempilha o endereço de retorno e salta para ele.

**Exemplo:** `ret` — retorna da função

---

## Instruções de Operações Lógicas

### `and dest, src`
Operação AND bit a bit entre dest e src.

**Exemplo:** `and eax, edx` — eax = eax AND edx

### `or dest, src`
Operação OR bit a bit entre dest e src.

**Exemplo:** `or eax, edx` — eax = eax OR edx

### `xor dest, src`
Operação XOR bit a bit entre dest e src.

**Exemplo:** `xor eax, edx` — eax = eax XOR edx

---

## Instruções de Deslocamento

### `shl dest, count` / `sal dest, count`
Deslocamento à esquerda (left shift). Cada deslocamento multiplica por 2.

**Exemplo:** `shl eax, 2` — eax = eax * 4 (deslocamento de 2 posições)

### `shr dest, count`
Deslocamento à direita lógico (right shift). Preenche com zeros.

**Exemplo:** `shr eax, 1` — eax = eax / 2 (deslocamento de 1 posição)

### `sar dest, count`
Deslocamento à direita aritmético. Preenche com o bit de sinal.

**Exemplo:** `sar eax, 1` — eax = eax / 2 (preservando sinal)

---

## Instruções de Multiplicação e Divisão

### `imul dest, src` / `imul dest, src, immediate`
Multiplicação de inteiros com sinal.

**Exemplos:**
- `imul eax, edx` — eax = eax * edx
- `imul eax, 10` — eax = eax * 10

### `cdq`
Converte EAX para EDX:EAX (expande 32 bits em 64 bits com sinal).

**Uso:** Obrigatório antes de `idiv` para preparar o dividendo.

### `idiv src`
Divisão de inteiros com sinal. EDX:EAX ÷ src.

**Resultado:**
- `eax` — quociente
- `edx` — resto

**Exemplo:**
```asm
mov eax, 10      ; dividendo = 10
cdq              ; prepara EDX:EAX
mov ecx, 3       ; divisor = 3
idiv ecx         ; eax = 10/3 = 3, edx = 10%3 = 1
```

---

## Convenção de Chamada (Windows x64 / UCRT64)

| Função | Uso |
|--------|-----|
| 1º argumento inteiro | `rcx` (ou `ecx` para 32 bits) |
| 2º argumento inteiro | `rdx` (ou `edx` para 32 bits) |
| 3º argumento inteiro | `r8` (ou `r8d` para 32 bits) |
| 4º argumento inteiro | `r9` (ou `r9d` para 32 bits) |
| Valor de retorno | `rax` (ou `eax` para 32 bits) |
| Stack frame pointer | `rbp` |
| Stack pointer | `rsp` |

---

## Tamanhos de Operandos

| Sufixo/PTR | Tamanho | Registrador |
|-----------|--------|-----------|
| Byte | 8 bits | `al`, `bl`, `cl`, `dl` |
| Word | 16 bits | `ax`, `bx`, `cx`, `dx` |
| DWORD | 32 bits | `eax`, `ebx`, `ecx`, `edx` |
| QWORD | 64 bits | `rax`, `rbx`, `rcx`, `rdx` |

**Exemplo:** `mov DWORD PTR -4[rbp], 5` — escreve 4 bytes (32 bits)

---

## Padrão Prólogo/Epílogo de Função

```asm
função:
    push rbp              ; Salva frame pointer anterior
    mov rbp, rsp          ; Novo frame: rbp = topo da pilha
    sub rsp, N            ; Aloca N bytes para variáveis locais
    
    ; ... corpo da função ...
    
    mov rax, resultado    ; Prepara valor de retorno em eax/rax
    leave                 ; Desfaz frame (mov rsp,rbp; pop rbp)
    ret                   ; Retorna ao chamador
```

---

## Exemplos de Padrões Comuns

### Atribuição com constante
```asm
mov DWORD PTR -4[rbp], 5    ; variável = 5
```

### Loop com contador
```asm
mov eax, 0                  ; contador = 0
.L2:
    cmp eax, 10             ; compara contador com 10
    jge .L3                 ; se >= 10, sai do loop
    add eax, 1              ; contador++
    jmp .L2                 ; volta ao início
.L3:
    ; fim do loop
```

### If-else
```asm
cmp eax, ebx                ; compara eax com ebx
jle .L2                     ; se <=, pula para else
    mov eax, 1              ; então: eax = 1
    jmp .L3                 ; pula o else
.L2:
    mov eax, 0              ; senão: eax = 0
.L3:
    ; continua
```

### Soma de dois valores
```asm
mov eax, DWORD PTR -4[rbp]  ; eax = primeiro valor
mov edx, DWORD PTR -8[rbp]  ; edx = segundo valor
add eax, edx                ; eax = eax + edx
mov DWORD PTR -12[rbp], eax ; resultado = eax
```
