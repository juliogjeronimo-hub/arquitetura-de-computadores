	.file	"06_vetor.c"
	.text
	.p2align 4
	.globl	soma_vetor
	.def	soma_vetor;	.scl	2;	.type	32;	.endef
	.seh_proc	soma_vetor
soma_vetor:
/* Prologo com espaco para .seh (Windows exception handling) */
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue

/* Carrega constantes do .rdata: .LC0 = {0, 1}, .LC1 = {2, 2} */
	movq	.LC0(%rip), %xmm0	/* xmm0 = {0, 1} - vetor base [0,1] */
	movq	.LC1(%rip), %xmm2	/* xmm2 = {2, 2} - incrementador */

/* Prepara ponteiros para geracao do vetor */
	movq	%rsp, %rax		/* rax = ponteiro atual (topo do stack) */
	leaq	40(%rsp), %rdx		/* rdx = endereco final (40 bytes = 10 ints) */

/* for (int i = 0; i < 10; i++) v[i] = i * 2; - VETORIZADO! */
.L2:
/* v[i] = i * 2 (processa 2 elementos por iteracao com SSE) */
	movdqa	%xmm0, %xmm1		/* xmm1 = xmm0 (copia vetor [i, i+1]) */
	addq	$8, %rax		/* Avanca 8 bytes (2 ints) no ponteiro */
	paddd	%xmm2, %xmm0		/* xmm0 = xmm0 + {2, 2} -> gera indices [i+2, i+3] */
	pslld	$1, %xmm1		/* xmm1 = xmm1 * 2 (multiplica indices por 2) */
	movq	%xmm1, -8(%rax)		/* Armazena 2 ints no vetor v[] */

/* Teste de termino do loop */
	cmpq	%rdx, %rax		/* Compara ponteiro atual com final */
	jne	.L2			/* Se nao chegou ao fim, repete */

/* Soma todos os elementos do vetor - TAMBM VETORIZADO! */
/* Carrega os 10 inteiros (40 bytes) do vetor */
	movdqu	16(%rsp), %xmm0		/* xmm0 = primeiros 4 ints do vetor */
	paddd	(%rsp), %xmm0		/* xmm0 = soma dos 8 ints (2 primeiros + 2 seguintes) */

/* Reducao horizontal: soma todos os elementos do vetor SSE */
	movdqa	%xmm0, %xmm1		/* Copia xmm0 */
	psrldq	$8, %xmm1		/* Desloca 8 bytes (move high doubleword para low) */
	paddd	%xmm1, %xmm0		/* xmm0 = [a0+a4, a1+a5, a2+a6, a3+a7] */
	movdqa	%xmm0, %xmm1		/* Copia novamente */
	psrldq	$4, %xmm1		/* Desloca 4 bytes (move a2+a6 para low) */
	paddd	%xmm1, %xmm0		/* xmm0 = [a0+a2+a4+a6, ...] */

/* Extrai a soma final (elemento low do vetor) */
	movd	%xmm0, %eax		/* eax = soma dos 8 primeiros ints */

/* Soma os 2 ultimos elementos (nao processados pelo loop vetorial) */
	addl	32(%rsp), %eax		/* eax += v[8] */
	addl	36(%rsp), %eax		/* eax += v[9] */

/* Epilogo */
	addq	$56, %rsp
	ret
	.seh_endproc
/* Constantes para vetorizacao (embedadas no .rdata) */
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	0			/* Primeiro indice: 0 */
	.long	1			/* Segundo indice: 1 */
	.align 8
.LC1:
	.long	2			/* Incremento do indice */
	.long	2			/* Repetido para operacao vetorial */
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
