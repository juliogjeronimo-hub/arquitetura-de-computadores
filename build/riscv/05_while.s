	.file	"05_while.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	soma_while
	.type	soma_while, @function
/* int soma_while(int n) { */
soma_while:
/* Prologo */
	addi	sp, sp, -48
	sd	ra, 40(sp)
	sd	s0, 32(sp)
	addi	s0, sp, 48

/* Inicializacoes */
	mv	a5, a0
	sw	a5, -36(s0)		/* Salva n */
	sw	zero, -20(s0)		/* soma = 0 */
	sw	zero, -24(s0)		/* i = 0 */

/* Pula para condicao do loop (primeira verificacao) */
	j	.L2

/* Corpo do loop */
.L3:
/* soma += i; */
	lw	a5, -20(s0)
	mv	a4, a5
	lw	a5, -24(s0)
	addw	a5, a4, a5
	sw	a5, -20(s0)

/* i++; */
	lw	a5, -24(s0)
	addiw	a5, a5, 1
	sw	a5, -24(s0)

/* Condicao: i < n */
.L2:
	lw	a5, -24(s0)
	mv	a4, a5
	lw	a5, -36(s0)
	sext.w	a4, a4
	sext.w	a5, a5

	blt	a4, a5, .L3		/* Se i < n, repete */

/* return soma; */
	lw	a5, -20(s0)
	mv	a0, a5

/* Epilogo */
	ld	ra, 40(sp)
	ld	s0, 32(sp)
	addi	sp, sp, 48
	jr	ra
	.size	soma_while, .-soma_while

/* int soma_dowhile(int n) { */
	.align	1
	.globl	soma_dowhile
	.type	soma_dowhile, @function
soma_dowhile:
/* Prologo */
	addi	sp, sp, -48
	sd	ra, 40(sp)
	sd	s0, 32(sp)
	addi	s0, sp, 48

/* Inicializacoes */
	mv	a5, a0
	sw	a5, -36(s0)		/* Salva n */
	sw	zero, -20(s0)		/* soma = 0 */
	sw	zero, -24(s0)		/* i = 0 */

/* Corpo do loop (executa ANTES da verificacao) */
.L6:
/* soma += i; */
	lw	a5, -20(s0)
	mv	a4, a5
	lw	a5, -24(s0)
	addw	a5, a4, a5
	sw	a5, -20(s0)

/* i++; */
	lw	a5, -24(s0)
	addiw	a5, a5, 1
	sw	a5, -24(s0)

/* Verificacao: i < n */
	lw	a5, -24(s0)
	mv	a4, a5
	lw	a5, -36(s0)
	sext.w	a4, a4
	sext.w	a5, a5

	blt	a4, a5, .L6		/* Se i < n, repete */

/* return soma; */
	lw	a5, -20(s0)
	mv	a0, a5

/* Epilogo */
	ld	ra, 40(sp)
	ld	s0, 32(sp)
	addi	sp, sp, 48
	jr	ra
	.size	soma_dowhile, .-soma_dowhile
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
