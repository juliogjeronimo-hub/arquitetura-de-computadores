# Ligação com pipeline: dependências de dados e de controle

O pipeline executa várias instruções simultaneamente em estágios diferentes (busca, decodificação, execução, memória, escrita). Dois tipos de dependência podem forçar o pipeline a inserir bolhas (atrasos): dependências de dados e dependências de controle. Os exemplos `04_for` e `03_if` ilustram ambas com código real.

## Dependência de dados (no laço `04_for`)

No corpo do laço de `soma_for` (`-O0`):

```nasm
.L3:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax      ; usa eax produzido pela linha anterior
	add	DWORD PTR -8[rbp], 1
```

Há uma dependência de dados entre `mov eax, DWORD PTR -8[rbp]` e `add DWORD PTR -4[rbp], eax`: a segunda instrução precisa do valor de `eax` que a primeira acabou de produzir. No pipeline, se a soma entrar no estágio de execução antes de a leitura concluir a escrita de `eax`, ocorre um conflito (*data hazard*). O processador resolve isso com *forwarding* (encaminhamento do resultado direto entre estágios) ou, quando não é possível, inserindo uma bolha até o dado ficar disponível.

## Dependência de controle (no teste do laço `04_for` e no `03_if`)

No fim do laço de `soma_for`:

```nasm
.L2:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L3                        ; desvio condicional
```

O `jl .L3` é uma dependência de controle: o processador só sabe qual instrução buscar em seguida (voltar ao corpo ou sair do laço) depois de avaliar `cmp`. Enquanto a condição não é resolvida, as instruções seguintes já poderiam estar entrando no pipeline — mas a direção correta é incerta.

O mesmo acontece no `if` de `maior` (`03_if`):

```nasm
	cmp	eax, DWORD PTR 24[rbp]
	jle	.L2
```

Aqui o `jle .L2` decide, com base na comparação, qual dos dois ramos seguir.

## Bolhas e predição de desvios

Quando o processador não sabe o resultado de um desvio, ele arrisca uma suposição com o **preditor de desvios**: continua buscando instruções pelo caminho mais provável. Se acertar, o pipeline não perde ciclos; se errar, precisa descartar as instruções especulativas e recomeçar pelo caminho correto — uma bolha custosa.

Laços como o de `soma_for` são o cenário ideal para a predição: o desvio `jl .L3` é tomado em quase todas as iterações (só não é tomado na última). Um preditor simples que aposta "desvio sempre tomado" acerta na enorme maioria das vezes, mantendo o pipeline cheio. Já o `if` de `maior` é menos previsível, pois depende dos dados de entrada; foi justamente por isso que o `-O2` preferiu `cmovge` (movimento condicional *branchless*), eliminando o desvio e, com ele, o risco de erro de predição. Esses mecanismos correspondem ao tópico V da ementa (pipeline, dependências e predição de desvios).
