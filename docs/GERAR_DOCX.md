# Como gerar o documento final (.docx)

## 1. Estrutura do documento

| Ordem | Seção | Fonte |
|---|---|---|
| 0 | Capa e dados | `docs/capa_e_dados.md` |
| 1 | Sumário (automático) | gerado pelo Word/pandoc |
| 2 | 1. Introdução | `docs/capitulos/00_introducao.md` |
| 3 | 2. Fundamentos | `docs/capitulos/01_fundamentos.md` |
| 4 | 3. Exemplos práticos (3.1 a 3.9) | `docs/capitulos/02_` a `10_` |
| 5 | 4. Análise `-O0` vs. `-O2` | `docs/capitulos/11_comparativo_O0_O2.md` |
| 6 | 5. Análise CISC vs. RISC | `docs/capitulos/12_comparativo_cisc_risc.md` |
| 7 | 6. Ligação com pipeline | `docs/capitulos/13_pipeline.md` |
| 8 | 7. Conclusão | `docs/capitulos/14_conclusao.md` |
| 9 | Referências | `docs/capitulos/15_referencias.md` |

Observação: os capítulos de exemplo usam `# Exemplo N` como título. Ao montar, rebaixar um nível (`--shift-heading-level-by=1`) para que fiquem como subseções de "3. Exemplos práticos".

## 2. Formatação desejada

- Página A4; margens: superior 3 cm, esquerda 3 cm, inferior 2 cm, direita 2 cm.
- Texto: Arial ou Times New Roman 12 pt, espaçamento 1,5, justificado.
- Títulos numerados, com hierarquia clara (Título 1 em negrito).
- Blocos de código: fonte monoespaçada (Consolas ou Courier New) 9 a 10 pt, espaçamento simples, fundo cinza claro.
- Tabelas: cabeçalho em negrito com sombreamento, bordas finas, texto 10 pt.
- Numeração de página no rodapé; capa sem número.
- Sumário automático até o nível 2.

## 3. Geração com pandoc (recomendado)

Pré-requisito: [pandoc](https://pandoc.org) instalado.

```bash
# 3.1 Criar o modelo de estilos (uma vez) e ajustar no Word conforme a seção 2
pandoc -o docs/modelo.docx --print-default-data-file reference.docx

# 3.2 Montar o documento
pandoc docs/capa_e_dados.md \
       docs/capitulos/00_introducao.md \
       docs/capitulos/01_fundamentos.md \
       docs/capitulos/02_ex01_soma.md \
       docs/capitulos/03_ex02_aritmetica.md \
       docs/capitulos/04_ex03_if.md \
       docs/capitulos/05_ex04_for.md \
       docs/capitulos/06_ex05_while.md \
       docs/capitulos/07_ex06_vetor.md \
       docs/capitulos/08_ex07_funcao.md \
       docs/capitulos/09_ex08_recursao.md \
       docs/capitulos/10_ex09_ponteiro.md \
       docs/capitulos/11_comparativo_O0_O2.md \
       docs/capitulos/12_comparativo_cisc_risc.md \
       docs/capitulos/13_pipeline.md \
       docs/capitulos/14_conclusao.md \
       docs/capitulos/15_referencias.md \
       -o Trabalho_Final.docx \
       --reference-doc=docs/modelo.docx \
       --toc --toc-depth=2 \
       --highlight-style=tango
```

Cuidados:
- Pandoc não numera os títulos automaticamente com `--reference-doc`; se quiser numeração, adicione `--number-sections` (e remova números manuais dos títulos).
- Para rebaixar títulos dos exemplos, gere os exemplos em uma chamada separada com `--shift-heading-level-by=1` ou ajuste os títulos nos `.md`.
- Após gerar, abra no Word e atualize o sumário (clique direito, "Atualizar campo").

## 4. Alternativa sem pandoc

Enviar os arquivos de `docs/capitulos/`, `docs/metricas.md` e `docs/capa_e_dados.md` a um assistente (Claude) com o pedido: "Monte o .docx final seguindo docs/GERAR_DOCX.md".

## 5. Checklist de revisão antes da entrega

- [ ] Dados da capa preenchidos (nome, data)
- [ ] Todo assembly citado confere com os `.s` em `build/`
- [ ] Tabelas de métricas coladas e legíveis
- [ ] Comparação RISC-V real ou nota teórica explícita
- [ ] Referências completas e sem citações inventadas
- [ ] Sumário atualizado e paginação correta
- [ ] Revisão ortográfica
