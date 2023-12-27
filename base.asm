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

EOF: equ 0x00 ; '\0'

section .text

; exit(dd %0(code)) -> void
exit:
	xor rax, rax
    mov eax, SYS_EXIT
    syscall
	ret

; read(dd %0(fd), db %1(buffer), dq %2(len)) -> dd
read:
	mov eax, SYS_READ
	syscall
	ret

; write(dd %0(fd), db %1(buffer), dq %2(len)) -> dd
write:
	mov eax, SYS_WRITE
	syscall
	ret

; len__Str(db %0(buffer)) -> dq
len__Str:
	push qword 0 ; qword str.len.count(#0) = 0
	mov rdx, rdi ; save rdi address
	jmp .cond

.cond:
	add rdi, [rsp] ; forward to rdi+str.len.count(#0) address
	cmp byte [rdi], EOF ; verify if the rdi value is not equal to EOF
	jne .loop
	jmp .exit

.loop:
	mov rdi, rdx ; restore rdi address
	inc qword [rsp] ; ++str.len.count(#0)
	jmp .cond

.exit:
	pop qword rax ; rax = str.len.count(#0)
	ret
