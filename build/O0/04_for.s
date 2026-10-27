	.file	"04_for.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_for"
	.def	"soma_for";	.scl	2;	.type	32;	.endef

; === Função soma_for(int n) ===
; Calcula a soma 0 + 1 + 2 + ... + (n-1) usando for
"soma_for":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16                     ; Aloca 16 bytes para variáveis locais

; Salva parâmetro (convenção Windows x64: n em ecx)
	mov	DWORD PTR 16[rbp], ecx       ; n = ecx em [rbp+16]

; Inicializa variáveis
	mov	DWORD PTR -4[rbp], 0        ; soma = 0 em [rbp-4]
	mov	DWORD PTR -8[rbp], 0        ; i = 0 em [rbp-8]

; Pula para o teste de condição (característica de for: teste antes de entrar no loop)
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
	jl	.L3                         ; Se i < n, volta ao corpo (.L3)

; --- Retorno ---
	mov	eax, DWORD PTR -4[rbp]       ; eax = soma (valor de retorno)

	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
