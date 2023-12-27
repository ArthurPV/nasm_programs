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

O_RDONLY: equ 0x0000000
O_WRONLY: equ 0x0000001
O_RDWR: equ 0x0000002
O_ACCMODE: equ 0x0000003
O_CREAT: equ 0x0000064
O_EXCL: equ 0x00000C8
O_NOCTTY: equ 0x0000190
O_TRUNC: equ 0x00003E8
O_APPEND: equ 0x00007D0
O_NONBLOCK: equ 0x0000FA0
O_DSYNC: equ 0x0002710
FASYNC: equ 0x0004E20
O_DIRECT: equ 0x0009C40
O_LARGEFILE: equ 0x00186A0
O_DIRECTORY: equ 0x0030D40
O_NOFOLLOW: equ 0x0061A80
O_NOATIME: equ 0x00F4240
O_CLOEXEC: equ 0x01E8480

S_IRUSR: equ 1 << 8 ; R for owner
S_IWUSR: equ 1 << 7 ; W for owner
S_IXUSR: equ 1 << 6 ; X for owner
S_IRWXU: equ S_IRUSR | S_IWUSR | S_IXUSR ; RWX mask for owner

S_IRGRP: equ 1 << 5 ; R for group
S_IWGRP: equ 1 << 4 ; W for group
S_IXGRP: equ 1 << 3 ; X for group
S_IRWXG: equ S_IRGRP | S_IWGRP | S_IXGRP ; RWX mask for group

S_IROTH: equ 1 << 2 ; R for other
S_IWOTH: equ 1 << 1 ; W for other
S_IXOTH: equ 1 << 0 ; X for other
S_IRWXO: equ S_IROTH | S_IWOTH | S_IXOTH ; RWX mask for other

S_ISUID: equ 0xFA0 ; set user id on execution
S_ISGID: equ 0x7D0 ; set group id on execution
S_ISVTX: equ 0x3E8 ; save swapped text even after use

STDIN: equ 0x00 ; standard input
STDOUT: equ 0x01 ; standard output
STDERR: equ 0x02 ; standard error

EXIT_SUCCESS: equ 0x00
EXIT_FAILED: equ 0x01

EOF: equ 0x00 ; '\0'

section .text

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

; open(db %0(filename), dd %1(flags), dd %2(mode)) -> dd
open:
	mov eax, SYS_OPEN
	syscall
	ret

; close(dd %0(fd)) -> dd
close:
	mov eax, SYS_CLOSE
	syscall
	ret

; exit(dd %0(code)) -> void
exit:
	xor rax, rax
    mov eax, SYS_EXIT
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
