	.file	"05_while.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"soma_while"
	.def	"soma_while";	.scl	2;	.type	32;	.endef
"soma_while":
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
	.p2align 4
	.globl	"soma_dowhile"
	.def	"soma_dowhile";	.scl	2;	.type	32;	.endef
"soma_dowhile":
	mov	eax, 1
	lea	r8d, -1[rcx]
	xor	edx, edx
	cmp	eax, ecx
	jge	.L21
	and	r8d, 1
	je	.L13
	mov	eax, 2
	mov	edx, 1
	cmp	eax, ecx
	jge	.L21
	.p2align 4
	.p2align 4
	.p2align 3
.L13:
	lea	edx, 1[rdx+rax*2]
	add	eax, 2
	cmp	eax, ecx
	jl	.L13
.L21:
	mov	eax, edx
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
