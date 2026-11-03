	.file	"07_funcao.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	soma
	.type	soma, @function
/* int soma(int a, int b) { */
soma:
/* Prologo: aloca 32 bytes */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* Salva parametros no stack */
	mv	a5, a0
	mv	a4, a1
	sw	a5, -20(s0)		/* Salva a */
	mv	a5, a4
	sw	a5, -24(s0)		/* Salva b */

/* return a + b; */
	lw	a5, -20(s0)		/* Carrega a */
	mv	a4, a5
	lw	a5, -24(s0)		/* Carrega b */
	addw	a5, a4, a5		/* a + b */
	sext.w	a5, a5
	mv	a0, a5			/* Retorno em a0 */

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	soma, .-soma

/* int chamada(void) { */
	.align	1
	.globl	chamada
	.type	chamada, @function
chamada:
/* Prologo: aloca 16 bytes (apenas para preservar calling convention) */
	addi	sp, sp, -16
	sd	ra, 8(sp)
	sd	s0, 0(sp)
	addi	s0, sp, 16

/* return soma(4, 6); */
/* Carrega argumentos e chama soma */
	li	a1, 6			/* a1 = segundo argumento = 6 */
	li	a0, 4			/* a0 = primeiro argumento = 4 */
	call	soma			/* Chama soma(4, 6), resultado em a0 */
	mv	a5, a0			/* Copia resultado */
	mv	a0, a5			/* Retorno em a0 */

/* Epilogo */
	ld	ra, 8(sp)
	ld	s0, 0(sp)
	addi	sp, sp, 16
	jr	ra
	.size	chamada, .-chamada
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
