; %0 = rdi
; %1 = rsi
; %2 = rdx
; %3 = r10
; %4 = r8
; %5 = r9

; 1st parameter = mov rdi, <x>
; 2nd parameter = mov rsi, <x>
; 3rd parameter = mov rdx, <x>
; 4th parameter = mov r10, <x>
; 5th parameter = mov r8, <x>
; 6th parameter = mov r9, <x>
; 7th parameter = mov <reg>, [rsp]
; 8th parameter = mov <reg>, [rsp+8]

; Data types
; char = db (byte) = 1 bytes = al
; short = dw (word) = 2 bytes = ax
; int, float = dd (dword) = 4 bytes = eax
; long = dq (qword) = 8 bytes = rax
; ? = dt (tword) = 16 bytes = ?
; ? = do (oword) = 32 bytes = ?
; ? = dy (yword) = 64 bytes = ?
; ? = dz (zword) = 128 bytes = ?

section .data

SYS_READ: equ 0x00
SYS_WRITE: equ 0x01
SYS_OPEN: equ 0x02
SYS_CLOSE: equ 0x03
SYS_STAT: equ 0x04
SYS_FSTAT: equ 0x05
SYS_EXIT: equ 0x3C

STDIN: equ 0x00
STDOUT: equ 0x01
STDERR: equ 0x02

EXIT_SUCCESS: equ 0x00
EXIT_FAILED: equ 0x01

section .text

; exit(dd %0(code)) -> void
exit:
	xor rax, rax
    mov rax, SYS_EXIT
    syscall
	ret

; write(dd %0(fd), db %1(buffer), dq %2(len)) -> dd
write:
	mov rax, SYS_WRITE
	syscall
	ret
