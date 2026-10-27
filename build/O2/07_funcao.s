	.file	"07_funcao.c"
	.text
	.p2align 4
	.globl	soma
	.def	soma;	.scl	2;	.type	32;	.endef
	.seh_proc	soma
soma:
	.seh_endprologue
	leal	(%rcx,%rdx), %eax
	ret
	.seh_endproc
	.p2align 4
	.globl	chamada
	.def	chamada;	.scl	2;	.type	32;	.endef
	.seh_proc	chamada
chamada:
	.seh_endprologue
	movl	$10, %eax
	ret
	.seh_endproc
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
