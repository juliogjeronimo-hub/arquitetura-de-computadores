	.file	"08_recursao.c"
	.text
	.p2align 4
	.globl	fatorial
	.def	fatorial;	.scl	2;	.type	32;	.endef
	.seh_proc	fatorial
fatorial:
	.seh_endprologue
	movl	$1, %eax
	cmpl	$1, %ecx
	jle	.L1
	.p2align 4
	.p2align 4
	.p2align 3
.L2:
	imull	%ecx, %eax
	subl	$1, %ecx
	cmpl	$1, %ecx
	jne	.L2
.L1:
	ret
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
