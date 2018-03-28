               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      3                   	;Push int literal to stack
               pop       dword [_x_]         	;Assign int value to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 4              
               push      Label0              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 4              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label1:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label1              	;If the character isn't \n, continue removing
Label2:                                      	;Start of while loop
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jne       Label4              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label5              	;Skip pushing 1
Label4:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label5:                                      	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label3              	;If comparison is false, jump to end
               push      dword [ebp - 4]     	;Push local var to stack
               call      Entry_isPrime       
               add       esp, 4              	;Remove args from stack
               push      eax                 	;Push return value to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label6              	;If bool is 0, jump to the else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label8              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label7              	;Skip the else clause
Label6:                                      	;Beginning of else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label9              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label7:                                      	;End of else clause
               push      Label10             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 4              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label11:       call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label11             	;If the character isn't \n, continue removing
               jmp       Label2              	;Jump back to the top of while loop
Label3:                                      	;Destination if while condition fails
Exit_main:                                   
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_isPrime:                               
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 4              
               push      dword [ebp - -8]    	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label12             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label13             	;Skip pushing 1
Label12:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label13:                                     	;End of comparison
               push      dword [ebp - -8]    	;Push local var to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label14             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label15             	;Skip pushing 1
Label14:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label15:                                     	;End of comparison
               pop       ebx                 	;Remove operands from stack for mulop
               pop       eax                 
               or        eax, ebx            
               push      eax                 	;Push result to stack
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label16             	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label18             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label19             	;Skip pushing 1
Label18:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label19:                                     	;End of comparison
               pop       eax                 	;Move return value to eax
               jmp       Exit_isPrime        	;Jump to function exit
               jmp       Label17             	;Skip the else clause
Label16:                                     	;Beginning of else clause
Label17:                                     	;End of else clause
               push      2                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label20:                                     	;Start of while loop
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - -8]    	;Push local var to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label22             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label23             	;Skip pushing 1
Label22:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label23:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label21             	;If comparison is false, jump to end
               push      dword [ebp - -8]    	;Push local var to stack
               push      dword [ebp - 4]     	;Push local var to stack
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
               je        Label24             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label25             	;Skip pushing 1
Label24:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label25:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label26             	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label28             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label29             	;Skip pushing 1
Label28:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label29:                                     	;End of comparison
               pop       eax                 	;Move return value to eax
               jmp       Exit_isPrime        	;Jump to function exit
               jmp       Label27             	;Skip the else clause
Label26:                                     	;Beginning of else clause
Label27:                                     	;End of else clause
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label20             	;Jump back to the top of while loop
Label21:                                     	;Destination if while condition fails
               push      1                   	;Push int literal to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label30             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label31             	;Skip pushing 1
Label30:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label31:                                     	;End of comparison
               pop       eax                 	;Move return value to eax
               jmp       Exit_isPrime        	;Jump to function exit
Exit_isPrime:                                
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
Label8:        db        " is prime", 0      
Label9:        db        " is not prime", 0  
Label10:       db        "Enter the value of n: ", 0
                                             
               section   .bss                
_ret_:         resb(4)                       
_x_:           resb(4)                       
