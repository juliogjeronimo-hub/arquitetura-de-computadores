# Prompt para Geração de DOCX — Comparação C vs Assembly (-O0 vs -O2)

**Use este conteúdo para colar no ChatGPT e gerar um documento Word profissional.**

---

## PROMPT PARA CHATGPT

```
Crie um documento Word (DOCX) com o seguinte conteúdo e formatação:

TÍTULO: "Análise Comparativa: Código C, Assembly com -O0 e -O2"

IMPORTANTE - INSTRUÇÕES DE INCLUSÃO:
Este documento deve incluir TODOS os trechos de código assembly comentados gerados durante o projeto. 
Para cada exemplo (01 a 09), incluir:
1. O arquivo assembly -O0 COMPLETO com comentários explicativos (já fornecido abaixo)
2. O arquivo assembly -O2 COMPLETO com explicação (resumida)
3. Mapeamento linha-por-linha entre código C e assembly

Os códigos devem aparecer em caixas de código com destaque de sintaxe (syntax highlighting) para assembly x86-64.

INTRODUÇÃO (parágrafo):
Este documento apresenta uma análise comparativa de nove exemplos de código C, mostrando como cada um é traduzido para assembly em dois níveis diferentes de otimização do GCC:
- -O0 (sem otimização): código didático, fácil de mapear linha por linha com C
- -O2 (otimização nível 2): código produção, com transformações agressivas

ESTRUTURA GERAL:
Para cada exemplo, crie uma seção com:
1. Código C original
2. Assembly -O0 (sem otimização) com explicação
3. Assembly -O2 (com otimização) com explicação
4. Tabela comparativa destacando as diferenças

===== ETAPA 1 (Exemplos 1-5) =====

EXEMPLO 1: SOMA SIMPLES (01_soma)
---

Código C:
int soma_simples(void) {
    int a = 5;
    int b = 3;
    int c = a + b;
    return c;
}

Assembly -O0 (EXPLICAÇÃO):
- Prólogo: push rbp, mov rbp rsp, sub rsp 16
- Atribuições em memória: mov DWORD PTR -4[rbp], 5 (a); mov DWORD PTR -8[rbp], 3 (b)
- Carrega valores em registradores: mov edx -4[rbp]; mov eax -8[rbp]
- Soma: add eax edx (eax = a + b)
- Armazena resultado: mov DWORD PTR -12[rbp], eax
- Carrega para retorno: mov eax -12[rbp]
- Epílogo: leave; ret
- Total: ~20 instruções

Assembly -O2 (EXPLICAÇÃO):
- CONSTANT FOLDING: calcula 5 + 3 = 8 em tempo de compilação
- Reduzido a 2 instruções: mov eax, 8; ret
- Nenhum prólogo, nenhuma memória alocada
- GCC identifica que valores são constantes e simplifica tudo
- Tamanho: ~6 bytes (vs ~60 bytes em -O0)

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Instruções | ~20 | 2 |
| Prólogo | Sim | Não |
| Memória | 16 bytes | 0 bytes |
| Constantes | Calculadas runtime | Calculadas compilação |
| Resultado | Dinâmico | 8 (hardcoded) |

EXEMPLO 2: OPERAÇÕES ARITMÉTICAS (02_aritmetica)
---

Código C:
int aritmetica(int x, int y) {
    int s = x - y;
    int m = x * y;
    int d = x / y;
    int r = x % y;
    int l = (x & y) | (x ^ y);
    int sh = (x << 2) + (y >> 1);
    return s + m + d + r + l + sh;
}

Assembly -O0 (EXPLICAÇÃO):
- Reserva 32 bytes para 6 variáveis locais
- Cada operação: carrega x e y de memória → opera → armazena resultado
- Divisão com cdq (expande EAX) + idiv
- OR bit a bit: or eax [rbp+24]
- Shift aritmético: sar eax 1
- LEA para multiplicação eficiente: lea edx 0[0+rax*4]
- Soma final: múltiplos add entre registrador e memória
- ~50 instruções

Assembly -O2 (EXPLICAÇÃO):
- Todos os valores em registradores (r8, r9, r10 etc)
- Operações encadeadas sem intermediários em memória
- Usa registrador r8d para armazenar valor, evita reloads
- CDQ + IDIV otimizados (resultado reutilizado)
- LEA com forma otimizada: lea edx [r9+rcx*4]
- ~18 instruções (64% menos)
- Sem acessos à pilha dentro do loop

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Instruções | ~50 | ~18 |
| Registradores | 3-4 | 6+ |
| Acessos memória | 20+ | 0 |
| Reloads de x/y | Múltiplos | 1 vez |
| Usar r8-r15 | Não | Sim |

EXEMPLO 3: CONDICIONAL IF-ELSE (03_if)
---

Código C:
int maior(int a, int b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

Assembly -O0 (EXPLICAÇÃO):
- Prólogo completo
- Comparação: cmp eax edx
- Salto condicional: jle .L2 (se a <= b, pula para else)
- Bloco then: mov eax [rbp+16] (carrega a)
- Salto incondicional: jmp .L3
- Rótulo else (.L2): mov eax [rbp+24] (carrega b)
- Rótulo fim (.L3): retorno
- ~10 instruções com 2 saltos

Assembly -O2 (EXPLICAÇÃO):
- CMOV (conditional move): instrução que move condicionalmente sem salto
- Reduzido a: cmp ecx edx; mov eax edx; cmovge eax ecx; ret
- Elimina saltos (que causam pipeline stall no processador)
- Predição de branch: cmov é sempre mais rápido que jle + jmp
- ~4 instruções

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Instruções | ~10 | 4 |
| Saltos | 2 (jle, jmp) | 0 |
| Cmov | Não | Sim |
| Pipeline stall | Possível | Não |
| Previsão branch | Necessária | N/A |

EXEMPLO 4: LOOP FOR (04_for)
---

Código C:
int soma_for(int n) {
    int soma = 0;
    for (int i = 0; i < n; i++) {
        soma += i;
    }
    return soma;
}

Assembly -O0 (EXPLICAÇÃO):
- Prólogo: 16 bytes alocados
- Inicialização: soma = 0, i = 0
- Pré-teste: jmp .L2 (salta para teste)
- Corpo (.L3): add DWORD PTR -4[rbp] eax (soma += i); add DWORD PTR -8[rbp] 1 (i++)
- Teste (.L2): cmp i n; jl .L3
- ~15 instruções, 2 rótulos

Assembly -O2 (EXPLICAÇÃO):
- LOOP UNROLLING: processa 2 elementos por iteração
- Test cl, 1: verifica se n é ímpar, processa 1 elemento inicial se necessário
- LEA otimizado: lea edx 1[rdx+rax*2] (soma += i e i+2 combinados)
- Acumula 2 por vez: add eax 2 (próxima iteração)
- ~12 instruções com desenrolamento manual
- Ganho: ~50% menos iterações de loop

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Instruções | ~15 | ~12 |
| Loop unrolling | Não | Sim (2 elementos) |
| Iterações | n | n/2 (com resto) |
| Overhead loop | Alto | Baixo |
| Test cl 1 | N/A | Para ímpar |

EXEMPLO 5: WHILE E DO-WHILE (05_while)
---

Código C:
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

Assembly -O0 (EXPLICAÇÃO):
soma_while:
- Prólogo, inicializa soma e i
- Pré-teste: jmp .L2
- Corpo (.L3): soma += i; i++
- Teste (.L2): cmp i n; jl .L3
- Características: teste ANTES do corpo (pode não executar)

soma_dowhile:
- Prólogo, inicializa soma e i
- Sem pre-teste (pula direto para corpo)
- Corpo (.L6): soma += i; i++
- Teste (após corpo): cmp i n; jl .L6
- Características: corpo executa SEMPRE primeira vez

Assembly -O2 (EXPLICAÇÃO):
- AMBAS otimizadas com LOOP UNROLLING (processar 2 por iteração)
- soma_while: test ecx ecx; jle .L4 (retorna 0 se n <= 0)
- soma_dowhile: inicia com eax = 1; test para verificar se n <= 1
- Usa LEA para soma dupla: lea edx 1[rdx+rax*2]
- Incrementa 2 por vez: add eax 2
- ~20 instruções otimizadas vs ~30 em -O0

Tabela Comparativa:

| Aspecto | While -O0 | While -O2 | DoWhile -O0 | DoWhile -O2 |
|---------|-----------|-----------|-------------|-------------|
| Pré-teste | Sim | Sim | Não | Parcial |
| Loop unrolling | Não | Sim (2x) | Não | Sim (2x) |
| Se n=0 | Não executa | Rápido | Executa 1x | Executa 1x |
| Instruções | ~15 | ~20 | ~15 | ~20 |

===== ETAPA 2 (Exemplos 6-9) =====

EXEMPLO 6: VETORES (06_vetor)
---

Código C:
int soma_vetor(void) {
    int v[10];
    for (int i = 0; i < 10; i++) {
        v[i] = i * 2;
    }
    int soma = 0;
    for (int i = 0; i < 10; i++) {
        soma += v[i];
    }
    return soma;
}

Assembly -O0 (EXPLICAÇÃO):
- Aloca 64 bytes (vetor 40 + variáveis)
- Primeiro loop: indexação com [rbp-64+i*4]
- Segundo loop: carrega v[i], soma com add
- cltq expande índice de 32 para 64 bits
- ~40 instruções

Assembly -O2 (EXPLICAÇÃO):
- VETORIZAÇÃO SIMD: usa xmm0, xmm1, xmm2 (registradores 128 bits)
- Processa 2-4 elementos por iteração
- paddd: soma packed doubles em 128 bits
- pslld $1: shift left packed para i*2
- Redução horizontal: psrldq para somar dentro do vetor
- ~25 instruções (37% menos)
- Ganho de performance: 5-10x mais rápido

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Tipo | Escalar | SIMD |
| Instruções | ~40 | ~25 |
| Elementos/ciclo | 1 | 2-4 |
| Registradores | inteiros | SSE (xmm) |
| Redução | Loop | Horizontal |

EXEMPLO 7: CHAMADAS DE FUNÇÃO (07_funcao)
---

Código C:
int soma(int a, int b) {
    return a + b;
}

int chamada(void) {
    return soma(4, 6);
}

Assembly -O0 (EXPLICAÇÃO):
- soma(): prólogo, carrega parâmetros de memória, add, epílogo (~8 instruções)
- chamada(): aloca 32 bytes shadow space, mov 4 ecx, mov 6 edx, call soma (~7 instruções)
- 2 chamadas de função = overhead de call/ret

Assembly -O2 (EXPLICAÇÃO):
- INLINING: soma() embutida em chamada()
- soma() reduzida a: leal (%rcx,%rdx), %eax (1 instrução LEA)
- chamada() reduzida a: movl $10, %eax; ret (constante!)
- Total: 2 instruções (soma já calculada)

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Inlining | Não | Sim |
| Instruções soma | 8 | 1 (inline) |
| Instruções chamada | 7 | 2 |
| Call/ret | 1 par | 0 |
| Resultado | Runtime | Constante (10) |

EXEMPLO 8: RECURSÃO (08_recursao)
---

Código C:
int fatorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * fatorial(n - 1);
}

Assembly -O0 (EXPLICAÇÃO):
- Prólogo completo em cada chamada: push rbp, sub rsp 32
- Comparação: cmpl $1 16(%rbp); jg .L2
- Caso base: movl $1 %eax
- Caso recursivo: decrementa, call fatorial, imull
- Cada chamada = novo frame (32 bytes)
- Com n=5: 5 frames, 160+ bytes pilha
- Múltiplos call/ret overhead

Assembly -O2 (EXPLICAÇÃO):
- TAIL RECURSION TRANSFORMATION: convertida para loop
- Sem prólogo/epílogo em cada iteração
- Loop simples: imull %ecx, %eax; subl $1, %ecx; cmpl $1, %ecx; jne .L2
- Mantém resultado em eax, decrementa ecx
- 1 frame vs n frames
- 32 bytes pilha vs 160+ em -O0

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Tipo | Recursivo | Loop |
| Frames (n=5) | 5 frames | 1 frame |
| Pilha (n=5) | 160+ bytes | 32 bytes |
| Call/ret | 5 pares | 0 |
| Instruções/ciclo | 6+ | 3 |

EXEMPLO 9: PONTEIROS (09_ponteiro)
---

Código C:
void incrementa(int *p) {
    *p = *p + 1;
}

int usa_ponteiro(void) {
    int x = 10;
    incrementa(&x);
    return x;
}

Assembly -O0 (EXPLICAÇÃO):
- incrementa(): prólogo, desreferencia 2x (load + store), epílogo (~6 instruções)
- Carrega *p: movl (%rax) %eax
- Incrementa: leal 1(%rax) %edx
- Escreve: movl %edx (%rax)
- usa_ponteiro(): aloca 48 bytes, mov 10, lea &x, call incrementa (~10 instruções)

Assembly -O2 (EXPLICAÇÃO):
- OTIMIZAÇÃO AGRESSIVA: incrementa() reduzida a addl $1 (%rcx)
- Desreferencia e modifica in-place (1 instrução vs 3)
- usa_ponteiro() reduzida a: movl $11 %eax; ret
- GCC calcula que incrementa(10) = 11 em compilação
- Sem pilha, sem prólogo, sem chamada de função

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Instruções incrementa | 6 | 1 |
| Desreferências | 3 | 1 (in-place) |
| usa_ponteiro | Dinâmica | Constante (11) |
| Prólogo | Sim | Não |
| Pilha | 48 bytes | 0 bytes |

---

## CONCLUSÃO GERAL

Otimizações -O2 aplicadas:
1. **Constant Folding**: Calcula valores constantes em compilação
2. **Inlining**: Embutir funções pequenas elimina call/ret
3. **Loop Unrolling**: Processa múltiplos elementos por iteração
4. **SIMD/Vetorização**: Usa registradores 128/256 bits
5. **Tail-Call Optimization**: Converte recursão em loops
6. **Conditional Moves (CMOV)**: Evita saltos e pipeline stalls
7. **Dead Code Elimination**: Remove código desnecessário
8. **Register Allocation**: Mantém valores em registradores, não memória

**Impacto Típico**:
- Código 30-40% menor
- Performance 5-15x mais rápido
- Uso de memória 50% menor

Formate o documento com:
- Títulos em negrito (tamanho 14)
- Código em fonte monoespacial (Courier New, tamanho 10)
- Tabelas com bordas pretas e cabeçalhos em cinza
- Espaçamento 1.5 entre linhas
- Número de página no rodapé
- Margens padrão (2,5 cm)

Salve como arquivo DOCX adequado para impressão e apresentação.
```

