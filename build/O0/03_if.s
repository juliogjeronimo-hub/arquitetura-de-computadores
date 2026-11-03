	.file	"03_if.c"
	.intel_syntax noprefix
	.text
	.globl	"maior"
	.def	"maior";	.scl	2;	.type	32;	.endef
"maior":
/* Prologo da funcao */
	push	rbp
	mov	rbp, rsp

/* Parametros: a (ecx), b (edx) */
	mov	DWORD PTR 16[rbp], ecx	/* Salva a no stack */
	mov	DWORD PTR 24[rbp], edx	/* Salva b no stack */

/* if (a > b) { */
/* Compara a com b */
	mov	eax, DWORD PTR 16[rbp]	/* eax = a */
	cmp	eax, DWORD PTR 24[rbp]	/* Compara eax (a) com b */

/* Se a <= b, pula para else (jle = jump if less or equal) */
	jle	.L2				/* if (a <= b) goto .L2 */

/* return a; */
	mov	eax, DWORD PTR 16[rbp]	/* eax = a (valor de retorno) */
	jmp	.L3				/* Pula para epilogo */

/* } else { */
.L2:
/* return b; */
	mov	eax, DWORD PTR 24[rbp]	/* eax = b */

/* } */
.L3:
/* Epilogo */
	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
