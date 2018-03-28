               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 72             
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       eax                 	;Pop array head address
               pop       ebx                 	;Pop offset calculation
               lea       eax, [eax + 8*ebx]  	;Perform offset calculation
               push      eax                 	;Push address to array variable
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       eax                 	;Pop array head address
               pop       ebx                 	;Pop offset calculation
               lea       eax, [eax + 8*ebx]  	;Perform offset calculation
               push      eax                 	;Push address to array variable
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
               push      2                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       eax                 	;Pop array head address
               pop       ebx                 	;Pop offset calculation
               lea       eax, [eax + 8*ebx]  	;Perform offset calculation
               push      eax                 	;Push address to array variable
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label0:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label0              	;If the character isn't \n, continue removing
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      2                   	;Push int literal to stack
               lea       eax, [ebp - 72]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               mov       eax, ebp            
               sub       eax, 4              	;Subtract offset from ebp to find address of input variable
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
               push      dword [ebp - 4]     	;Push local var to stack
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               call      Entry_factorial     
               add       esp, 8              	;Remove args from stack
               push      eax                 	;Push return value to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label3              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 8]     	;Push local var to stack
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
               sub       esp, 0              
               mov       esi, [ebp - -8]     	;Move callby address into esi
               push      dword [esi]         	;Push value at address to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               push      dword [ebp - -8]    	;Load callBy address onto stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               push      dword [ebp - -12]   	;Push local var to stack
               push      0                   	;Push int literal to stack
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
               push      1                   	;Push int literal to stack
               pop       eax                 	;Move return value to eax
               jmp       Exit_factorial      	;Jump to function exit
               jmp       Label7              	;Skip the else clause
Label6:                                      	;Beginning of else clause
Label7:                                      	;End of else clause
               push      dword [ebp - -12]   	;Push local var to stack
               push      dword [ebp - -12]   	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               push      dword [ebp - -8]    	;Load callBy address onto stack
               call      Entry_factorial     
               add       esp, 8              	;Remove args from stack
               push      eax                 	;Push return value to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               pop       eax                 	;Move return value to eax
               jmp       Exit_factorial      	;Jump to function exit
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
Label2:        db        "n! = ", 0          
Label3:        db        "x = ", 0           
                                             
               section   .bss                
_test_:        resb(64)                      