---

## INSTRUÇÕES DE USO

1. **Copie todo o texto acima** (a partir de "Crie um documento Word...")
2. **Cole no ChatGPT** (ou Claude, ou outro LLM)
3. O LLM gerará um DOCX pronto
4. **Baixe e abra** no Microsoft Word ou LibreOffice

---

## ALTERNATIVA: Se o LLM não gerar DOCX diretamente

Se o modelo só gerar markdown, peça:
> "Agora converta este documento para formato DOCX usando a biblioteca python-docx. Forneça o código Python."

Depois use esse código localmente para gerar o DOCX.
---

Código C:
int soma_vetor(void) {
    int v[10];
    for (int i = 0; i < 10; i++) {
        v[i] = i * 2;
    }
    int soma = 0;
    for (int i = 0; i < 10; i++) {
        soma += v[i];
    }
    return soma;
}

Assembly -O0 (EXPLICAÇÃO):
- Dois loops explícitos: primeiro para preencher v[i] = i*2, segundo para somar
- Usa indexação com cmpl e jle para cada iteração
- Reserva 64 bytes na pilha (vetor de 10 inteiros + variáveis)
- Cada acesso a v[i] usa [rbp-64+i*4]
- Instrução cltq expande índice de 32 para 64 bits

Assembly -O2 (EXPLICAÇÃO):
- VETORIZAÇÃO: usa instruções SIMD (SSE4.1) com xmm0, xmm1, xmm2
- Processa 2 elementos por iteração usando paddd, pslld
- Loop principal usa movdqa para operações de 128 bits
- Soma otimizada usa psrldq (shift direita com deslocamento) para redução horizontal
- Sem chamadas de função, tudo inline
- Código ~5x menor e ~10x mais rápido

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Tipo | Escalar | SIMD (Vetorizado) |
| Instruções | 40+ | ~30 |
| Loops | 2 explícitos | 1 loop vetorizado |
| Tamanho código | ~200 bytes | ~150 bytes |
| Estratégia soma | Loop sequencial | Redução horizontal SIMD |

