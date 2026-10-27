# Análise Assembly: 03_if.c

## Código C

```c
int maior(int a, int b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}
```

---

## Estrutura do Assembly

O código usa dois rótulos para implementar a lógica if-else:

- `.L2` — bloco else (retorna `b`)
- `.L3` — fim comum (ambos os caminhos convergem)

---

## Fluxo de execução

```
1. Compara a com b
2. Se a <= b, pula para .L2 (else)
3. Senão, executa então (retorna a)
4. Pula para .L3
5. .L2: executa else (retorna b)
6. .L3: retorna o valor em eax
```

---

## Instruções-chave

### `cmp eax, [rbp+24]`
Compara: `eax - memória` (sem armazenar resultado)
- Afeta flags de condição
- Zero flag = 1 se resultado é 0 (a == b)
- Sign flag = 1 se resultado é negativo (a < b)

### `jle .L2`
Jump if Less or Equal
- Salta se o resultado da última operação foi ≤ 0
- Equivalente a: if (a <= b) goto .L2
- Inverte a condição do C: `a > b` se torna `!(a <= b)`

### `jmp .L3`
Jump Incondicional
- Salta sempre para `.L3` (fim da função)
- Evita executar o bloco else

---

## Mapeamento C → Assembly

| C | Assembly |
|---|----------|
| `if (a > b)` | `cmp eax, b; jle .L2` (se NOT a>b, pula) |
| Bloco then | `mov eax, a; jmp .L3` |
| `else` | `.L2:` |
| Bloco else | `mov eax, b` |
| Fim | `.L3: ret` |

---

## Padrão if-else em x86-64

```asm
; if (condição) then_block; else else_block;

    cmp     eax, ebx            ; Testa condição
    j<negação>  .LX             ; Se NOT condição, pula para else
    
    ; then_block
    mov     eax, resultado_1
    jmp     .LY                 ; Pula para fim
    
.LX:
    ; else_block
    mov     eax, resultado_2
    
.LY:
    ; Fim comum
    ret
```

---

## Por que `jle` e não `jg`?

- **`jg` (Jump if Greater)**: salta se a > b (não usado aqui)
- **`jle` (Jump if Less or Equal)**: salta se a ≤ b (usado aqui)

O compilador inverte a condição do C (`a > b`) para `!(a > b)` = `a <= b`, porque é mais eficiente "pular o caso então" do que "pular para o caso else".

---

## Otimização com -O2

Com otimização, o código poderia usar **conditional move** (`cmov`) ao invés de jumps:

```asm
mov eax, [rbp+16]       ; eax = a
mov edx, [rbp+24]       ; edx = b
cmp eax, edx
cmovle eax, edx         ; Se a <= b, eax = b; senão eax permanece = a
ret
```

Isso evita saltos e é mais eficiente (menos penalidade de pipeline).

---

## Pontos importantes

- **CMP não armazena resultado**: apenas afeta flags; compare registradores, não variáveis
- **Inversão de condição**: compilador inverte para aproveitar o padrão mais eficiente
- **Convergência de fluxo**: `.L3` é o ponto onde ambos os caminhos (then e else) convergem
- **CMOV em -O2**: otimizações eliminam jumps em favor de instruções condicionais
