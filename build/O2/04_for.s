	.file	"04_for.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"soma_for"
	.def	"soma_for";	.scl	2;	.type	32;	.endef
"soma_for":
	test	ecx, ecx
	jle	.L4
	xor	eax, eax
	xor	edx, edx
	test	cl, 1
	je	.L3
	mov	eax, 1
	cmp	ecx, 1
	je	.L1
	.p2align 4
	.p2align 4
	.p2align 3
.L3:
	lea	edx, 1[rdx+rax*2]
	add	eax, 2
	cmp	ecx, eax
	jne	.L3
.L1:
	mov	eax, edx
	ret
	.p2align 4,,10
	.p2align 3
.L4:
	xor	edx, edx
	mov	eax, edx
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