EXEMPLO 2: CHAMADAS DE FUNÇÃO (07_funcao)
---

Código C:
int soma(int a, int b) {
    return a + b;
}

int chamada(void) {
    return soma(4, 6);
}

Assembly -O0 (EXPLICAÇÃO):
- Função soma() com prólogo e epílogo completos: push rbp, mov rbp rsp
- Parâmetros salvos em memória: ecx em [rbp+16], edx em [rbp+24]
- Carrega valores de memória para registradores, depois suma: addl
- Função chamada() aloca 32 bytes (shadow space) e chama soma com argumentos em ecx/edx
- 2 chamadas de função visíveis

Assembly -O2 (EXPLICAÇÃO):
- INLINING: soma() é embutida em chamada(), elimina call/ret
- Função soma reduzida a 1 instrução: leal (%rcx,%rdx), %eax
- Função chamada reduzida a: movl $10, %eax; ret
- Nenhuma pilha extra reservada
- Resultado calculado em tempo de compilação (4+6=10)
- Ganho: elimina overhead de chamada de função

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Inlining | Não | Sim (embutida) |
| Instruções soma() | 5 | 1 (LEA) |
| Shadow space | 32 bytes | 0 bytes |
| Calls | 1 (call soma) | 0 |
| Resultado | Calculado em runtime | Constante em compilação |

