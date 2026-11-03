	.file	"04_for.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_for"
	.def	"soma_for";	.scl	2;	.type	32;	.endef
"soma_for":
/* Prologo da funcao */
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16				/* Aloca 16 bytes no stack */

/* int soma_for(int n) { */
/* Parametro n vem em ecx */
	mov	DWORD PTR 16[rbp], ecx		/* Salva n no stack */

/* int soma = 0; */
	mov	DWORD PTR -4[rbp], 0		/* soma = 0 */

/* for (int i = 0; i < n; i++) { */
/* Inicializacao i = 0 */
	mov	DWORD PTR -8[rbp], 0		/* i = 0 */

/* Pula para condicao do loop (verificacao de termino) */
	jmp	.L2

/* Corpo do loop */
.L3:
/* soma += i; */
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	add	DWORD PTR -4[rbp], eax		/* soma = soma + i */

/* i++ */
	add	DWORD PTR -8[rbp], 1		/* i = i + 1 */

/* Condicao do loop: i < n */
.L2:
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	cmp	eax, DWORD PTR 16[rbp]		/* Compara i com n */

/* Se i < n, volta para o corpo (jl = jump if less) */
	jl	.L3				/* if (i < n) goto .L3 */

/* return soma; */
	mov	eax, DWORD PTR -4[rbp]		/* eax = soma */

/* Epilogo */
	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
