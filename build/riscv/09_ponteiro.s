	.file	"09_ponteiro.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	incrementa
	.type	incrementa, @function
/* void incrementa(int *p) { */
incrementa:
/* Prologo */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* Salva ponteiro p no stack */
	sd	a0, -24(s0)		/* Salva *p (o ponteiro) */

/* *p = *p + 1; */
/* Carrega o valor apontado por p */
	ld	a5, -24(s0)		/* Carrega p (endereco) */
	lw	a5, 0(a5)		/* Carrega *p (valor no endereco) */
	addiw	a5, a5, 1		/* *p = *p + 1 */
	sext.w	a4, a5			/* Estende resultado */

/* Escreve o novo valor de volta na memoria */
	ld	a5, -24(s0)		/* Recarrega p */
	sw	a4, 0(a5)		/* *p = novo valor */

/* Nop para alinhamento */
	nop

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	incrementa, .-incrementa

/* int usa_ponteiro(void) { */
	.align	1
	.globl	usa_ponteiro
	.type	usa_ponteiro, @function
usa_ponteiro:
/* Prologo */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* int x = 10; */
	li	a5, 10
	sw	a5, -20(s0)		/* x = 10 */

/* incrementa(&x); */
/* Calcula endereco de x */
	addi	a5, s0, -20		/* a5 = &x */
	mv	a0, a5			/* a0 = &x (parametro para incrementa) */
	call	incrementa		/* incrementa(&x), x agora = 11 */

/* return x; */
	lw	a5, -20(s0)		/* Carrega x (= 11) */
	mv	a0, a5			/* Retorno em a0 */

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	usa_ponteiro, .-usa_ponteiro
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
