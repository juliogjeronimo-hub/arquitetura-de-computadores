	.file	"03_if.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"maior"
	.def	"maior";	.scl	2;	.type	32;	.endef
"maior":
/* BRANCHLESS: O compilador substituiu desvio por instrucao condicional! */
/* Nao ha prologo/epilogo - funcao otimizada para execucao rapida */
	cmp	ecx, edx			/* Compara a (ecx) com b (edx) */
	mov	eax, edx			/* eax = b (valor padrao: b se a <= b) */
	cmovge	eax, ecx			/* Se a >= b, eax = a (conditional move) */
	ret					/* Retorna eax (max(a,b)) */
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
