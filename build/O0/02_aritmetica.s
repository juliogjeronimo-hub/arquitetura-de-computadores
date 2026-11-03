	.file	"02_aritmetica.c"
	.intel_syntax noprefix
	.text
	.globl	"aritmetica"
	.def	"aritmetica";	.scl	2;	.type	32;	.endef
"aritmetica":
/* Prologo da funcao */
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32				/* Aloca 32 bytes para variaveis locais */

/* int aritmetica(int x, int y) { */
/* Parametros x (ecx) e y (edx) sao recebidos via registradores. */
/* Os armazenamos no stack para preservar (x86-64 System V: ecx=arg1, edx=arg2) */
	mov	DWORD PTR 16[rbp], ecx	/* x = ecx (armazena no stack em 16[rbp]) */
	mov	DWORD PTR 24[rbp], edx	/* y = edx (armazena no stack em 24[rbp]) */

/* int s = x - y; */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	sub	eax, DWORD PTR 24[rbp]	/* eax = x - y */
	mov	DWORD PTR -4[rbp], eax	/* s = eax */

/* int m = x * y; */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	imul	eax, DWORD PTR 24[rbp]	/* eax = x * y (multiplicacao com sinal) */
	mov	DWORD PTR -8[rbp], eax	/* m = eax */

/* int d = x / y; */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	cdq					/* estende eax para edx:eax (prepara para idiv) */
	idiv	DWORD PTR 24[rbp]	/* eax = x / y, edx = x % y */
	mov	DWORD PTR -12[rbp], eax	/* d = eax */

/* int r = x % y; */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	cdq					/* estende eax para edx:eax */
	idiv	DWORD PTR 24[rbp]	/* eax = x / y, edx = x % y */
	mov	DWORD PTR -16[rbp], edx	/* r = edx (resto da divisao) */

/* int l = (x & y) | (x ^ y); */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	or	eax, DWORD PTR 24[rbp]	/* eax = x | y - NOTE: GCC otimizou para apenas OR */
	mov	DWORD PTR -20[rbp], eax	/* l = eax */

/* int sh = (x << 2) + (y >> 1); */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	lea	edx, 0[0+rax*4]		/* edx = x * 4 (shift left por 2 usando lea) */
	mov	eax, DWORD PTR 24[rbp]	/* eax = y */
	sar	eax				/* eax = y >> 1 (shift aritmetico com sinal) */
	add	eax, edx			/* eax = (x*4) + (y/2) */
	mov	DWORD PTR -24[rbp], eax	/* sh = eax */

/* return s + m + d + r + l + sh; */
/* Soma acumulada em edx */
	mov	edx, DWORD PTR -4[rbp]	/* edx = s */
	mov	eax, DWORD PTR -8[rbp]	/* eax = m */
	add	edx, eax			/* edx = s + m */
	mov	eax, DWORD PTR -12[rbp]	/* eax = d */
	add	edx, eax			/* edx = s + m + d */
	mov	eax, DWORD PTR -16[rbp]	/* eax = r */
	add	edx, eax			/* edx = s + m + d + r */
	mov	eax, DWORD PTR -20[rbp]	/* eax = l */
	add	edx, eax			/* edx = s + m + d + r + l */
	mov	eax, DWORD PTR -24[rbp]	/* eax = sh */
	add	eax, edx			/* eax = soma_total */

/* Epilogo da funcao */
	leave
	ret

/* int dobro(int x) { */
	.globl	"dobro"
	.def	"dobro";	.scl	2;	.type	32;	.endef
"dobro":
/* Prologo simplificado - sem variaveis locais */
	push	rbp
	mov	rbp, rsp

/* return x * 2; */
/* Parametro x em ecx */
	mov	DWORD PTR 16[rbp], ecx	/* Salva x no stack (padrao) */
	mov	eax, DWORD PTR 16[rbp]	/* eax = x */
	add	eax, eax			/* eax = x + x (multiplicacao por 2) */

/* Epilogo */
	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
