	.file	"05_while.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_while"
	.def	"soma_while";	.scl	2;	.type	32;	.endef
"soma_while":
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
	.globl	"soma_dowhile"
	.def	"soma_dowhile";	.scl	2;	.type	32;	.endef
"soma_dowhile":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
.L6:
	mov	eax, DWORD PTR -8[rbp]
	add	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 16[rbp]
	jl	.L6
	mov	eax, DWORD PTR -4[rbp]
	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
