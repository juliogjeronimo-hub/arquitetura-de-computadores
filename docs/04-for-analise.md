# Análise Assembly: 04_for.c

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

---

## Estrutura do Loop

```
1. Inicializa: soma = 0, i = 0
2. Pula para teste (.L2)
3. Se i < n, executa corpo (.L3)
4. Volta ao teste (.L2)
5. Se i >= n, sai do loop
6. Retorna soma
```

---

## Instruções-chave

### `jmp .L2`
Jump incondicional para o teste
- Garante que o teste sempre ocorre ANTES de entrar no loop
- Característica de `for`: validação antes de execução

### `.L3` — Corpo do loop

```asm
.L3:
    mov eax, DWORD PTR -8[rbp]      ; eax = i
    add DWORD PTR -4[rbp], eax      ; soma += i
    add DWORD PTR -8[rbp], 1        ; i++
```

- `add DWORD PTR -4[rbp], eax` — incrementa variável na memória somando eax a ela
- `add DWORD PTR -8[rbp], 1` — incrementa i de 1

### `.L2` — Teste de condição

```asm
.L2:
    mov eax, DWORD PTR -8[rbp]      ; eax = i
    cmp eax, DWORD PTR 16[rbp]      ; Compara i com n
    jl .L3                          ; Se i < n, volta ao corpo
```

- `cmp` compara i com n (eax - n)
- `jl` (Jump if Less) salta se i < n
- Se não salta, continua após jl (fim do loop)

---

## Mapeamento C → Assembly

| C | Assembly |
|---|----------|
| `soma = 0` | `mov DWORD PTR -4[rbp], 0` |
| `i = 0` | `mov DWORD PTR -8[rbp], 0` |
| `for (...` | (sem código) |
| Pula para teste | `jmp .L2` |
| Corpo: `soma += i` | `mov eax, i; add soma, eax` |
| Incremento: `i++` | `add i, 1` |
| Teste: `i < n` | `cmp eax, n; jl .L3` |

---

## Ciclo de Execução

### Primeira iteração (n > 0)
```
1. soma = 0
2. i = 0
3. jmp .L2
4. cmp 0, n
5. jl .L3 (salta para .L3, pois 0 < n)
6. soma += 0
7. i = 1
8. jmp .L2 (volta ao teste — isso é feito implicitamente pelo jl acima)
```

Não, na verdade o fluxo é:

```
1. Inicializa
2. jmp .L2 (pula para teste)
3. .L2: cmp i, n; jl .L3
4. .L3: (corpo do loop)
5. Volta implicitamente ao .L2 (sim, após .L3, continua até .L2 novamente)
```

Wait, o assembly não tem loop explícito de volta. Deixe-me revisar o fluxo correto:

Após `add DWORD PTR -8[rbp], 1` (i++), a próxima instrução é `.L2` no próprio assembly. Não há `jmp` de volta explícito. O fluxo natural (sem salto) leva ao `.L2` seguinte.

---

## Layout de variáveis na pilha

```
[rbp+16]    = n (parâmetro)
[rbp-4]     = soma (acumulador)
[rbp-8]     = i (contador do loop)
```

---

## Padrão for em x86-64

```asm
inicializa_contador
jmp teste                   ; Pula para teste (do-while falso)

corpo:
    ; corpo do loop
    incrementa_contador

teste:
    compara_contador_com_limite
    jump_se_condicao_verdadeira corpo   ; Se condição, volta ao corpo

; Após sair do loop
```

---

## For vs While em Assembly

Para este exemplo específico, o assembly do `for` é **idêntico** ao do `while`:

- **For**: inicializa → teste → corpo → incremento → teste
- **While**: inicializa → teste → corpo → (sem incremento explícito)

A diferença é apenas de semântica do C. Em assembly, ambos geram:
```
jmp teste
corpo:
    ...
teste:
    cmp; jl corpo
```

---

## Otimizações com -O2

Com otimização, o código seria transformado:

1. **Variáveis em registradores**: `i` e `soma` em registradores, não memória
2. **Loop unrolling**: múltiplas iterações por ciclo
3. **Vetorização**: SIMD para adicionar múltiplos valores ao mesmo tempo

Exemplo simplificado com -O2:
```asm
xor eax, eax            ; eax = soma = 0
xor ecx, ecx            ; ecx = i = 0
jmp .L2

.L3:
    add eax, ecx        ; soma += i (diretamente em registrador)
    inc ecx              ; i++

.L2:
    cmp ecx, DWORD PTR [rbp+16]  ; i < n?
    jl .L3
```

---

## Pontos importantes

- **`jmp` para teste**: garante que o teste ocorre antes da primeira iteração
- **`add DWORD PTR` para memória**: incrementa variável local (menos eficiente que registrador)
- **Sem `loop` x86**: o GCC não usa a instrução `loop` (lenta), prefere `cmp + jl`
- **Fluxo linear**: após i++, a próxima instrução é .L2 naturalmente