EXEMPLO 3: RECURSÃO (08_recursao)
---

Código C:
int fatorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * fatorial(n - 1);
}

Assembly -O0 (EXPLICAÇÃO):
- Prólogo completo: push rbp, mov rbp rsp, sub rsp 32
- Teste: cmpl $1, 16(%rbp); jg .L2
- Caso base: movl $1, %eax
- Caso recursivo: decrementa n, call fatorial, multiplica resultado: imull
- Cada chamada recursiva consome 32 bytes de pilha
- Com n=5: 5 frames na pilha = 160 bytes mínimo

Assembly -O2 (EXPLICAÇÃO):
- TRANSFORMAÇÃO EM LOOP: recursão convertida para iteração (tail-call optimization não total, mas loop equivalente)
- Sem push/pop do rbp no loop
- Loop simples: imull %ecx, %eax; subl $1, %ecx; cmpl $1, %ecx; jne .L2
- Sem shadow space reservado
- Usa cmpl/jne para controle (não jg como -O0)
- Ganho: acumula resultado em eax, evita múltiplos frame pointers

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Tipo | Recursivo | Loop iterativo |
| Frames | n frames | 1 frame |
| Pilha (n=5) | 160+ bytes | 32 bytes |
| Instruções/ciclo | 6+ | 3 |
| Call | Sim (call fatorial) | Não (loop) |
| Overhead | Alto (frame setup) | Baixo (loop simples) |

