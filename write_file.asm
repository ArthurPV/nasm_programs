%include "base.asm"

section .data

FILE_CONTENT: db "Write from ASM", 10
FILE_CONTENT_LEN: equ $-FILE_CONTENT

MSG_ERROR: db "error: unable to write file", 10
MSG_ERROR_LEN: equ $-MSG_ERROR

FILENAME: db "tmp/file.txt"

section .text

global _start

_start:
	call main

main:
	jmp .open

.open:
	mov rdi, FILENAME
	mov esi, O_WRONLY
	mov edx, S_IRWXU
	call open

	cmp rax, 0 ; check if rax is less than 0
	jl .error
	push rax
	jmp .write

.error:
	mov edi, STDOUT
	mov rsi, MSG_ERROR
	mov edx, MSG_ERROR_LEN
	call write

	mov edi, EXIT_FAILED
	call exit

.write:
	mov rdi, [rsp]
	mov rsi, FILE_CONTENT
	mov rdx, FILE_CONTENT_LEN
	call write

	jmp .close

.close:
	mov rdi, [rsp]
	call close

	add rsp, 8 ; clear 8 bytes

	jmp .exit

.exit:
	mov edi, EXIT_SUCCESS
	call exit
