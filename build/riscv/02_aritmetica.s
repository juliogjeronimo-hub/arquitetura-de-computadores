	.file	"02_aritmetica.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	aritmetica
	.type	aritmetica, @function
/* int aritmetica(int x, int y) { */
aritmetica:
/* Prologo: aloca 64 bytes no stack, salva ra e s0 */
	addi	sp, sp, -64		/* Aloca espaco: sp -= 64 */
	sd	ra, 56(sp)		/* Salva ra (endereco de retorno) */
	sd	s0, 48(sp)		/* Salva s0 (frame pointer) */
	addi	s0, sp, 64		/* s0 = base do frame */

/* int s = x - y; */
/* int m = x * y; */
/* int d = x / y; */
/* int r = x % y; */
/* int l = (x & y) | (x ^ y); */
/* int sh = (x << 2) + (y >> 1); */

/* Salva parametros x (a0) e y (a1) no stack */
	mv	a5, a0			/* a5 = x */
	mv	a4, a1			/* a4 = y */
	sw	a5, -52(s0)		/* Salva x no stack */
	mv	a5, a4
	sw	a5, -56(s0)		/* Salva y no stack */

/* Operacao subtracao: s = x - y */
	lw	a5, -52(s0)		/* Carrega x */
	mv	a4, a5			/* Copia para a4 */
	lw	a5, -56(s0)		/* Carrega y */
	subw	a5, a4, a5		/* a5 = a4 - a5 (x - y) */
	sw	a5, -20(s0)		/* s = resultado */

/* Operacao multiplicacao: m = x * y */
	lw	a5, -52(s0)		/* Carrega x */
	mv	a4, a5
	lw	a5, -56(s0)		/* Carrega y */
	mulw	a5, a4, a5		/* a5 = a4 * a5 (x * y) */
	sw	a5, -24(s0)		/* m = resultado */

/* Operacao divisao: d = x / y */
	lw	a5, -52(s0)
	mv	a4, a5
	lw	a5, -56(s0)
	divw	a5, a4, a5		/* divw = divisao com sinal */
	sw	a5, -28(s0)		/* d = resultado */

/* Operacao resto: r = x % y */
	lw	a5, -52(s0)
	mv	a4, a5
	lw	a5, -56(s0)
	remw	a5, a4, a5		/* remw = resto da divisao */
	sw	a5, -32(s0)		/* r = resultado */

/* Operacao logica: l = (x & y) | (x ^ y) - GCC otimizou para apenas OR */
	lw	a5, -52(s0)
	mv	a4, a5
	lw	a5, -56(s0)
	or	a5, a4, a5		/* a5 = a4 | a5 */
	sw	a5, -36(s0)		/* l = resultado */

/* Operacao shift: sh = (x << 2) + (y >> 1) */
/* x << 2 */
	lw	a5, -52(s0)
	slliw	a5, a5, 2		/* shift left logico imediato por 2 bits */
	sext.w	a4, a5			/* estende sinal para a4 */

/* y >> 1 (shift aritmetico preserva sinal) */
	lw	a5, -56(s0)
	sraiw	a5, a5, 1		/* shift right aritmetico */
	sext.w	a5, a5			/* estende sinal para a5 */

/* Soma os dois resultados */
	addw	a5, a4, a5		/* a5 = (x<<2) + (y>>1) */
	sw	a5, -40(s0)		/* sh = resultado */

/* return s + m + d + r + l + sh; */
/* Soma acumulada de todos os resultados */
	lw	a5, -20(s0)		/* Carrega s */
	mv	a4, a5
	lw	a5, -24(s0)		/* Carrega m */
	addw	a5, a4, a5
	sext.w	a5, a5
	lw	a4, -28(s0)		/* Carrega d */
	addw	a5, a4, a5
	sext.w	a5, a5
	lw	a4, -32(s0)		/* Carrega r */
	addw	a5, a4, a5
	sext.w	a5, a5
	lw	a4, -36(s0)		/* Carrega l */
	addw	a5, a4, a5
	sext.w	a5, a5
	lw	a4, -40(s0)		/* Carrega sh */
	addw	a5, a4, a5
	sext.w	a5, a5
	mv	a0, a5			/* a0 = valor de retorno */

/* Epilogo: restaura ra e s0, desaloca stack */
	ld	ra, 56(sp)
	ld	s0, 48(sp)
	addi	sp, sp, 64
	jr	ra
	.size	aritmetica, .-aritmetica

/* int dobro(int x) { */
	.align	1
	.globl	dobro
	.type	dobro, @function
dobro:
/* Prologo: aloca 32 bytes */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* return x * 2; */
	mv	a5, a0			/* a5 = x */
	sw	a5, -20(s0)		/* Salva x no stack */
	lw	a5, -20(s0)		/* Carrega x */
	slliw	a5, a5, 1		/* shift left por 1 (multiplica por 2) */
	sext.w	a5, a5
	mv	a0, a5			/* a0 = retorno */

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	dobro, .-dobro
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
