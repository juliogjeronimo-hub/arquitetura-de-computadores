# Análise Assembly: 02_aritmetica.c

## Código C

```c
int aritmetica(int x, int y) {
    int s = x - y;
    int m = x * y;
    int d = x / y;
    int r = x % y;
    int l = (x & y) | (x ^ y);
    int sh = (x << 2) + (y >> 1);
    return s + m + d + r + l + sh;
}

int dobro(int x) {
    return x * 2;
}
```

---

## Função `aritmetica(int x, int y)`

### Operações executadas

| Operação | Instrução | Resultado |
|----------|-----------|-----------|
| Subtração | `sub eax, [rbp+24]` | `s = x - y` |
| Multiplicação | `imul eax, [rbp+24]` | `m = x * y` |
| Divisão | `cdq; idiv [rbp+24]` | `d = x / y` (quociente em eax) |
| Resto | `cdq; idiv [rbp+24]` | `r = x % y` (resto em edx) |
| OR bit a bit | `or eax, [rbp+24]` | `l = x \| y` |
| Shift + Add | `lea edx, 0[0+rax*4]` + `sar eax` | `sh = (x << 2) + (y >> 1)` |
| Soma final | Múltiplos `add` | Soma de s+m+d+r+l+sh |

### Instruções-chave

**`sub eax, edx`** — Subtração: `eax = eax - edx`
- Afeta flags de condição
- Resultado armazenado em eax

**`imul eax, [rbp+24]`** — Multiplicação com sinal: `eax = eax * memória`
- `imul` (signed multiply) mantém sinal dos operandos
- Se resultado > 32 bits, vai para EDX

**`cdq`** — Converte Doubleword to Quadword
- Expande EAX (32 bits) em EDX:EAX (64 bits)
- EDX recebe o bit de sinal (extensão com sinal)
- Obrigatório antes de `idiv` para preparar o dividendo

**`idiv [rbp+24]`** — Divisão com sinal: `edx:eax ÷ memória`
- Quociente (resultado da divisão) → `eax`
- Resto (módulo) → `edx`
- Muda os registradores automáticamente

**`lea edx, 0[0+rax*4]`** — Load Effective Address (otimização de shift)
- Calcula endereço: `0 + rax*4 = rax * 4`
- Equivalente a `shl rax, 2`, mas mais eficiente (sem modificar flags)
- Resultado em `edx`

**`sar eax`** — Shift Aritmético à Direita
- Desloca bits para a direita
- Preenche com bit de sinal (preserva negativos)
- Sem argumento = 1 posição: `eax = eax >> 1`

**`or eax, [rbp+24]`** — OR bit a bit: `eax = eax | memória`
- Combina bits: 0|0=0, 0|1=1, 1|0=1, 1|1=1

### Layout de variáveis na pilha

```
[rbp+24]    = y (parâmetro)
[rbp+16]    = x (parâmetro)
[rbp-4]     = s (x - y)
[rbp-8]     = m (x * y)
[rbp-12]    = d (x / y, quociente)
[rbp-16]    = r (x % y, resto)
[rbp-20]    = l (x | y)
[rbp-24]    = sh ((x << 2) + (y >> 1))
```

---

## Função `dobro(int x)`

### Código C
```c
return x * 2;
```

### Instrução-chave

**`add eax, eax`** — Dobro: `eax = eax + eax`
- Equivalente a `eax * 2`
- Mais rápido que `imul eax, 2`
- Afeta flags

### Por que `add` em vez de `imul`?

Com `-O0` (sem otimização), o compilador traduz multiplicação por 2 literalmente. Com otimizações (`-O2`), o GCC detecta que multiplicar por potência de 2 é apenas um shift, e usa `shl eax, 1` ou neste caso `add eax, eax` (igualmente eficiente, com efeito colateral de atualizar flags).

---

## Diferenças com -O2

Com otimização nível 2 (`-O2`), o código seria drasticamente diferente:

1. **Uso de registradores ao invés de memória** — variáveis locais ficariam em registradores
2. **Eliminação de instruções redundantes** — muitos `mov` seriam removidos
3. **Reordenação de operações** — para melhor aproveitamento de paralelismo
4. **Multiplicação por constante** — convertida a shifts e adds
5. **Inlining** — `dobro()` provavelmente seria expandida inline

Exemplo: `dobro()` em `-O2` seria simplesmente:
```asm
dobro:
    shl ecx, 1      ; ecx * 2
    mov eax, ecx
    ret
```

---

## Pontos importantes

- **CDQ + IDIV**: padrão obrigatório para divisão com sinal. CDQ prepara o dividendo, IDIV executa divisão completa.
- **LEA**: instrução muito versátil em x86-64, usada não apenas para endereços mas para cálculos aritméticos eficientes.
- **SAR vs SHR**: SAR (aritmético) preserva sinal (importantes para negativos), SHR (lógico) preenche com zeros.
- **Acumulação em EDX**: a sequência de muitos `add` usa EDX como acumulador temporário para eficiência.
