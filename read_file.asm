%include "base.asm"

section .data

MSG_ERROR: db "error: unable to read file", 10
FILENAME: db "README.md"

MSG_ERROR_LEN: equ $-MSG_ERROR
FILENAME_LEN: equ $-FILENAME
FILE_CONTENT_BUFFER_LEN: equ 1000

section .bss

file_content_buffer: resb FILE_CONTENT_BUFFER_LEN

section .text

global _start

_start:
	call main

main:
	jmp .open

.open:
	mov rdi, FILENAME
	mov esi, O_RDONLY
	mov edx, S_IRWXU
	call open

	cmp rax, 0 ; check if rax is less than 0
	jl .error
	push rax ; dword .open.file(#0) = rax
	jmp .read

.error:
	mov edi, STDOUT
	mov rsi, MSG_ERROR
	mov rdx, MSG_ERROR_LEN
	call write

	mov edi, EXIT_FAILED
	call exit

.read:
	mov rdi, [rsp]
	mov rsi, file_content_buffer
	mov edx, FILE_CONTENT_BUFFER_LEN
	call read

	jmp .close

.close:
	mov rdi, [rsp]
	call close

	add rsp, 8 ; clear 8 bytes

	jmp .display_file_content

.display_file_content:
	mov rdi, STDOUT
	mov rsi, file_content_buffer
	mov edx, FILE_CONTENT_BUFFER_LEN
	call write

	jmp .exit

.exit:
	mov edi, EXIT_SUCCESS
	call exit
