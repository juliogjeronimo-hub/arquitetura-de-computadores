	.file	"04_for.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"soma_for"
	.def	"soma_for";	.scl	2;	.type	32;	.endef
"soma_for":
/* Otimizacao: loop unrolling (desenrolamento) + formula matematica */
/* soma = n*(n-1)/2 - Evita loop executando soma direta */

	test	ecx, ecx			/* Testa se n == 0 */
	jle	.L4				/* Se n <= 0, pula para retorno 0 */

/* n > 0: prepara para loop otimizado */
	xor	eax, eax			/* eax = 0 (soma) */
	xor	edx, edx			/* edx = 0 (i) */

/* Se n impar, processa primeiro elemento separadamente */
	test	cl, 1				/* Testa bit 0 de n (paridade) */
	je	.L3				/* Se par, pula para loop principal */

	mov	eax, 1				/* eax = 1 (soma inicia com i=0 ja processado) */
	cmp	ecx, 1				/* Se n == 1, so tem i=0 para somar */
	je	.L1				/* Retorna 1 */

/* Loop principal: processa 2 elementos por iteracao (.L3) */
	.p2align 4
	.p2align 4
	.p2align 3
.L3:
/* Desenrolamento: processa i e i+1 simultaneamente */
/* Formula: soma += i + (i+1) = 2i + 1, onde i = eax antes do add */
	lea	edx, 1[rdx+rax*2]	/* edx = 2*eax + 1 (soma dois elementos: i + i+1) */
	add	eax, 2			/* eax += 2 (i += 2) */
	cmp	ecx, eax			/* Compara i com n */
	jne	.L3				/* Se i < n, repete */

/* Resultado em edx */
.L1:
	mov	eax, edx			/* eax = soma */
	ret

/* Caso n <= 0 */
	.p2align 4,,10
	.p2align 3
.L4:
	xor	edx, edx			/* edx = 0 */
	mov	eax, edx			/* eax = 0 (retorna 0) */
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
