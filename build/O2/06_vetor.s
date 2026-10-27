	.file	"06_vetor.c"
	.text
	.p2align 4
	.globl	soma_vetor
	.def	soma_vetor;	.scl	2;	.type	32;	.endef
	.seh_proc	soma_vetor
soma_vetor:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movq	.LC0(%rip), %xmm0
	movq	.LC1(%rip), %xmm2
	movq	%rsp, %rax
	leaq	40(%rsp), %rdx
.L2:
	movdqa	%xmm0, %xmm1
	addq	$8, %rax
	paddd	%xmm2, %xmm0
	pslld	$1, %xmm1
	movq	%xmm1, -8(%rax)
	cmpq	%rdx, %rax
	jne	.L2
	movdqu	16(%rsp), %xmm0
	paddd	(%rsp), %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$8, %xmm1
	paddd	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	paddd	%xmm1, %xmm0
	movd	%xmm0, %eax
	addl	32(%rsp), %eax
	addl	36(%rsp), %eax
	addq	$56, %rsp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	0
	.long	1
	.align 8
.LC1:
	.long	2
	.long	2
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
