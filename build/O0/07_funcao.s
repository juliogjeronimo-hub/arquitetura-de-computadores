	.file	"07_funcao.c"
	.text
	.globl	soma

; int soma(int a, int b) {
soma:
	pushq	%rbp
	movq	%rsp, %rbp

; === Prólogo e parâmetros ===
	movl	%ecx, 16(%rbp)    ; a = ecx em [rbp+16]
	movl	%edx, 24(%rbp)    ; b = edx em [rbp+24]

; === return a + b ---
	movl	16(%rbp), %edx    ; edx = a
	movl	24(%rbp), %eax    ; eax = b
	addl	%edx, %eax        ; eax = a + b (valor de retorno)

; === Epílogo ===
	popq	%rbp
	ret

	.globl	chamada

; int chamada(void) {
chamada:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp         ; Aloca 32 bytes (shadow space)

; === return soma(4, 6) ---
	movl	$6, %edx          ; 2º argumento: b = 6 em edx
	movl	$4, %ecx          ; 1º argumento: a = 4 em ecx
	call	soma              ; Chama soma(4, 6), resultado em eax

; === Retorno ===
	addq	$32, %rsp
	popq	%rbp
	ret
