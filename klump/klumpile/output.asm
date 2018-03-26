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
               push      1                   	;Push int literal to stack
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
               push      1                   	;Push int literal to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label2              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label3              	;Skip pushing 1
Label2:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label3:                                      	;End of comparison
               pop       ebx                 	;Pop operands from stack
               pop       eax                 
               and       eax, ebx            	;Complete comparison
               push      eax                 	;Push result to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label4              	;If bool is 0, jump to the else clause
               push      Label6              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label5              	;Skip the else clause
Label4:                                      	;Beginning of else clause
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label5:                                      	;End of else clause
               push      1                   	;Push int literal to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label8              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label9              	;Skip pushing 1
Label8:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label9:                                      	;End of comparison
               push      2                   	;Push int literal to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label10             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label11             	;Skip pushing 1
Label10:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label11:                                     	;End of comparison
               pop       ebx                 	;Pop operands from stack
               pop       eax                 
               and       eax, ebx            	;Complete comparison
               push      eax                 	;Push result to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label12             	;If bool is 0, jump to the else clause
               push      Label14             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label13             	;Skip the else clause
Label12:                                     	;Beginning of else clause
               push      Label15             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label13:                                     	;End of else clause
               push      2                   	;Push int literal to stack
               push      3                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label16             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label17             	;Skip pushing 1
Label16:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label17:                                     	;End of comparison
               push      4                   	;Push int literal to stack
               push      7                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label18             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label19             	;Skip pushing 1
Label18:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label19:                                     	;End of comparison
               pop       ebx                 	;Pop operands from stack
               pop       eax                 
               and       eax, ebx            	;Complete comparison
               push      eax                 	;Push result to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label20             	;If bool is 0, jump to the else clause
               push      Label22             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label21             	;Skip the else clause
Label20:                                     	;Beginning of else clause
               push      Label23             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label21:                                     	;End of else clause
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
Label6:        db        "Incorrect", 0      
Label7:        db        "Correct", 0        
Label14:       db        "Correct", 0        
Label15:       db        "Incorrect", 0      
Label22:       db        "Incorrect", 0      
Label23:       db        "Correct", 0        
                                             
               section   .bss                
