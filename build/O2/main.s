	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "Digite o primeiro numero: \0"
.LC1:
	.ascii "%lf\0"
.LC2:
	.ascii "Digite o segundo numero: \0"
.LC3:
	.ascii "\12Primeiro numero: %.2f\12\0"
.LC4:
	.ascii "Segundo numero: %.2f\12\0"
.LC5:
	.ascii "Soma: %.2f\12\0"
	.align 8
.LC6:
	.ascii "\12Pressione Enter para encerrar...\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	"main"
	.def	"main";	.scl	2;	.type	32;	.endef
"main":
	sub	rsp, 56
	call	"__main"
	lea	rcx, .LC0[rip]
	call	"printf"
	lea	rdx, 32[rsp]
	lea	rcx, .LC1[rip]
	call	"scanf"
	lea	rcx, .LC2[rip]
	call	"printf"
	lea	rdx, 40[rsp]
	lea	rcx, .LC1[rip]
	call	"scanf"
	movsd	xmm1, QWORD PTR 32[rsp]
	lea	rcx, .LC3[rip]
	movq	rdx, xmm1
	call	"printf"
	movsd	xmm1, QWORD PTR 40[rsp]
	lea	rcx, .LC4[rip]
	movq	rdx, xmm1
	call	"printf"
	movsd	xmm1, QWORD PTR 32[rsp]
	addsd	xmm1, QWORD PTR 40[rsp]
	lea	rcx, .LC5[rip]
	movq	rdx, xmm1
	call	"printf"
	lea	rcx, .LC6[rip]
	call	"printf"
	call	"getchar"
	call	"getchar"
	xor	eax, eax
	add	rsp, 56
	ret
	.def	"__main";	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
	.def	"printf";	.scl	2;	.type	32;	.endef
	.def	"scanf";	.scl	2;	.type	32;	.endef
	.def	"getchar";	.scl	2;	.type	32;	.endef
