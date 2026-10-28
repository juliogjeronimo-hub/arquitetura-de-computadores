	.file	"01_soma.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_simples"
	.def	"soma_simples";	.scl	2;	.type	32;	.endef
"soma_simples":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR -4[rbp], 5
	mov	DWORD PTR -8[rbp], 3
	mov	edx, DWORD PTR -4[rbp]
	mov	eax, DWORD PTR -8[rbp]
	add	eax, edx
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
