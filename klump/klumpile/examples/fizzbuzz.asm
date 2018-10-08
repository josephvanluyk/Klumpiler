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
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label0:                                      	;Begin compiling for expression
               push      100                 	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label1              
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      3                   	;Push int literal to stack
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
               je        Label3              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label4              	;Skip pushing 1
Label3:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label4:                                      	;End of comparison
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      5                   	;Push int literal to stack
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
               je        Label5              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label6              	;Skip pushing 1
Label5:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label6:                                      	;End of comparison
               pop       ebx                 	;Pop operands from stack
               pop       eax                 
               and       eax, ebx            	;Complete comparison
               push      eax                 	;Push result to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label7              	;If bool is 0, jump to the else clause
               push      Label9              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label8              	;Skip the else clause
Label7:                                      	;Beginning of else clause
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      3                   	;Push int literal to stack
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
               je        Label10             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label11             	;Skip pushing 1
Label10:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label11:                                     	;End of comparison
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
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      5                   	;Push int literal to stack
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
               je        Label15             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label16             	;Skip pushing 1
Label15:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label16:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label17             	;If bool is 0, jump to the else clause
               push      Label19             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label18             	;Skip the else clause
Label17:                                     	;Beginning of else clause
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label18:                                     	;End of else clause
Label13:                                     	;End of else clause
Label8:                                      	;End of else clause
Label2:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label0              
Label1:                                      	;Exit destination for loop
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
randIn:        db        "/dev/urandom"      	;File for random bytes
negone:        dq        -1.0                	;Negative one
Label9:        db        "Fizzbuzz", 0       
Label14:       db        "Fizz", 0           
Label19:       db        "buzz", 0           
                                             
               section   .bss                
