	.file	"01_soma.c"
	.intel_syntax noprefix
	.text
	.globl	"soma_simples"
	.def	"soma_simples";	.scl	2;	.type	32;	.endef
"soma_simples":
/* Prologo da funcao: salva frame pointer anterior e cria novo */
	push	rbp				/* Salva rbp do caller na pilha */
	mov	rbp, rsp			/* rbp = topo da pilha (novo frame) */
	sub	rsp, 16				/* Aloca 16 bytes na pilha para variaveis locais */

/* int a = 5; */
	mov	DWORD PTR -4[rbp], 5		/* a = 5 (armazena no stack em -4[rbp]) */

/* int b = 3; */
	mov	DWORD PTR -8[rbp], 3		/* b = 3 (armazena no stack em -8[rbp]) */

/* int c = a + b; */
/* Carrega valores de a e b nos registradores para somar */
	mov	edx, DWORD PTR -4[rbp]	/* edx = a */
	mov	eax, DWORD PTR -8[rbp]	/* eax = b */
	add	eax, edx				/* eax = a + b (c = 8) */
	mov	DWORD PTR -12[rbp], eax	/* c = eax (armazena resultado no stack) */

/* return c; */
	mov	eax, DWORD PTR -12[rbp]	/* eax = valor de retorno (c) */

/* Epilogo da funcao: restaura stack e retorna */
	leave				/* rsp = rbp; pop rbp (libera frame e restaura anterior) */
	ret					/* Retorna ao caller (valor em eax) */
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
