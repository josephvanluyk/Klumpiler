               global    main                
               extern    printf              
               section   .text               
main:                                        
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               pop       dword [_a_]         	;Assign first half of real to const variable
               pop       dword [_a_ + 4]     
               push      Label1              	;Push address of string literal to stack
               pop       dword [_b_]         	;Assign string address to const variable
               push      2                   	;Push int literal to stack
               pop       dword [_c_]         	;Assign int value to const variable
               push      2                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               pop       dword [_x_]         	;Pop top of stack to memory location
               push      3                   	;Push int literal to stack
               pop       dword [_y_]         	;Pop top of stack to memory location
               push      4                   	;Push int literal to stack
               push      dword [_x_]         	;Push identifier to stack
               push      dword [_y_]         	;Push identifier to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               pop       dword [_x_]         	;Pop top of stack to memory location
               push      dword [_x_]         	;Push identifier to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_y_]         	;Push identifier to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_b_]         	;Push identifier to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
                                             
               section   .data               
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -1.0                	;Negative one
Label0:        dq        1.3                 
Label1:        db        'this is a string'  
                                             
               section   .bss                
_a_:           resb(8)                       
_b_:           resb(4)                       
_c_:           resb(4)                       
_x_:           resb(4)                       
_y_:           resb(4)                       
