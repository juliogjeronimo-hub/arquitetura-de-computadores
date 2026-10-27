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
	.text
	.globl	"main"
	.def	"main";	.scl	2;	.type	32;	.endef
"main":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	call	"__main"
	lea	rax, .LC0[rip]
	mov	rcx, rax
	call	"printf"
	lea	rax, -8[rbp]
	lea	rcx, .LC1[rip]
	mov	rdx, rax
	call	"scanf"
	lea	rax, .LC2[rip]
	mov	rcx, rax
	call	"printf"
	lea	rax, -16[rbp]
	lea	rcx, .LC1[rip]
	mov	rdx, rax
	call	"scanf"
	movsd	xmm0, QWORD PTR -8[rbp]
	movapd	xmm1, xmm0
	movapd	xmm0, xmm1
	movq	rdx, xmm1
	lea	rax, .LC3[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"
	movsd	xmm0, QWORD PTR -16[rbp]
	movapd	xmm1, xmm0
	movapd	xmm0, xmm1
	movq	rdx, xmm1
	lea	rax, .LC4[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR -16[rbp]
	addsd	xmm0, xmm1
	movapd	xmm1, xmm0
	movapd	xmm0, xmm1
	movq	rdx, xmm1
	lea	rax, .LC5[rip]
	movapd	xmm1, xmm0
	mov	rcx, rax
	call	"printf"
	lea	rax, .LC6[rip]
	mov	rcx, rax
	call	"printf"
	call	"getchar"
	call	"getchar"
	mov	eax, 0
	leave
	ret
	.def	"__main";	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
	.def	"printf";	.scl	2;	.type	32;	.endef
	.def	"scanf";	.scl	2;	.type	32;	.endef
	.def	"getchar";	.scl	2;	.type	32;	.endef
