global main
extern printf

section .text
main:
	push dword [num + 4];
	push dword [num]

	movsd xmm0, [esp]
	movsd xmm1, [negone]

	mulsd xmm0, xmm1

	movsd [esp], xmm0



	push msg
	call printf
	add esp, 12
	ret


section .bss
section .data
num : dq 101.1
msg : db "%f", 0xA, 0
negone : dq -1.0
