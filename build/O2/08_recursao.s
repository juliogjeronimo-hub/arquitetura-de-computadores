	.file	"08_recursao.c"
	.text
	.p2align 4
	.globl	fatorial
	.def	fatorial;	.scl	2;	.type	32;	.endef
	.seh_proc	fatorial
fatorial:
	.seh_endprologue
/* TAIL RECURSION ELIMINATION: Recursao convertida em loop! */
/* Esta tecnica elimina a pilha de chamadas, transformando recursao em iteracao */

	movl	$1, %eax			/* eax = 1 (valor inicial do fatorial) */
	cmpl	$1, %ecx			/* Compara n com 1 */
	jle	.L1				/* Se n <= 1, retorna 1 diretamente */

/* Loop: multiplica n * (n-1) * (n-2) * ... * 1 */
	.p2align 4
	.p2align 4
	.p2align 3
.L2:
/* Corpo do loop: fatorial *= n, decrementa n */
	imull	%ecx, %eax			/* eax = eax * ecx (multiplica resultado atual por n) */
	subl	$1, %ecx			/* ecx = ecx - 1 (n--) */
	cmpl	$1, %ecx			/* Compara n com 1 */
	jne	.L2				/* Se n > 1, repete */

/* Caso base ou termino do loop */
.L1:
	ret					/* Retorna eax (resultado) */
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
