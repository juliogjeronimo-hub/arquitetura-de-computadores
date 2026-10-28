	.file	"06_vetor.c"
	.text
	.globl	soma_vetor

; int soma_vetor(void) {
soma_vetor:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp          ; Aloca 64 bytes: v[10] (40 bytes) + variáveis

; === for (int i = 0; i < 10; i++) ===
	movl	$0, -4(%rbp)      ; i = 0 em [rbp-4]
	jmp	.L2

; --- Corpo do loop: v[i] = i * 2 ---
.L3:
	movl	-4(%rbp), %eax    ; eax = i
	leal	(%rax,%rax), %edx ; edx = i * 2 (LEA: edx = rax + rax)
	movl	-4(%rbp), %eax    ; eax = i
	cltq                    ; Expande eax de 32 para 64 bits em rax
	movl	%edx, -64(%rbp,%rax,4)  ; v[i] = i*2 (indexação: [rbp-64 + i*4])
	addl	$1, -4(%rbp)      ; i++

; --- Teste do loop: i < 10 ---
.L2:
	cmpl	$9, -4(%rbp)      ; Compara i com 9
	jle	.L3               ; Se i <= 9, volta (.L3)

; === for (int i = 0; i < 10; i++) soma += v[i] ===
	movl	$0, -8(%rbp)      ; soma = 0 em [rbp-8]
	movl	$0, -12(%rbp)     ; i = 0 em [rbp-12]
	jmp	.L4

; --- Corpo do loop: soma += v[i] ---
.L5:
	movl	-12(%rbp), %eax   ; eax = i
	cltq                    ; Expande eax em rax (64 bits)
	movl	-64(%rbp,%rax,4), %eax  ; eax = v[i]
	addl	%eax, -8(%rbp)    ; soma += v[i]
	addl	$1, -12(%rbp)     ; i++

; --- Teste do loop: i < 10 ---
.L4:
	cmpl	$9, -12(%rbp)     ; Compara i com 9
	jle	.L5               ; Se i <= 9, volta (.L5)

; === return soma ---
	movl	-8(%rbp), %eax    ; eax = soma (valor de retorno)
	addq	$64, %rsp
	popq	%rbp
	ret
