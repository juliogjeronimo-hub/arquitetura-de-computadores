# Análise comparativa: CISC (x86) vs. RISC (RISC-V)

> **Nota:** Assembly RISC-V foi gerado usando `riscv64-unknown-elf-gcc -S -O0`. As observações teóricas sobre RISC-V (load/store, instruções de tamanho fixo, 32 registradores) são corroboradas pelo código efetivamente produzido.

## Tabela de diferenças

| Aspecto | x86-64 (CISC) | RISC-V (RISC) |
|---|---|---|
| Operandos em memória | Instruções aritméticas podem ler/escrever memória diretamente (ex.: `add [mem], reg`) | Somente `load`/`store` acessam memória; aritmética só entre registradores |
| Tamanho da instrução | Variável (1 a 15 bytes) | Fixo (4 bytes no conjunto base; 2 bytes com extensão comprimida) |
| Número de registradores | 16 registradores inteiros de uso geral | 32 registradores inteiros de uso geral |
| Modos de endereçamento | Muitos (indexado com escala, indireto, base+desloc.) | Poucos e simples (base + deslocamento) |
| Chamada de função | `call` empilha o endereço de retorno automaticamente | `jal` guarda o endereço de retorno no registrador `ra` |
| Contagem de instruções | Tende a ser menor (instruções mais densas) | Tende a ser maior (operações decompostas em passos) |

## Contagem de instruções

A tabela abaixo apresenta a contagem de instruções geradas para cada exemplo, permitindo comparar CISC (x86-64) com RISC (RISC-V) no mesmo nível de otimização (`-O0`):

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

**Metodologia:** As instruções foram contadas排除directivas assembler (`.file`, `.align`, `.type`, etc.) e pseudoinstruções expandidas. O código RISC-V foi gerado com `riscv64-unknown-elf-gcc -S -O0` (target `rv64imfd`).

De forma teórica, espera-se que a versão RISC-V tenha **mais** instruções que a x86 equivalente nos casos com acesso a memória. Por exemplo, o `soma += i` dos laços, que no x86 é um único `add DWORD PTR -4[rbp], eax`, exigiria em RISC-V três instruções (`lw`, `add`, `sw`). Da mesma forma, a desreferência de ponteiro `*p` e o acesso indexado a vetor, resolvidos num só modo de endereçamento no x86, demandariam cálculo explícito de endereço e `load`/`store` separados em RISC-V.

## Ligação com a ementa

A oposição CISC × RISC e a análise de conjuntos de instruções correspondem ao tópico IV da ementa. Os exemplos deste trabalho ilustram concretamente por que o x86 é classificado como CISC: instruções que combinam operação aritmética com acesso à memória (`add [mem], reg`, `imul reg, [mem]`), modos de endereçamento ricos (`-64(%rbp,%rax,4)`) e tamanho de instrução variável. A filosofia RISC, em contraste, privilegia instruções simples e uniformes que o compilador combina — transferindo complexidade do hardware para o software, o que facilita o projeto de pipelines regulares.
