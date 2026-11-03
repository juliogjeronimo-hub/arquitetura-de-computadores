	.file	"01_soma.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	soma_simples
	.type	soma_simples, @function
soma_simples:
/* Prologo da funcao: aloca espaco no stack e salva registradores */
	addi	sp, sp, -32			/* Aloca 32 bytes no stack (sp decrece) */
	sd	ra, 24(sp)			/* Salva ra (endereco de retorno) no stack */
	sd	s0, 16(sp)			/* Salva s0 (frame pointer) no stack */
	addi	s0, sp, 32			/* s0 = topo do frame (base para accessos) */

/* int a = 5; */
	li	a5, 5				/* Carrega imediato 5 em a5 */
	sw	a5, -20(s0)			/* a = 5 (armazena no stack em offset -20 de s0) */

/* int b = 3; */
	li	a5, 3				/* Carrega imediato 3 em a5 */
	sw	a5, -24(s0)			/* b = 3 (armazena no stack em offset -24 de s0) */

/* int c = a + b; */
/* Carrega valores de a e b */
	lw	a5, -20(s0)			/* a5 = valor de a */
	mv	a4, a5				/* a4 = a5 (copia para registrador temporario) */
	lw	a5, -24(s0)			/* a5 = valor de b */
	addw	a5, a4, a5			/* a5 = a4 + a5 (a + b = 8), extensao de sinal implicita */
	sw	a5, -28(s0)			/* c = a5 (armazena resultado no stack) */

/* return c; */
	lw	a5, -28(s0)			/* Carrega valor de c */
	mv	a0, a5				/* a0 = valor de retorno (chamada por convencao) */

/* Epilogo da funcao: restaura stack e registradores */
	ld	ra, 24(sp)			/* Restaura ra */
	ld	s0, 16(sp)			/* Restaura s0 */
	addi	sp, sp, 32			/* Desaloca espaco do stack */
	jr	ra					/* Jump to ra (retorna ao caller) */
	.size	soma_simples, .-soma_simples
	.ident	"GCC: (GNU) 16.1.0"
	.section	.note.GNU-stack,"",@progbits
