	.file	"09_ponteiro.c"
	.text
	.p2align 4
	.globl	incrementa
	.def	incrementa;	.scl	2;	.type	32;	.endef
	.seh_proc	incrementa
incrementa:
	.seh_endprologue
	addl	$1, (%rcx)
	ret
	.seh_endproc
	.p2align 4
	.globl	usa_ponteiro
	.def	usa_ponteiro;	.scl	2;	.type	32;	.endef
	.seh_proc	usa_ponteiro
usa_ponteiro:
	.seh_endprologue
	movl	$11, %eax
	ret
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
