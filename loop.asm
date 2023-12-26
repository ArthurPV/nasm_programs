%include "base.asm"

section .data

BUFFER: db "Hello", 10
BUFFER_LEN: equ $-BUFFER

section .text

global _start

_start:
	call main

main:	
	push dword 0 ; dword main.i(#0) = 0
	jmp .cond 

.cond:
	mov rdi, 0xA
	cmp [rsp], rdi
	jl .loop 
	add rsp, 8 ; clear stack (8 bytes)
	jmp .exit 

.loop:
	mov rdi, STDOUT ; %0
	mov rsi, BUFFER ; %1
	mov rdx, BUFFER_LEN ; %2
	call write

	inc dword [rsp] ; ++main.i(#0)

	jmp .cond 

.exit:
	mov edi, EXIT_SUCCESS ; %0
    call exit
