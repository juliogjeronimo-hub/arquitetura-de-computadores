	.file	"09_ponteiro.c"
	.text
	.globl	incrementa

; void incrementa(int *p) {
incrementa:
	pushq	%rbp
	movq	%rsp, %rbp

; === Parâmetro ===
	movq	%rcx, 16(%rbp)    ; p = rcx (ponteiro) em [rbp+16]

; === *p = *p + 1 ---
	movq	16(%rbp), %rax    ; rax = p (carrega o ponteiro)
	movl	(%rax), %eax      ; eax = *p (desreferencia: carrega valor apontado)
	leal	1(%rax), %edx     ; edx = *p + 1
	movq	16(%rbp), %rax    ; rax = p (recarrega o ponteiro)
	movl	%edx, (%rax)      ; *p = edx (escreve novo valor no endereço)

; === Retorno ===
	nop
	popq	%rbp
	ret

	.globl	usa_ponteiro

; int usa_ponteiro(void) {
usa_ponteiro:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp         ; Aloca 48 bytes

; === int x = 10 ---
	movl	$10, -4(%rbp)     ; x = 10 em [rbp-4]

; === incrementa(&x) ---
	leaq	-4(%rbp), %rax    ; rax = &x (carrega endereço de x)
	movq	%rax, %rcx        ; rcx = &x (1º argumento)
	call	incrementa        ; Chama incrementa(&x), x agora = 11

; === return x ---
	movl	-4(%rbp), %eax    ; eax = x (valor de retorno = 11)

; === Retorno ===
	addq	$48, %rsp
	popq	%rbp
	ret
