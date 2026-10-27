	.file	"01_soma.c"                    ; Nome do arquivo fonte
	.intel_syntax noprefix              ; Sintaxe Intel (sem prefixos % ou $)
	.text                               ; Seção de código executável
	.globl	"soma_simples"              ; Torna a função visível ao linker
	.def	"soma_simples";	.scl	2;	.type	32;	.endef  ; Metadados COFF

; --- Prólogo da função ---
"soma_simples":
	push	rbp                         ; Salva o frame pointer anterior
	mov	rbp, rsp                    ; Estabelece novo frame: rbp = rsp
	sub	rsp, 16                     ; Aloca 16 bytes na pilha para variáveis locais

; --- Inicialização das variáveis locais ---
	mov	DWORD PTR -4[rbp], 5       ; a = 5 em [rbp-4]
	mov	DWORD PTR -8[rbp], 3       ; b = 3 em [rbp-8]

; --- Carregamento dos valores em registradores ---
	mov	edx, DWORD PTR -4[rbp]     ; edx = a (carrega de [rbp-4])
	mov	eax, DWORD PTR -8[rbp]     ; eax = b (carrega de [rbp-8])

; --- Operação de soma ---
	add	eax, edx                    ; eax = eax + edx (c = a + b)

; --- Armazenamento do resultado ---
	mov	DWORD PTR -12[rbp], eax    ; c = eax em [rbp-12]

; --- Preparação do retorno ---
	mov	eax, DWORD PTR -12[rbp]    ; eax = c (valor de retorno)

; --- Epílogo da função ---
	leave                           ; Desfaz o frame (equivalente a: mov rsp, rbp; pop rbp)
	ret                             ; Retorna ao chamador

	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
