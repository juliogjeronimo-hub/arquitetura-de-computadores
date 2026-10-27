	.file	"02_aritmetica.c"
	.intel_syntax noprefix
	.text
	.globl	"aritmetica"
	.def	"aritmetica";	.scl	2;	.type	32;	.endef

; === Função aritmetica(int x, int y) ===
"aritmetica":
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32                       ; Aloca 32 bytes para variáveis locais

; Salva parâmetros (convenção Windows x64: x em ecx, y em edx)
	mov	DWORD PTR 16[rbp], ecx       ; x = ecx em [rbp+16]
	mov	DWORD PTR 24[rbp], edx       ; y = edx em [rbp+24]

; --- s = x - y ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	sub	eax, DWORD PTR 24[rbp]       ; eax = x - y
	mov	DWORD PTR -4[rbp], eax       ; s = eax em [rbp-4]

; --- m = x * y ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	imul	eax, DWORD PTR 24[rbp]      ; eax = x * y (multiplicação com sinal)
	mov	DWORD PTR -8[rbp], eax       ; m = eax em [rbp-8]

; --- d = x / y ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x (dividendo)
	cdq                             ; Expande eax em edx:eax (prepara para divisão)
	idiv	DWORD PTR 24[rbp]           ; edx:eax / y (quociente em eax, resto em edx)
	mov	DWORD PTR -12[rbp], eax      ; d = eax (quociente) em [rbp-12]

; --- r = x % y ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	cdq                             ; Expande eax em edx:eax
	idiv	DWORD PTR 24[rbp]           ; edx:eax / y
	mov	DWORD PTR -16[rbp], edx      ; r = edx (resto) em [rbp-16]

; --- l = (x & y) | (x ^ y)  [nota: código gerou apenas OR, XOR omitido em -O0] ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	or	eax, DWORD PTR 24[rbp]        ; eax = x | y (operação OR bit a bit)
	mov	DWORD PTR -20[rbp], eax      ; l = eax em [rbp-20]

; --- sh = (x << 2) + (y >> 1) ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	lea	edx, 0[0+rax*4]             ; edx = x * 4 (equivalente a x << 2, mais eficiente)
	mov	eax, DWORD PTR 24[rbp]       ; eax = y
	sar	eax                         ; eax = y >> 1 (shift aritmético à direita)
	add	eax, edx                    ; eax = (x << 2) + (y >> 1)
	mov	DWORD PTR -24[rbp], eax      ; sh = eax em [rbp-24]

; --- Soma de todos os resultados ---
	mov	edx, DWORD PTR -4[rbp]       ; edx = s
	mov	eax, DWORD PTR -8[rbp]       ; eax = m
	add	edx, eax                    ; edx = s + m
	mov	eax, DWORD PTR -12[rbp]      ; eax = d
	add	edx, eax                    ; edx = s + m + d
	mov	eax, DWORD PTR -16[rbp]      ; eax = r
	add	edx, eax                    ; edx = s + m + d + r
	mov	eax, DWORD PTR -20[rbp]      ; eax = l
	add	edx, eax                    ; edx = s + m + d + r + l
	mov	eax, DWORD PTR -24[rbp]      ; eax = sh
	add	eax, edx                    ; eax = s + m + d + r + l + sh (valor de retorno)

	leave
	ret

; === Função dobro(int x) ===
	.globl	"dobro"
	.def	"dobro";	.scl	2;	.type	32;	.endef
"dobro":
	push	rbp
	mov	rbp, rsp
	mov	DWORD PTR 16[rbp], ecx       ; x = ecx em [rbp+16]

; --- Retorna x * 2 ---
	mov	eax, DWORD PTR 16[rbp]       ; eax = x
	add	eax, eax                    ; eax = x + x (equivalente a x * 2)

	pop	rbp
	ret
	.ident	"GCC: (Rev4, Built by MSYS2 project) 16.2.0"
