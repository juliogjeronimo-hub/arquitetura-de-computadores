	.file	"01_soma.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"soma_simples"
	.def	"soma_simples";	.scl	2;	.type	32;	.endef
"soma_simples":
/* CONSTANT FOLDING: O compilador calcula 5 + 3 = 8 em tempo de compilacao! */
/* Nao ha prologo/epilogo - funcao inlineavel trivial */
	mov	eax, 8			/* eax = 8 (retorna constante 8 diretamente) */
	ret				/* Retorna 8 sem acessar memoria */
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
