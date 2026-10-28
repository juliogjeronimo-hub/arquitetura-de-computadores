	.file	"04_for.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_for"
	.def	"soma_for";	.scl	2;	.type	32;	.endef
"soma_for":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	jmp	.L2
.L3:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
.L2:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L3
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
