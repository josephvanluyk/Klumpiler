               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 0              
               push      8                   	;Push int literal to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               push      1                   	;Push int literal to stack
               pop       dword [_fact_]      	;Pop top of stack to memory location
               call      Entry_factorial     
               push      dword [_fact_]      	;Push global var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_factorial:                              
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 4              
               push      dword [_n_]         	;Push global var to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label0              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label1              	;Skip pushing 1
Label0:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label1:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label2              	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               pop       dword [_fact_]      	;Pop top of stack to memory location
               jmp       Label3              	;Skip the else clause
Label2:                                      	;Beginning of else clause
               push      dword [_n_]         	;Push global var to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
               push      dword [_n_]         	;Push global var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               call      Entry_factorial     
               push      dword [_fact_]      	;Push global var to stack
               push      dword [ebp - 4]     	;Push local var to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               pop       dword [_fact_]      	;Pop top of stack to memory location
Label3:                                      	;End of else clause
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
                                             
               section   .data               
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
realFrmtIn:    db        "%lf", 0            	;Read real
intFrmtIn:     db        "%i", 0             	;Read int
stringFrmtIn:  db        "%s", 0             	;Read string
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -1.0                	;Negative one
                                             
               section   .bss                
_n_:           resb(4)                       
_fact_:        resb(4)                       
