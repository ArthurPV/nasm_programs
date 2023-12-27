%include "base.asm"

section .data

BUFFER_INPUT_LEN: dq 20
BUFFER_WRITE: db "What's your name: "
BUFFER_WRITE_LEN: equ $-BUFFER_WRITE

BUFFER_ANSWER: db "Your name is "
BUFFER_ANSWER_LEN: equ $-BUFFER_ANSWER

ERROR_MSG: db "error: the input is too long", 10
ERROR_MSG_LEN: equ $-ERROR_MSG

section .bss

buffer_input: resb 20

section .text

global _start

_start:
	call main

main:
	jmp .input

.input:
	mov edi, STDOUT ; %0
	mov rsi, BUFFER_WRITE ; %1
	mov rdx, BUFFER_WRITE_LEN ; %2
	call write

	mov edi, STDIN ; %0
	mov rsi, buffer_input ; %1
	mov rdx, [BUFFER_INPUT_LEN] ; %2
	call read

	jmp .display_name

.display_name:
	mov edi, STDOUT ; %0
	mov rsi, BUFFER_ANSWER ; %1
	mov rdx, BUFFER_ANSWER_LEN ; %2
	call write

	mov edi, STDOUT ; %0
	mov rsi, buffer_input ; %1
	mov rdx, [BUFFER_INPUT_LEN] ; %2
	call write

	jmp .exit

.exit:
	mov edi, EXIT_SUCCESS ; %0
	call exit
