	.file	"08_recursao.c"
	.text
	.globl	fatorial

; int fatorial(int n) {
fatorial:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp         ; Aloca 32 bytes (shadow space)

; === Parâmetro ===
	movl	%ecx, 16(%rbp)    ; n = ecx em [rbp+16]

; === if (n <= 1) ---
	cmpl	$1, 16(%rbp)      ; Compara n com 1
	jg	.L2                ; Se n > 1, pula para .L2 (caso recursivo)

; === Caso base: return 1 ---
	movl	$1, %eax          ; eax = 1
	jmp	.L3               ; Pula para fim (.L3)

; === Caso recursivo: return n * fatorial(n - 1) ---
.L2:
	movl	16(%rbp), %eax    ; eax = n
	subl	$1, %eax          ; eax = n - 1
	movl	%eax, %ecx        ; ecx = n - 1 (1º argumento para chamada recursiva)
	call	fatorial          ; Chama fatorial(n - 1), resultado em eax
	imull	16(%rbp), %eax    ; eax = fatorial(n-1) * n

; === Retorno ===
.L3:
	addq	$32, %rsp
	popq	%rbp
	ret
