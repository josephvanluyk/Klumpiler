global main
extern printf

section .text
main:

    mov eax, [x + 50]
    ;push eax
    ;push intFrmt
    ;call printf
    ;add esp, 8

section .bss
x : resb(4)

section .data

;intFrmt : db "%d", 0xA, 0
