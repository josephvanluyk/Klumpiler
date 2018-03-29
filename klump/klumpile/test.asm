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
               push      Label0              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      _n_                 	;Push address to input variable
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label1:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label1              	;If the character isn't \n, continue removing
               push      1                   	;Push int literal to stack
               lea       eax, [_fact_]       	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               call      Entry_factorial     
               add       esp, 0              	;Remove args from stack
               push      Label2              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [_fact_]      	;Push global var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Exit_main:                                   
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
               je        Label3              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label4              	;Skip pushing 1
Label3:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label4:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label5              	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               lea       eax, [_fact_]       	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label6              	;Skip the else clause
Label5:                                      	;Beginning of else clause
               push      dword [_n_]         	;Push global var to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               push      dword [_n_]         	;Push global var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               lea       eax, [_n_]          	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               call      Entry_factorial     
               add       esp, 0              	;Remove args from stack
               push      dword [_fact_]      	;Push global var to stack
               push      dword [ebp - 4]     	;Push local var to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               lea       eax, [_fact_]       	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label6:                                      	;End of else clause
Exit_factorial:                              
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
Label0:        db        "Enter the value of n: ", 0
Label2:        db        "n! = ", 0          
                                             
               section   .bss                
_n_:           resb(4)                       
_fact_:        resb(4)                       
