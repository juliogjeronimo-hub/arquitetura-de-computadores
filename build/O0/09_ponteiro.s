	.file	"09_ponteiro.c"
	.text
	.globl	incrementa
	.def	incrementa;	.scl	2;	.type	32;	.endef
	.seh_proc	incrementa
incrementa:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movq	16(%rbp), %rax
	movl	(%rax), %eax
	leal	1(%rax), %edx
	movq	16(%rbp), %rax
	movl	%edx, (%rax)
	nop
	popq	%rbp
	ret
	.seh_endproc
	.globl	usa_ponteiro
	.def	usa_ponteiro;	.scl	2;	.type	32;	.endef
	.seh_proc	usa_ponteiro
usa_ponteiro:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$10, -4(%rbp)
	leaq	-4(%rbp), %rax
	movq	%rax, %rcx
	call	incrementa
	movl	-4(%rbp), %eax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
