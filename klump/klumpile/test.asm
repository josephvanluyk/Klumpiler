global main
extern printf

section .text
main:
	movsd xmm0, [x]
	movsd xmm1, [y]

	cmpsd xmm0, xmm1, 1
	sub   esp, 8
	movsd [esp], xmm0
	add   esp, 4

	pop eax
	not eax
	cmp eax, 0
	je Equal
	jmp NotEqual

Equal:
	push false
	jmp end
NotEqual:
	push true
	jmp end
end:
	push stringFrmt
	call printf
	add esp, 8


section .bss
section .data
intFrmt : db "%d", 0xA, 0
floatFrmt : db "%f", 0xA, 0
stringFrmt : db "%s", 0xA, 0
y : dq 2.0
x : dq 1.0
true : db "True", 0xA, 0
false : db "False", 0xA, 0
