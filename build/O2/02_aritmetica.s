	.file	"02_aritmetica.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"aritmetica"
	.def	"aritmetica";	.scl	2;	.type	32;	.endef
"aritmetica":
	mov	eax, ecx
	mov	r8d, ecx
	mov	r10d, ecx
	mov	r9d, edx
	imul	r10d, edx
	sub	r8d, edx
	cdq
	idiv	r9d
	add	r8d, r10d
	add	r8d, eax
	mov	eax, ecx
	add	r8d, edx
	or	eax, r9d
	sar	r9d
	add	eax, r8d
	lea	edx, [r9+rcx*4]
	add	eax, edx
	ret
	.p2align 4
	.globl	"dobro"
	.def	"dobro";	.scl	2;	.type	32;	.endef
"dobro":
	lea	eax, [rcx+rcx]
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
