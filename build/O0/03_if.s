	.file	"03_if.c"
	.intel_syntax noprefix
	.text
	.globl	"maior"
	.def	"maior";	.scl	2;	.type	32;	.endef

; === Função maior(int a, int b) ===
; Retorna o maior entre a e b usando if-else
"maior":
	push	rbp
	mov	rbp, rsp

; Salva parâmetros (convenção Windows x64: a em ecx, b em edx)
	mov	DWORD PTR 16[rbp], ecx       ; a = ecx em [rbp+16]
	mov	DWORD PTR 24[rbp], edx       ; b = edx em [rbp+24]

; --- if (a > b) ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = a
	cmp	eax, DWORD PTR 24[rbp]       ; Compara a com b (eax - b)
	jle	.L2                         ; Se a <= b, pula para .L2 (else)

; --- Bloco then: return a ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = a
	jmp	.L3                         ; Pula para o fim (.L3)

; --- Bloco else (.L2): return b ---
.L2:
	mov	eax, DWORD PTR 24[rbp]       ; eax = b

; --- Fim do if-else (.L3) ---
.L3:
	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
