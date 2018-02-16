global main
extern printf

section .text
main:
	push 100
	push msg
	call printf
	pop eax
	pop eax
	ret

section .bss
section .data
msg : db "%d", 0xA, 0
