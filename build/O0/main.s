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

	.text
	.globl	"main"
	.def	"main";	.scl	2;	.type	32;	.endef
"main":
/* Prologo padrao */
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48			/* Aloca 48 bytes no stack (variaveis locais + padding) */

/* Inicializacao C runtime */
	call	"__main"

/* printf("Digite o primeiro numero: "); */
	lea	rax, .LC0[rip]		/* Carrega endereco da string .LC0 */
	mov	rcx, rax			/* rcx = argumento para printf */
	call	"printf"

/* scanf("%lf", &numero1); */
	lea	rax, -8[rbp]			/* Calcula endereco de numero1 (double no stack) */
	lea	rcx, .LC1[rip]			/* rcx = "%lf" */
	mov	rdx, rax			/* rdx = endereco de numero1 */
	call	"scanf"

/* printf("Digite o segundo numero: "); */
	lea	rax, .LC2[rip]
	mov	rcx, rax
	call	"printf"

/* scanf("%lf", &numero2); */
	lea	rax, -16[rbp]			/* numero2 esta em -16[rbp] */
	lea	rcx, .LC1[rip]
	mov	rdx, rax
	call	"scanf"

/* printf("\nPrimeiro numero: %.2f\n", numero1); */
	movsd	xmm0, QWORD PTR -8[rbp]	/* xmm0 = numero1 */
	movapd	xmm1, xmm0			/* xmm1 = xmm0 (copia para possivel uso) */
	movapd	xmm0, xmm1			/* xmm0 = xmm1 (parametro para printf) */
	movq	rdx, xmm1			/* rdx = xmm1 (valor double) */
	lea	rax, .LC3[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"

/* printf("\nSegundo numero: %.2f\n", numero2); */
	movsd	xmm0, QWORD PTR -16[rbp]	/* xmm0 = numero2 */
	movapd	xmm1, xmm0
	movapd	xmm0, xmm1
	movq	rdx, xmm1
	lea	rax, .LC4[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"

/* printf("\nSoma: %.2f\n", numero1 + numero2); */
	movsd	xmm1, QWORD PTR -8[rbp]	/* xmm1 = numero1 */
	movsd	xmm0, QWORD PTR -16[rbp]	/* xmm0 = numero2 */
	addsd	xmm0, xmm1			/* xmm0 = numero1 + numero2 */
	movapd	xmm1, xmm0
	movapd	xmm0, xmm1
	movq	rdx, xmm1
	lea	rax, .LC5[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"

/* printf("\nPressione Enter para encerrar..."); */
	lea	rax, .LC6[rip]
	mov	rcx, rax
	call	"printf"

/* getchar(); // Consome o '\n' */
	call	"getchar"

/* getchar(); // Aguarda Enter */
	call	"getchar"

/* return 0; */
	mov	eax, 0

/* Epilogo */
	leave
	ret
/* Definicoes de simbolos externos usados */
	.def	"__main";	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
	.def	"printf";	.scl	2;	.type	32;	.endef
	.def	"scanf";	.scl	2;	.type	32;	.endef
	.def	"getchar";	.scl	2;	.type	32;	.endef
