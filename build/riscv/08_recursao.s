	.file	"08_recursao.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	fatorial
	.type	fatorial, @function
/* int fatorial(int n) { */
fatorial:
/* Prologo */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* Salva n no stack */
	mv	a5, a0
	sw	a5, -20(s0)

/* if (n <= 1) { */
	lw	a5, -20(s0)
	sext.w	a4, a5
	li	a5, 1
	bgt	a4, a5, .L2		/* Se n > 1, pula para caso recursivo */

/* return 1; */
	li	a5, 1
	j	.L3

/* } else { */
.L2:
/* return n * fatorial(n - 1); */
/* Calcula n - 1 */
	lw	a5, -20(s0)
	addiw	a5, a5, -1		/* n - 1 */
	sext.w	a5, a5

/* Chama recursivamente fatorial(n - 1) */
	mv	a0, a5
	call	fatorial

/* Multiplica n * resultado */
	mv	a5, a0
	lw	a4, -20(s0)
	mulw	a5, a4, a5		/* n * fatorial(n-1) */
	sext.w	a5, a5

/* } */
.L3:
/* Retorno */
	mv	a0, a5

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	fatorial, .-fatorial
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
