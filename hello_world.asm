%include "base.asm"

section .data

BUFFER: db "Hello, World!", 10
BUFFER_LEN: equ $-BUFFER

section .text

global _start

_start:
	call main

main:
	mov rdi, STDOUT
	mov rsi, BUFFER,
	mov rdx, BUFFER_LEN
	call write

	jmp .exit

.exit:
	mov rdi, EXIT_SUCCESS
	call exit
