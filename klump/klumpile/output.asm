               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 12             
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label0:                                      	;Begin compiling for expression
               push      10                  	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label1              
               push      dword [ebp - 4]     	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label2:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label0              
Label1:                                      	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
               push      10                  	;Push int literal to stack
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label3:                                      	;Begin compiling for expression
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jl        Label4              
               push      dword [ebp - 8]     	;Push local var to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               cdq                           	;Sign extend eax
               idiv      ebx                 	;Divide operands
               mov       eax, edx            	;Move modulo result to eax
               push      eax                 	;Push result to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label6              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label7              	;Skip pushing 1
Label6:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label7:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label8              	;If bool is 0, jump to the else clause
               jmp       Label5              	;Jump to top of loop
               jmp       Label9              	;Skip the else clause
Label8:                                      	;Beginning of else clause
Label9:                                      	;End of else clause
               push      dword [ebp - 8]     	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label5:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               dec       eax                 	;Decrmeent Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label3              
Label4:                                      	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
Exit_main:                                   
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
