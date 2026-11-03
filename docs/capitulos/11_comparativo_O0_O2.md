# Análise comparativa: -O0 vs. -O2

## Contagem de instruções

A tabela abaixo (gerada em `docs/metricas.md`) resume o número de instruções por exemplo nos dois níveis de otimização para x86-64, com a coluna RISC-V agora preenchida com dados reais.

| Exemplo | Instruções x86-64 -O0 | Instruções x86-64 -O2 | Instruções RISC-V -O0 |
|---|---|---|---|
| 01_soma | 12 | 2 | 19 |
| 02_aritmetica | 48 | 20 | 79 |
| 03_if | 12 | 4 | 17 |
| 04_for | 16 | 18 | 28 |
| 05_while | 31 | 35 | 42 |
| 06_vetor | 27 | 25 | 44 |
| 07_funcao | 18 | 4 | 25 |
| 08_recursao | 16 | 8 | 24 |
| 09_ponteiro | 22 | 4 | 27 |

## O que a otimização mudou mais

Alguns exemplos mostram com clareza o trabalho do compilador:

**1. Acessos à memória eliminados (`01_soma`, `02_aritmetica`).** Em `-O0`, cada variável vai para a pilha e volta a cada uso; em `-O2`, os valores permanecem em registradores. Em `soma_simples`, o GCC chega a resolver tudo em tempo de compilação (`mov eax, 8`), caindo de 12 para 2 instruções. Em `aritmetica`, os resultados parciais (`s`, `m`, `d`, ...) deixam de ir à pilha e são acumulados em registradores (`r8d`, `r9d`, `r10d`), reduzindo de 48 para 20.

**2. `*2` virando `lea`/`add` (`02_aritmetica` → `dobro`).** A multiplicação por 2 vira `lea eax, [rcx+rcx]`, trocando uma multiplicação por um cálculo de endereço barato. O mesmo padrão aparece no `x << 2` traduzido como `lea`.

**3. Laços simplificados e vetorizados (`04_for`, `06_vetor`).** Em `soma_for`, o `-O2` processa dois valores por iteração com `lea edx, 1[rdx+rax*2]` (*strength reduction* + desenrolamento parcial). Em `soma_vetor`, a otimização é mais profunda: o laço é vetorizado com instruções SSE (`paddd`, `pslld`) que operam sobre quatro inteiros por vez. Note que a contagem **estática** de instruções pode até subir (for: 16 → 18; while: 31 → 35), porque o desenrolamento duplica o corpo; o ganho está nas instruções **executadas** por iteração.

**4. Inline e eliminação de chamadas (`07_funcao`, `08_recursao`, `09_ponteiro`).** Em `chamada`, o `-O2` faz *inlining* de `soma(4,6)` e devolve `10` direto. Em `fatorial`, a recursão vira um laço iterativo (sem `call`), caindo de 16 para 8 instruções e de O(n) para O(1) de pilha. Em `usa_ponteiro`, toda a indireção é resolvida e a função retorna `11`.

## Relação com desempenho e CPI

A contagem estática de instruções não conta a história toda. Conforme a equação de desempenho de Hennessy & Patterson, o tempo de execução depende de três fatores: número de instruções, ciclos por instrução (CPI) e período de clock. A otimização `-O2` atua sobretudo em dois deles:

- **Menos instruções executadas:** *inlining*, *constant folding* e eliminação de recursão reduzem o trabalho dinâmico.
- **Menor CPI efetivo:** manter dados em registradores evita acessos à memória (que custam mais ciclos), e o código *branchless* (`cmovge` no `if`) elimina possíveis penalidades de erro de predição de desvio no pipeline.

Assim, mesmo quando o `-O2` gera mais instruções estáticas (como nos laços desenrolados), o desempenho tende a melhorar porque cada iteração realiza mais trabalho útil com menos acessos caros à memória. Esse é o tema de desempenho e CPI da ementa (III.5).
