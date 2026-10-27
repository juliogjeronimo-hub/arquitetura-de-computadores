	.file	"05_while.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_while"
	.def	"soma_while";	.scl	2;	.type	32;	.endef

; === Função soma_while(int n) ===
; Calcula a soma 0 + 1 + 2 + ... + (n-1) usando while
"soma_while":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16                     ; Aloca 16 bytes para variáveis locais

; Salva parâmetro (convenção Windows x64: n em ecx)
	mov	DWORD PTR 16[rbp], ecx       ; n = ecx em [rbp+16]

; Inicializa variáveis
	mov	DWORD PTR -4[rbp], 0        ; soma = 0 em [rbp-4]
	mov	DWORD PTR -8[rbp], 0        ; i = 0 em [rbp-8]

; Pula para o teste de condição (while: sempre testa antes de entrar)
	jmp	.L2

; --- Corpo do loop (.L3) ---
.L3:
	mov	eax, DWORD PTR -8[rbp]       ; eax = i
	add	DWORD PTR -4[rbp], eax       ; soma += i
	add	DWORD PTR -8[rbp], 1         ; i++

; --- Teste de condição (.L2) ---
.L2:
	mov	eax, DWORD PTR -8[rbp]       ; eax = i
	cmp	eax, DWORD PTR 16[rbp]       ; Compara i com n
	jl	.L3                         ; Se i < n, executa corpo (.L3)

; --- Retorno ---
	mov	eax, DWORD PTR -4[rbp]       ; eax = soma (valor de retorno)

	leave
	ret

; === Função soma_dowhile(int n) ===
; Calcula a soma 0 + 1 + 2 + ... + (n-1) usando do-while
	.globl	"soma_dowhile"
	.def	"soma_dowhile";	.scl	2;	.type	32;	.endef
"soma_dowhile":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16                     ; Aloca 16 bytes para variáveis locais

; Salva parâmetro (convenção Windows x64: n em ecx)
	mov	DWORD PTR 16[rbp], ecx       ; n = ecx em [rbp+16]

; Inicializa variáveis
	mov	DWORD PTR -4[rbp], 0        ; soma = 0 em [rbp-4]
	mov	DWORD PTR -8[rbp], 0        ; i = 0 em [rbp-8]

; --- Corpo do loop (.L6) - executa ANTES de testar ---
.L6:
	mov	eax, DWORD PTR -8[rbp]       ; eax = i
	add	DWORD PTR -4[rbp], eax       ; soma += i
	add	DWORD PTR -8[rbp], 1         ; i++

; --- Teste de condição (após execução do corpo) ---
	mov	eax, DWORD PTR -8[rbp]       ; eax = i
	cmp	eax, DWORD PTR 16[rbp]       ; Compara i com n
	jl	.L6                         ; Se i < n, volta ao corpo (.L6)

; --- Retorno ---
	mov	eax, DWORD PTR -4[rbp]       ; eax = soma (valor de retorno)

	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
