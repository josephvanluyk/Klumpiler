global main
extern printf

section .text
main:
    mov eax, -1
    mov ebx, 3
    cdq
    idiv ebx
    push edx
    push intFrmt
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
