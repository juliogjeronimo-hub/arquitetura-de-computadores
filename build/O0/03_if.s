	.file	"03_if.c"
	.intel_syntax noprefix
	.text
	.globl	"maior"
	.def	"maior";	.scl	2;	.type	32;	.endef
"maior":
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR 24[rbp], edx
	mov	eax, DWORD PTR 16[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jle	.L2
	mov	eax, DWORD PTR 16[rbp]
	jmp	.L3
.L2:
	mov	eax, DWORD PTR 24[rbp]
.L3:
	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