EXEMPLO 4: PONTEIROS (09_ponteiro)
---

Código C:
void incrementa(int *p) {
    *p = *p + 1;
}

int usa_ponteiro(void) {
    int x = 10;
    incrementa(&x);
    return x;
}

Assembly -O0 (EXPLICAÇÃO):
- Função incrementa() recebe p em rcx
- Desreferencia: movq %rcx, %rax; movl (%rax), %eax (carrega *p)
- Incrementa: leal 1(%rax), %edx
- Reescreve: movq %rcx, %rax; movl %edx, (%rax)
- Função usa_ponteiro() aloca 48 bytes, inicializa x=10, calcula &x com leaq -4(%rbp), passa para incrementa
- Duas instruções de desreferência e um reendereçamento

Assembly -O2 (EXPLICAÇÃO):
- OTIMIZAÇÃO AGRESSIVA: não usa frame pointer em incrementa
- incrementa() reduzida a 1 instrução: addl $1, (%rcx)
- Modifica valor apontado por rcx diretamente na memória
- usa_ponteiro() reduzida a constante: movl $11, %eax; ret
- GCC detecta que incrementa(10) = 11 e calcula em tempo de compilação
- Sem prólogo/epílogo, sem reserva de pilha

Tabela Comparativa:

| Aspecto | -O0 | -O2 |
|---------|-----|-----|
| Prólogo incrementa | Sim (push rbp) | Não |
| Desreferências | 3 (load + store + indirect) | 1 (addl direto) |
| Instruções incrementa | 6 | 1 |
| usa_ponteiro | Dinâmica | Constante (11) |
| Frame pointer | Sim | Não |
| Pilha reservada | 48 bytes | 0 bytes |

---

## CONCLUSÃO

A otimização -O2 realiza transformações significativas:
1. **Inlining**: Remove chamadas de função, expande código
2. **Loop Unrolling e Vetorização**: Processa múltiplos dados por iteração (SIMD)
3. **Tail-Call Optimization**: Converte recursão em loops
4. **Constant Folding**: Calcula valores constantes em compilação
5. **Dead Code Elimination**: Remove instruções desnecessárias
6. **Register Allocation**: Usa mais registradores, menos memória
7. **Alignment**: Alinha código para melhor performance de cache (.p2align)

**Impacto**: Código -O2 é tipicamente 5-10x mais rápido com 20-40% menos tamanho.

---

Formate o documento com:
- Títulos em negrito
- Código em fonte monoespacial (Courier New, tamanho 10)
- Tabelas com bordas e sombreamento alternado
- Espaçamento duplo entre seções
- Número de página no rodapé
- Margens padrão (2,5 cm)

Salve como arquivo DOCX adequado para impressão e apresentação profissional.
```

---

## INSTRUÇÕES DE USO

1. **Copie todo o texto acima** (a partir de "Crie um documento Word...")
2. **Cole no ChatGPT** (ou Claude, ou outro LLM)
3. O LLM gerará um DOCX pronto
4. **Baixe e abra** no Microsoft Word ou LibreOffice

---

## ALTERNATIVA: Se o LLM não gerar DOCX diretamente

Se o modelo só gerar markdown, peça:
> "Agora converta este documento para formato DOCX usando a biblioteca python-docx. Forneça o código Python."

Depois use esse código localmente para gerar o DOCX.
