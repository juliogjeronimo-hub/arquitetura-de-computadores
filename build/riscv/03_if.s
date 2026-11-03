	.file	"03_if.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	maior
	.type	maior, @function
/* int maior(int a, int b) { */
maior:
/* Prologo */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* Salva parametros no stack */
	mv	a5, a0
	mv	a4, a1
	sw	a5, -20(s0)
	mv	a5, a4
	sw	a5, -24(s0)

/* if (a > b) { */
/* Carrega a e b para comparacao */
	lw	a5, -20(s0)
	mv	a4, a5
	lw	a5, -24(s0)

/* Extensao de sinal para comparacao */
	sext.w	a4, a4
	sext.w	a5, a5

/* Compara: ble = branch if less or equal (inverso de a > b) */
	ble	a4, a5, .L2		/* Se a <= b, pula para else */

/* return a; */
	lw	a5, -20(s0)
	j	.L3

/* } else { */
.L2:
/* return b; */
	lw	a5, -24(s0)

/* } */
.L3:
/* Retorno em a0 */
	mv	a0, a5

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	maior, .-maior
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
