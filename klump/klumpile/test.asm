global main
extern printf

section .text
main:
	

end:

	add esp, 16
	ret


section .bss
x : resb(4)
section .data
num : dq 2.0
numTwo : dq 97.8
msg : db "%.100f", 0xA, 0
negone : dq -1.0
msgTwo : db "%s", 0xA, 0
msgThree : db "Hello, World", 0
msgFour : db "Bye, World", 0
