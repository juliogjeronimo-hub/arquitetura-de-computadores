	.file	"main.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text

/* Dados somente-leitura (strings) */
	.section	.rodata
	.align	3
.LC0:
	.string	"Digite o primeiro numero: "
	.align	3
.LC1:
	.string	"%lf"
	.align	3
.LC2:
	.string	"Digite o segundo numero: "
	.align	3
.LC3:
	.string	"\nPrimeiro numero: %.2f\n"
	.align	3
.LC4:
	.string	"Segundo numero: %.2f\n"
	.align	3
.LC5:
	.string	"Soma: %.2f\n"
	.align	3
.LC6:
	.string	"\nPressione Enter para encerrar..."

	.text
	.align	1
	.globl	main
	.type	main, @function
main:
/* Prologo */
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	addi	s0, sp, 32

/* printf("Digite o primeiro numero: "); */
/* Carrega endereco da string (lui = load upper immediate, %hi = high 20 bits) */
	lui	a5, %hi(.LC0)		/* Carrega parte alta do endereco */
	addi	a0, a5, %lo(.LC0)	/* Carrega parte baixa -> a0 = &.LC0 */
	call	printf

/* scanf("%lf", &numero1); */
/* numero1 armazenado em -24(s0) */
	addi	a5, s0, -24		/* Calcula &numero1 */
	mv	a1, a5			/* a1 = &numero1 (2o argumento) */
	lui	a5, %hi(.LC1)
	addi	a0, a5, %lo(.LC1)	/* a0 = "%lf" (1o argumento) */
	call	scanf

/* printf("Digite o segundo numero: "); */
	lui	a5, %hi(.LC2)
	addi	a0, a5, %lo(.LC2)
	call	printf

/* scanf("%lf", &numero2); */
/* numero2 armazenado em -32(s0) */
	addi	a5, s0, -32
	mv	a1, a5
	lui	a5, %hi(.LC1)
	addi	a0, a5, %lo(.LC1)
	call	scanf

/* printf("\nPrimeiro numero: %.2f\n", numero1); */
/* Carrega double do stack: fld = floating point load */
	fld	fa5, -24(s0)		/* fa5 = numero1 */
	fmv.x.d	a1, fa5			/* Move double para registrador inteiro a1 */
	lui	a5, %hi(.LC3)
	addi	a0, a5, %lo(.LC3)
	call	printf

/* printf("\nSegundo numero: %.2f\n", numero2); */
	fld	fa5, -32(s0)		/* fa5 = numero2 */
	fmv.x.d	a1, fa5
	lui	a5, %hi(.LC4)
	addi	a0, a5, %lo(.LC4)
	call	printf

/* printf("\nSoma: %.2f\n", numero1 + numero2); */
/* Soma de doubles: fadd.d = floating point add double */
	fld	fa4, -24(s0)		/* fa4 = numero1 */
	fld	fa5, -32(s0)		/* fa5 = numero2 */
	fadd.d	fa5, fa4, fa5		/* fa5 = fa4 + fa5 (numero1 + numero2) */
	fmv.x.d	a1, fa5
	lui	a5, %hi(.LC5)
	addi	a0, a5, %lo(.LC5)
	call	printf

/* printf("\nPressione Enter para encerrar..."); */
	lui	a5, %hi(.LC6)
	addi	a0, a5, %lo(.LC6)
	call	printf

/* getchar(); */
	call	getchar

/* getchar(); */
	call	getchar

/* return 0; */
	li	a5, 0			/* Carrega imediato 0 */
	mv	a0, a5			/* a0 = retorno */

/* Epilogo */
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	addi	sp, sp, 32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
