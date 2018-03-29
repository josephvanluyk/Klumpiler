               global    main
               extern    printf
               extern    scanf
               extern    getchar
               section   .text
main:
Entry_main:

    push    dword [negone + 4]
    push    dword [negone]
    movsd   xmm0, [esp]
    cvtsd2si eax, xmm0
    push    eax
    push    intFrmt
    call    printf
    add     esp, 16
    push    NewLine
    call    printf
    add     esp, 4




               section   .data
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
realFrmtIn:    db        "%lf", 0            	;Read real
intFrmtIn:     db        "%i", 0             	;Read int
stringFrmtIn:  db        "%s", 0             	;Read string
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -3.6                	;Negative one
Label7:        db        "Worked", 0
Label8:        db        "Didnt work", 0

               section   .bss
