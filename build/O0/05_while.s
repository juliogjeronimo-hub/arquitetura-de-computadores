	.file	"05_while.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_while"
	.def	"soma_while";	.scl	2;	.type	32;	.endef
"soma_while":
/* Prologo da funcao */
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16				/* Aloca 16 bytes no stack */

/* int soma_while(int n) { */
/* Parametro n em ecx */
	mov	DWORD PTR 16[rbp], ecx		/* Salva n */

/* int soma = 0; */
	mov	DWORD PTR -4[rbp], 0		/* soma = 0 */

/* int i = 0; */
	mov	DWORD PTR -8[rbp], 0		/* i = 0 */

/* while (i < n) { */
/* Pula para condicao do loop (primeira verificacao) */
	jmp	.L2

/* Corpo do loop (executa pelo menos uma vez se condicao verdadeira) */
.L3:
/* soma += i; */
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	add	DWORD PTR -4[rbp], eax		/* soma = soma + i */

/* i++; */
	add	DWORD PTR -8[rbp], 1		/* i = i + 1 */

/* Condicao: i < n */
.L2:
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	cmp	eax, DWORD PTR 16[rbp]		/* Compara i com n */

/* Se i < n, executa corpo novamente */
	jl	.L3				/* if (i < n) goto .L3 */

/* return soma; */
	mov	eax, DWORD PTR -4[rbp]		/* eax = soma */

/* Epilogo */
	leave
	ret

/* int soma_dowhile(int n) { */
	.globl	"soma_dowhile"
	.def	"soma_dowhile";	.scl	2;	.type	32;	.endef
"soma_dowhile":
/* Prologo da funcao */
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16				/* Aloca 16 bytes no stack */

/* Parametro n em ecx */
	mov	DWORD PTR 16[rbp], ecx		/* Salva n */

/* int soma = 0; */
	mov	DWORD PTR -4[rbp], 0		/* soma = 0 */

/* int i = 0; */
	mov	DWORD PTR -8[rbp], 0		/* i = 0 */

/* do { */
/* Corpo executa ANTES da verificacao (diferenca do while) */
.L6:
/* soma += i; */
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	add	DWORD PTR -4[rbp], eax		/* soma = soma + i */

/* i++; */
	add	DWORD PTR -8[rbp], 1		/* i = i + 1 */

/* } while (i < n); */
/* Verificacao apos o corpo */
	mov	eax, DWORD PTR -8[rbp]		/* eax = i */
	cmp	eax, DWORD PTR 16[rbp]		/* Compara i com n */

/* Se i < n, repete o loop */
	jl	.L6				/* if (i < n) goto .L6 */

/* return soma; */
	mov	eax, DWORD PTR -4[rbp]		/* eax = soma */

/* Epilogo */
	leave
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
