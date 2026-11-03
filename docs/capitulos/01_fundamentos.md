# Fundamentos de arquitetura x86-64

Antes de analisar os exemplos, convém fixar os elementos de arquitetura que aparecem repetidamente no assembly gerado. Os conceitos seguem a apresentação de Hennessy & Patterson sobre organização de processadores.

## Registradores usados

O x86-64 possui registradores de 64 bits cujos 32 bits inferiores têm nomes próprios. Nos exemplos aparecem principalmente:

| Registrador (64 bits) | Parte de 32 bits | Papel típico nos exemplos |
|---|---|---|
| `rax` | `eax` | Acumulador; carrega o valor de retorno da função |
| `rbp` | — | *Base pointer*: aponta para a base do *stack frame* |
| `rsp` | — | *Stack pointer*: aponta para o topo da pilha |
| `rcx` | `ecx` | 1º parâmetro inteiro (convenção do ambiente Windows/MSYS2) |
| `rdx` | `edx` | 2º parâmetro inteiro |
| `r8d`, `r9d`, `r10d` | — | Registradores adicionais usados em código otimizado |

Observa-se que o mesmo registrador físico é referido por `rax` (64 bits) ou `eax` (32 bits) conforme o tamanho do dado. Como os exemplos operam com `int` (32 bits), predomina a forma `eax`/`edx`/`ecx`.

## Pilha e *stack frame*

Cada função que precisa de espaço local monta um *stack frame*. O padrão no código `-O0` é:

```nasm
push	rbp            ; salva o base pointer anterior
mov	rbp, rsp       ; novo base pointer = topo atual
sub	rsp, N         ; reserva N bytes para variáveis locais
; ... corpo ...
leave              ; desfaz o frame (mov rsp,rbp ; pop rbp)
ret
```

O `rbp` serve de referência fixa: variáveis locais são acessadas como deslocamentos negativos (`-4[rbp]`, `-8[rbp]`), e os parâmetros salvos, como deslocamentos positivos (`16[rbp]`, `24[rbp]`). Essa é a noção de endereço relativo à base do quadro, central no capítulo sobre memória e pilha do livro-base.

## Convenção de chamada

Nos arquivos gerados neste ambiente (Windows/MSYS2), os dois primeiros parâmetros inteiros chegam em `ecx` e `edx`, e o valor de retorno sai em `eax`. No prólogo `-O0`, a função frequentemente copia esses parâmetros para a pilha antes de usá-los:

```nasm
mov	DWORD PTR 16[rbp], ecx   ; 1º parâmetro salvo no frame
mov	DWORD PTR 24[rbp], edx   ; 2º parâmetro salvo no frame
```

Em alguns arquivos a convenção System V aparece na forma AT&T (`movl %ecx, 16(%rbp)`), com `%` nos registradores e sufixo de tamanho (`l` = 32 bits, `q` = 64 bits). O sentido é o mesmo: o parâmetro em `ecx` é gravado no *stack frame*.

## Formato `mov destino, origem` (Intel)

A sintaxe Intel escreve o destino à esquerda e a origem à direita: `mov eax, edx` significa "eax recebe edx". Os operandos de memória usam colchetes: `DWORD PTR 16[rbp]` é a palavra dupla (32 bits) no endereço `rbp+16`. Já a sintaxe AT&T inverte a ordem (`movl %edx, %eax` copia `edx` para `eax`) e usa parênteses para memória (`16(%rbp)`). Ambas as formas aparecem nos arquivos deste trabalho e são citadas como estão.

## Flags e saltos

Instruções de comparação (`cmp`, `test`) atualizam as *flags* de condição do processador. Em seguida, um salto condicional consulta essas flags:

- `jl` / `jle`: salta se menor / menor ou igual (comparação com sinal);
- `jg`: salta se maior;
- `jne` / `je`: salta se diferente / igual;
- `jmp`: salto incondicional.

Esse par comparação + salto é a base da tradução de `if`, `for` e `while`, e é onde surgem as dependências de controle discutidas no capítulo de pipeline.

## Noção de ciclo de instrução

Cada instrução passa, conceitualmente, pelas etapas de busca, decodificação, execução e, quando há acesso à memória, leitura/escrita de operandos. No código `-O0`, o grande número de `mov` entre registrador e pilha reflete muitos acessos à memória por operação; no `-O2`, boa parte desses acessos some porque o compilador mantém os valores em registradores. Essa diferença de contagem e de tipo de instrução é o que conecta os exemplos ao desempenho (CPI e número de instruções) tratado no livro-base.
