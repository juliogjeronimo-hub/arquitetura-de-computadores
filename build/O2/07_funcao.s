	.file	"07_funcao.c"
	.text
	.p2align 4
	.globl	soma
	.def	soma;	.scl	2;	.type	32;	.endef
	.seh_proc	soma
soma:
	.seh_endprologue
/* INLINING: soma() foi otimizada para operacao direta */
	leal	(%rcx,%rdx), %eax	/* eax = rcx + rdx (a + b), LEA calcula sem accesso memoria */
	ret				/* Retorna a + b diretamente */
	.seh_endproc

/* int chamada(void) { */
	.p2align 4
	.globl	chamada
	.def	chamada;	.scl	2;	.type	32;	.endef
	.seh_proc	chamada
chamada:
	.seh_endprologue
/* CONSTANT FOLDING + INLINING: soma(4, 6) = 10 calculado em tempo de compilacao */
	movl	$10, %eax		/* eax = 10 (resultado de 4 + 6) */
	ret				/* Retorna 10 diretamente, sem chamar soma() */
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
