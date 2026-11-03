# Conclusão

Este trabalho percorreu nove construções básicas da linguagem C e observou, no assembly gerado pelo GCC, como cada uma se realiza em instruções de máquina, registradores e acessos à memória. O exercício de comparar C e assembly tornou concretos conceitos que, estudados apenas na teoria, permanecem abstratos.

## O que o trabalho mostrou

Ficou evidente a correspondência direta entre cada construção de alto nível e um padrão de assembly: variáveis locais em deslocamentos de `rbp`; atribuições como `mov`; aritmética em `add`/`sub`/`imul`/`idiv`; decisões como `cmp` seguido de salto condicional; laços como esqueletos de teste + salto; vetores com endereçamento indexado e escala; funções com o protocolo `call`/`ret` e argumentos em registradores; recursão sustentada pela pilha; e ponteiros como endereçamento indireto.

## Principais diferenças observadas

A comparação entre `-O0` e `-O2` foi a mais reveladora. O código não otimizado é literal e verboso, com muitos acessos redundantes à pilha, servindo bem ao propósito didático. O código otimizado exibe técnicas reais de compiladores: *constant folding* (soma vira `mov eax, 8`), *inlining* (chamada some), conversão de recursão em laço, vetorização SSE e código *branchless* com `cmovge`. A contagem de instruções caiu expressivamente na maioria dos exemplos, embora os laços desenrolados lembrem que menos instruções estáticas não é sinônimo de menos trabalho — o que importa é o trabalho dinâmico e o CPI efetivo.

## Limitações

O estudo restringiu-se a dois níveis de otimização (`-O0` e `-O2`) de um único compilador (GCC) em uma única arquitetura efetivamente gerada (x86-64). A comparação com RISC-V foi apenas teórica, pois o compilador cruzado não estava disponível; não há, portanto, contagem real de instruções RISC-V. Os exemplos também são pequenos e isolados, sem interação com entrada/saída, bibliotecas ou grandes volumes de dados.

## Possíveis extensões

Trabalhos futuros poderiam gerar efetivamente o assembly RISC-V para uma comparação quantitativa, incluir outras construções (comando `switch`, `struct`, aritmética de ponto flutuante), medir tempos de execução reais, e explorar níveis intermediários de otimização (`-O1`, `-Os`) ou outras arquiteturas (ARM). Também seria instrutivo analisar o impacto da cache nos exemplos com vetores maiores.
