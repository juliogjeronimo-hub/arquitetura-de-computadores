# Análise Assembly: 05_while.c

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

---

## Função `soma_while`

### Estrutura do loop while

```
1. Inicializa: soma = 0, i = 0
2. Pula para teste (.L2)
3. Se i < n, executa corpo (.L3)
4. Volta ao teste (.L2)
5. Se i >= n, sai do loop
6. Retorna soma
```

A estrutura é **idêntica** ao `for` porque o `for` sem inicialização de loop se comporta como `while`.

### Instruções

```asm
; Inicialização
mov DWORD PTR -4[rbp], 0        ; soma = 0
mov DWORD PTR -8[rbp], 0        ; i = 0

jmp .L2                         ; Pula para teste

.L3:                            ; Corpo (só se i < n)
    mov eax, DWORD PTR -8[rbp]  ; eax = i
    add DWORD PTR -4[rbp], eax  ; soma += i
    add DWORD PTR -8[rbp], 1    ; i++

.L2:                            ; Teste da condição
    mov eax, DWORD PTR -8[rbp]  ; eax = i
    cmp eax, DWORD PTR 16[rbp]  ; Compara i com n
    jl .L3                      ; Se i < n, salta para corpo

; Fim do loop, continua após jl
mov eax, DWORD PTR -4[rbp]      ; eax = soma (retorno)
```

### Padrão while em x86-64

```asm
inicializa
jmp teste           ; Teste antes de executar (importante!)

corpo:
    ; corpo do loop

teste:
    condicao_verdadeira? 
    jmp_verdadeiro corpo
```

O `jmp` inicial garante que o teste ocorre **antes** de entrar no loop.

---

## Função `soma_dowhile`

### Diferença: teste **após** execução

```
1. Inicializa: soma = 0, i = 0
2. Executa corpo (.L6) SEMPRE (sem pré-teste)
3. Testa condição
4. Se i < n, volta ao corpo
5. Se i >= n, sai
6. Retorna soma
```

### Instruções

```asm
; Inicialização
mov DWORD PTR -4[rbp], 0        ; soma = 0
mov DWORD PTR -8[rbp], 0        ; i = 0

.L6:                            ; Corpo (executa SEMPRE primeira vez)
    mov eax, DWORD PTR -8[rbp]  ; eax = i
    add DWORD PTR -4[rbp], eax  ; soma += i
    add DWORD PTR -8[rbp], 1    ; i++

; Teste (após execução do corpo)
mov eax, DWORD PTR -8[rbp]      ; eax = i
cmp eax, DWORD PTR 16[rbp]      ; Compara i com n
jl .L6                          ; Se i < n, volta para corpo

; Fim do loop
mov eax, DWORD PTR -4[rbp]      ; eax = soma (retorno)
```

### Padrão do-while em x86-64

```asm
inicializa

corpo:
    ; corpo (executa sempre)

teste:
    condicao_verdadeira?
    jmp_verdadeiro corpo
```

**Sem `jmp` inicial**: o corpo executa ao menos uma vez, garantido.

---

## Comparação: While vs Do-While

| Aspecto | While | Do-While |
|---------|-------|----------|
| **Teste inicial** | `jmp .L2` | Nenhum (corpo executa logo) |
| **Primeira execução** | Só se i < n | Sempre |
| **Rótulo do corpo** | `.L3` | `.L6` |
| **Se n = 0** | Nunca executa (soma = 0) | Executa uma vez (soma = 0) |

---

## Comportamento com n = 0

### while (i < n):
```
i = 0, n = 0
jmp .L2
.L2: cmp 0, 0 → ZF = 1 (iguais)
     jl .L3 → NÃO salta (pois 0 >= 0, não <)
Resultado: soma = 0 (nunca entra no corpo)
```

### do-while (i < n):
```
i = 0, n = 0
.L6: soma += 0 → soma = 0
     i = 1
.L2: cmp 1, 0 → i > n
     jl .L6 → NÃO salta (1 não é < 0)
Resultado: soma = 0 (entra uma vez)
```

---

## Layout de variáveis na pilha

```
[rbp+16]    = n (parâmetro)
[rbp-4]     = soma (acumulador)
[rbp-8]     = i (contador)
```

Idêntico para `soma_while` e `soma_dowhile`.

---

## Pontos importantes

- **While vs For vs Do-While**: diferem na semântica, não na eficiência em assembly
- **`jmp` para teste**: característica de while—sempre testa antes
- **Sem `jmp` em do-while**: corpo é garantido executar uma vez
- **Condição invertida**: `while (i < n)` se torna `cmp; jl` (salta se true)
- **Com n=0**: while e for não executam corpo, do-while executa uma vez
