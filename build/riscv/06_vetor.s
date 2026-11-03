	.file	"06_vetor.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	soma_vetor
	.type	soma_vetor, @function
/* int soma_vetor(void) { */
/* int v[10]; */
/* for (int i = 0; i < 10; i++) v[i] = i * 2; */
/* int soma = 0; */
/* for (int i = 0; i < 10; i++) soma += v[i]; */
/* return soma; */
soma_vetor:
/* Prologo: aloca 80 bytes no stack (v[10] = 40 bytes + variaveis) */
	addi	sp, sp, -80
	sd	ra, 72(sp)
	sd	s0, 64(sp)
	addi	s0, sp, 80

/* Primeiro loop: for (int i = 0; i < 10; i++) v[i] = i * 2; */
	sw	zero, -20(s0)		/* i = 0 */
	j	.L2

.L3:
/* v[i] = i * 2; */
/* Calcula i * 2 */
	lw	a5, -20(s0)		/* Carrega i */
	slliw	a5, a5, 1		/* i * 2 (shift left por 1) */
	sext.w	a4, a5			/* Estende para a4 */

/* Calcula endereco: &v[i] = s0 - 72 + i * 4 */
	lw	a3, -20(s0)		/* Carrega i */
	addi	a5, s0, -72		/* a5 = base do vetor v */
	slli	a3, a3, 2		/* i * 4 (sizeof(int) = 4) */
	add	a5, a3, a5		/* endereco = base + i*4 */
	sw	a4, 0(a5)		/* v[i] = i * 2 */

/* i++ */
	lw	a5, -20(s0)
	addiw	a5, a5, 1
	sw	a5, -20(s0)

/* Condicao: i < 10 */
.L2:
	lw	a5, -20(s0)
	sext.w	a4, a5
	li	a5, 9			/* Carrega imediato 9 */
	ble	a4, a5, .L3		/* Se i <= 9, continua loop */

/* Segundo loop: for (int i = 0; i < 10; i++) soma += v[i]; */
	sw	zero, -24(s0)		/* soma = 0 */
	sw	zero, -28(s0)		/* i = 0 */
	j	.L4

.L5:
/* soma += v[i]; */
/* Calcula endereco: &v[i] */
	lw	a4, -28(s0)		/* Carrega i */
	addi	a5, s0, -72		/* a5 = base do vetor */
	slli	a4, a4, 2		/* i * 4 */
	add	a5, a4, a5		/* endereco de v[i] */
	lw	a5, 0(a5)		/* Carrega v[i] */

/* soma = soma + v[i] */
	lw	a4, -24(s0)		/* Carrega soma */
	addw	a5, a4, a5		/* soma + v[i] */
	sw	a5, -24(s0)		/* Atualiza soma */

/* i++ */
	lw	a5, -28(s0)
	addiw	a5, a5, 1
	sw	a5, -28(s0)

/* Condicao: i < 10 */
.L4:
	lw	a5, -28(s0)
	sext.w	a4, a5
	li	a5, 9
	ble	a4, a5, .L5		/* Se i <= 9, continua */

/* return soma; */
	lw	a5, -24(s0)
	mv	a0, a5

/* Epilogo */
	ld	ra, 72(sp)
	ld	s0, 64(sp)
	addi	sp, sp, 80
	jr	ra
	.size	soma_vetor, .-soma_vetor
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
