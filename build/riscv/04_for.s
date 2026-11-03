	.file	"04_for.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	soma_for
	.type	soma_for, @function
/* int soma_for(int n) { */
soma_for:
/* Prologo */
	addi	sp, sp, -48
	sd	ra, 40(sp)
	sd	s0, 32(sp)
	addi	s0, sp, 48

/* int soma = 0; */
/* Salva parametro n no stack */
	mv	a5, a0
	sw	a5, -36(s0)

/* Inicializacao: soma = 0, i = 0 */
	sw	zero, -20(s0)		/* soma = 0 */
	sw	zero, -24(s0)		/* i = 0 */

/* Pula para condicao do loop */
	j	.L2

/* Corpo do loop: soma += i */
.L3:
	lw	a5, -20(s0)		/* Carrega soma */
	mv	a4, a5
	lw	a5, -24(s0)		/* Carrega i */
	addw	a5, a4, a5		/* soma + i */
	sw	a5, -20(s0)		/* soma = soma + i */

/* i++ */
	lw	a5, -24(s0)
	addiw	a5, a5, 1		/* i = i + 1 */
	sw	a5, -24(s0)

/* Condicao do loop: i < n */
.L2:
	lw	a5, -24(s0)		/* Carrega i */
	mv	a4, a5
	lw	a5, -36(s0)		/* Carrega n */
	sext.w	a4, a4
	sext.w	a5, a5

/* blt = branch if less than */
	blt	a4, a5, .L3		/* Se i < n, executa corpo do loop */

/* return soma; */
	lw	a5, -20(s0)
	mv	a0, a5

/* Epilogo */
	ld	ra, 40(sp)
	ld	s0, 32(sp)
	addi	sp, sp, 48
	jr	ra
	.size	soma_for, .-soma_for
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
