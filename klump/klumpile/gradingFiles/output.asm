               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 16             
               push      Label0              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label1:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label1              	;If the character isn't \n, continue removing
               push      Label2              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label3:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label3              	;If the character isn't \n, continue removing
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label4:                                      	;Begin compiling for expression
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label5              
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
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
               je        Label7              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label8              	;Skip pushing 1
Label7:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label8:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label9              	;If bool is 0, jump to the else clause
               jmp       Label6              	;Jump to top of loop
               jmp       Label10             	;Skip the else clause
Label9:                                      	;Beginning of else clause
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label10:                                     	;End of else clause
Label6:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label4              
Label5:                                      	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
               push      Label11             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label12             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label13             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label14             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label15             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label16:       call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label16             	;If the character isn't \n, continue removing
               push      Label17             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label18:       call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label18             	;If the character isn't \n, continue removing
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label19:                                     	;Begin compiling for expression
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jl        Label20             
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
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
               je        Label22             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label23             	;Skip pushing 1
Label22:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label23:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label24             	;If bool is 0, jump to the else clause
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label25             	;Skip the else clause
Label24:                                     	;Beginning of else clause
               jmp       Label21             	;Jump to top of loop
Label25:                                     	;End of else clause
Label21:                                     	;End-of-loop maintenance
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               dec       eax                 	;Decrmeent Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label19             
Label20:                                     	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
               push      Label26             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label27             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label28             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label29             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
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
Label0:        db        'enter a positive integer: ', 0
Label2:        db        'enter a LARGER positive integer: ', 0
Label11:       db        'the sum of all ODD integers between ', 0
Label12:       db        ' and ', 0          
Label13:       db        ' is: ', 0          
Label14:       db        "", 0               
Label15:       db        'enter a positive integer: ', 0
Label17:       db        'enter a SMALLER positive integer: ', 0
Label26:       db        'the sum of all EVEN integers between ', 0
Label27:       db        ' and ', 0          
Label28:       db        ' is: ', 0          
Label29:       db        "", 0               
                                             
               section   .bss                
