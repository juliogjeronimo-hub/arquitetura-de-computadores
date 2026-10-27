	.file	"06_vetor.c"
	.text
	.globl	soma_vetor
	.def	soma_vetor;	.scl	2;	.type	32;	.endef
	.seh_proc	soma_vetor
soma_vetor:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	leal	(%rax,%rax), %edx
	movl	-4(%rbp), %eax
	cltq
	movl	%edx, -64(%rbp,%rax,4)
	addl	$1, -4(%rbp)
.L2:
	cmpl	$9, -4(%rbp)
	jle	.L3
	movl	$0, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L4
.L5:
	movl	-12(%rbp), %eax
	cltq
	movl	-64(%rbp,%rax,4), %eax
	addl	%eax, -8(%rbp)
	addl	$1, -12(%rbp)
.L4:
	cmpl	$9, -12(%rbp)
	jle	.L5
	movl	-8(%rbp), %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
