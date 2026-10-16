# Hello World — C para Assembly

Projeto de exemplo que demonstra como compilar um programa C para assembly e gerar um executável no Windows usando MSYS2 UCRT64.

## Preparação do ambiente

### 1. Instalar o MSYS2

Baixe e instale o MSYS2 em [https://www.msys2.org](https://www.msys2.org).

O instalador padrão usa o caminho `C:\msys64`.

### 2. Instalar o GCC via UCRT64

Abra o terminal **MSYS2 UCRT64** (disponível no menu Iniciar após a instalação) e execute:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc
```

Confirme a instalação quando solicitado. Após concluir, verifique:

```bash
gcc --version
```

A saída deve exibir algo como `GCC 16.x.x (Rev4, Built by MSYS2 project)`.

### 3. Configurar o terminal no Kiro (opcional)

Para usar o GCC diretamente no terminal integrado do Kiro, adicione o perfil abaixo ao `settings.json` do usuário (`Ctrl+Shift+P` → `Open User Settings (JSON)`):

```json
"terminal.integrated.profiles.windows": {
    "MSYS2 UCRT64": {
        "path": "C:\\msys64\\usr\\bin\\bash.exe",
        "args": ["--login", "-i"],
        "env": {
            "MSYSTEM": "UCRT64",
            "CHERE_INVOKING": "1"
        }
    }
}
```

---

## Compilar C para Assembly

O comando abaixo gera um arquivo `.s` com o assembly equivalente ao código C, usando sintaxe Intel e sem otimizações (`-O0`):

```bash
gcc -S -O0 -masm=intel src/main.c -o build/main.s
```

### Flags utilizadas

| Flag | Descrição |
|------|-----------|
| `-S` | Para a compilação na etapa de assembly, sem montar nem linkar |
| `-O0` | Desativa otimizações, mantendo o assembly próximo ao código C original |
| `-masm=intel` | Gera assembly com sintaxe Intel (em vez da sintaxe AT&T padrão do GCC) |
| `-o build/main.s` | Define o arquivo de saída |

> **Observação:** a flag `-masm=intel` controla apenas a **sintaxe** do assembly gerado. Ela não tem relação com a marca do processador — funciona normalmente em CPUs AMD.

---

## Gerar o executável

### Direto do fonte C

```bash
gcc src/main.c -o build/main.exe
```

### A partir do arquivo assembly

```bash
gcc build/main.s -o build/main.exe
```

O GCC reconhece a extensão `.s` e executa automaticamente as duas etapas:

1. **Montagem** — converte o assembly (`.s`) em código objeto (`.o`)
2. **Linkagem** — une o objeto com as bibliotecas do sistema e gera o `.exe`

### Passo a passo separado

Caso queira controlar cada etapa individualmente:

```bash
# Etapa 1 — Montar: gera o arquivo objeto
gcc -c build/main.s -o build/main.o

# Etapa 2 — Linkar: gera o executável
gcc build/main.o -o build/main.exe
```

---

## Executar

```bash
./build/main.exe
```
