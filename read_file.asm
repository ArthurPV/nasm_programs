%include "base.asm"

section .data

FILENAME: db "README.md"
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

	push rax ; dword .open.file(#0) = rax

	jmp .read

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
