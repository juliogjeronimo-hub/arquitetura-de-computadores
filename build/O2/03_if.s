	.file	"03_if.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"maior"
	.def	"maior";	.scl	2;	.type	32;	.endef
"maior":
	cmp	ecx, edx
	mov	eax, edx
	cmovge	eax, ecx
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
