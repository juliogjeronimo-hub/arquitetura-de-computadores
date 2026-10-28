	.file	"02_aritmetica.c"
	.intel_syntax noprefix
	.text
	.globl	"aritmetica"
	.def	"aritmetica";	.scl	2;	.type	32;	.endef
"aritmetica":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR 24[rbp], edx
	mov	eax, DWORD PTR 16[rbp]
	sub	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	imul	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	cdq
	idiv	DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	cdq
	idiv	DWORD PTR 24[rbp]
	mov	DWORD PTR -16[rbp], edx
	mov	eax, DWORD PTR 16[rbp]
	or	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR 16[rbp]
	lea	edx, 0[0+rax*4]
	mov	eax, DWORD PTR 24[rbp]
	sar	eax
	add	eax, edx
	mov	DWORD PTR -24[rbp], eax
	mov	edx, DWORD PTR -4[rbp]
	mov	eax, DWORD PTR -8[rbp]
	add	edx, eax
	mov	eax, DWORD PTR -12[rbp]
	add	edx, eax
	mov	eax, DWORD PTR -16[rbp]
	add	edx, eax
	mov	eax, DWORD PTR -20[rbp]
	add	edx, eax
	mov	eax, DWORD PTR -24[rbp]
	add	eax, edx
	leave
	ret
	.globl	"dobro"
	.def	"dobro";	.scl	2;	.type	32;	.endef
"dobro":
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR 16[rbp], ecx
	mov	eax, DWORD PTR 16[rbp]
	add	eax, eax
	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
