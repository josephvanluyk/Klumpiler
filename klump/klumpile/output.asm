               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 4              
               push      0                   	;Push int literal to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
Label0:                                      	;Start of while loop
               push      dword [ebp - 4]     	;Push local var to stack
               push      10                  	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label2              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label3              	;Skip pushing 1
Label2:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label3:                                      	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label1              	;If comparison is false, jump to end
               push      dword [ebp - 4]     	;Push local var to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label4              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label5              	;Skip pushing 1
Label4:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label5:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label6              	;If bool is 0, jump to the else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
               jmp       Label0              	;Jump to top of loop
               jmp       Label7              	;Skip the else clause
Label6:                                      	;Beginning of else clause
Label7:                                      	;End of else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      8                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label8              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label9              	;Skip pushing 1
Label8:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label9:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label10             	;If bool is 0, jump to the else clause
               jmp       Label1              	;Jump to end of loop
               jmp       Label11             	;Skip the else clause
Label10:                                     	;Beginning of else clause
Label11:                                     	;End of else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
               jmp       Label0              	;Jump back to the top of while loop
Label1:                                      	;Destination if while condition fails
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
