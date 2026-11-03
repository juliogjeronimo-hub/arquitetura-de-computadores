	.file	"09_ponteiro.c"
	.text
	.p2align 4
	.globl	incrementa
	.def	incrementa;	.scl	2;	.type	32;	.endef
	.seh_proc	incrementa
incrementa:
	.seh_endprologue
/* Otimizacao: acesso direto a memoria sem carregar para registrador temporario */
	addl	$1, (%rcx)		/* *p = *p + 1 (memoria[rcx] += 1) */
/* Nota: operando em memoria permite que a CPU faca load-modify-store atomico */
	ret
	.seh_endproc

/* int usa_ponteiro(void) { */
	.p2align 4
	.globl	usa_ponteiro
	.def	usa_ponteiro;	.scl	2;	.type	32;	.endef
	.seh_proc	usa_ponteiro
usa_ponteiro:
	.seh_endprologue
/* CONSTANT PROPAGATION + INLINING: toda a logica resolvida em tempo de compilacao */
/* x = 10 -> incrementa(&x) = 11 -> return 11 */
	movl	$11, %eax		/* eax = 11 (resultado final constante) */
	ret				/* Retorna 11, nenhuma operacao em tempo de execucao */
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
