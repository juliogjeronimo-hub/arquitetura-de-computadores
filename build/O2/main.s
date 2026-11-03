	.file	"main.c"
	.intel_syntax noprefix
	.text

/* Strings constantes (read-only data) */
	.section .rdata,"dr"
.LC0:
	.ascii "Digite o primeiro numero: \0"
.LC1:
	.ascii "%lf\0"
.LC2:
	.ascii "Digite o segundo numero: \0"
.LC3:
	.ascii "\12Primeiro numero: %.2f\12\0"
.LC4:
	.ascii "Segundo numero: %.2f\12\0"
.LC5:
	.ascii "Soma: %.2f\12\0"
	.align 8
.LC6:
	.ascii "\12Pressione Enter para encerrar...\0"

	.section	.text.startup,"x"
	.p2align 4
	.globl	"main"
	.def	"main";	.scl	2;	.type	32;	.endef
"main":
/* Otimizacao: sem prologo/epilogo completo, frame pointer omitido */
	sub	rsp, 56			/* Aloca 56 bytes (shadow space + variaveis) */

/* Inicializacao C runtime */
	call	"__main"

/* printf("Digite o primeiro numero: "); */
	lea	rcx, .LC0[rip]		/* Otimizacao: rcx direto, sem intermediarios */
	call	"printf"

/* scanf("%lf", &numero1); */
/* Numero1 armazenado em 32[rsp] (otimizacao: nao usa rbp) */
	lea	rdx, 32[rsp]			/* rdx = &numero1 */
	lea	rcx, .LC1[rip]
	call	"scanf"

/* printf("Digite o segundo numero: "); */
	lea	rcx, .LC2[rip]
	call	"printf"

/* scanf("%lf", &numero2); */
	lea	rdx, 40[rsp]			/* &numero2 */
	lea	rcx, .LC1[rip]
	call	"scanf"

/* printf("\nPrimeiro numero: %.2f\n", numero1); */
	movsd	xmm1, QWORD PTR 32[rsp]	/* xmm1 = numero1 */
	lea	rcx, .LC3[rip]
	movq	rdx, xmm1			/* Passa double via xmm0->rdx (varargs) */
	call	"printf"

/* printf("\nSegundo numero: %.2f\n", numero2); */
	movsd	xmm1, QWORD PTR 40[rsp]	/* xmm1 = numero2 */
	lea	rcx, .LC4[rip]
	movq	rdx, xmm1
	call	"printf"

/* printf("\nSoma: %.2f\n", numero1 + numero2); */
	movsd	xmm1, QWORD PTR 32[rsp]	/* xmm1 = numero1 */
	addsd	xmm1, QWORD PTR 40[rsp]	/* xmm1 = numero1 + numero2 (operacao SSE) */
	lea	rcx, .LC5[rip]
	movq	rdx, xmm1
	call	"printf"

/* printf("\nPressione Enter para encerrar..."); */
	lea	rcx, .LC6[rip]
	call	"printf"

/* getchar(); // Consome o '\n' */
	call	"getchar"

/* getchar(); // Aguarda Enter */
	call	"getchar"

/* return 0; */
	xor	eax, eax			/* eax = 0 (mais rapido que mov eax, 0) */

/* Epilogo simplificado */
	add	rsp, 56
	ret
/* Definicoes de simbolos externos */
	.def	"__main";	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
	.def	"printf";	.scl	2;	.type	32;	.endef
	.def	"scanf";	.scl	2;	.type	32;	.endef
	.def	"getchar";	.scl	2;	.type	32;	.endef
