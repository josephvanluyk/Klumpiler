global main
extern printf

section .text
main:
	push 2
	fild dword [esp]
	sub esp, 4
	fstp qword [esp]
	push msg
	call printf
	add esp, 4

	push dword [num + 4]
	push dword [num]
	push msg
	call printf
	add esp, 4

	fld qword [esp]
	fld qword [esp + 8]
	fcom
	je	end
	push dword [num + 4]
	push dword [num]
	push msg
	call printf
	add esp, 12

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
