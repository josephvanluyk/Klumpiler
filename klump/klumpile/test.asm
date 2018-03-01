global main
extern printf

section .text
main:
	fld dword [num]
	sub esp, 8
	fstp qword [esp]
	push msg
	call printf
	add esp, 12
	ret

section .bss
section .data
num : dd 101.1
msg : db "%f", 0xA, 0
