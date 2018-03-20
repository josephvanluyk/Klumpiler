               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 20             
Label0:                                      	;Start of while loop
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
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label1              	;If comparison is false, jump to end
               push      0                   	;Push int literal to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               push      Label4              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      _x_                 	;Push address to input variable
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label5:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label5              	;If the character isn't \n, continue removing
               push      0                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_sum_]       	;Pop top of stack in two parts
               pop       dword [_sum_+ 4]    
Label6:                                      	;Start of while loop
               push      dword [_n_]         	;Push global var to stack
               push      30                  	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label8              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label9              	;Skip pushing 1
Label8:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label9:                                      	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label7              	;If comparison is false, jump to end
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               push      dword [_n_]         	;Push global var to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               cdq                           	;Sign extend eax
               idiv      ebx                 	;Divide operands
               push      eax                 	;Push result to stack
               push      dword [_n_]         	;Push global var to stack
               push      dword [Label10 + 4] 	;Push value of real literal to stack in two parts
               push      dword [Label10]     
               movsd     xmm0, [esp]         	;Switch order of operands on stack
               mov       eax, [esp + 8]      
               movsd     [esp + 4], xmm0     
               mov       [esp], eax          	;Finish pushing in reverse order
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               divsd     xmm1, xmm0          	;Divide in reverse order
               movsd     xmm0, xmm1          	;Move result to xmm0
               movsd     [esp], xmm0         	;Push result to stack
               sub       esp, 4              	;Make room on stack to convert int to real
               mov       eax, [esp + 4]      	;Move real to new stack location in two parts
               mov       [esp], eax          
               mov       eax, [esp + 8]      	;Move to eax first because mov doesn't accept two memory locations
               mov       [esp + 4], eax      
               fild      dword [esp + 12]    	;Load int to floating point stack for conversion
               fstp      qword [esp + 8]     	;Put new float back on stack
               fld       qword [esp + 8]     	;Put operands on stack for comparison
               fld       qword [esp]         
               add       esp, 16             	;Remove extra space on stack
               fcompp                        	;Complete comparison
               wait                          
               fstsw     ax                  	;Copy fpu flags into cpu flags
               sahf                          
               je        Label11             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label12             	;Skip pushing 1
Label11:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label12:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label13             	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               jmp       Label14             	;Skip the else clause
Label13:                                     	;Beginning of else clause
Label14:                                     	;End of else clause
               push      0                   	;Push int literal to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
Label15:                                     	;Start of while loop
               push      dword [ebp - 4]     	;Push local var to stack
               push      2                   	;Push int literal to stack
               push      dword [_n_]         	;Push global var to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label17             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label18             	;Skip pushing 1
Label17:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label18:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label16             	;If comparison is false, jump to end
               push      dword [_term_ + 4]  	;Push global real to stack in two parts
               push      dword [_term_]      
               push      dword [_x_ + 4]     	;Push global real to stack in two parts
               push      dword [_x_]         
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
               jmp       Label15             	;Jump back to the top of while loop
Label16:                                     	;Destination if while condition fails
               push      1                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               lea       esi, [ebp - 12]     	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - 8]      
               pop       dword [esi]         
               push      1                   	;Push int literal to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
Label19:                                     	;Start of while loop
               push      dword [ebp - 4]     	;Push local var to stack
               push      2                   	;Push int literal to stack
               push      dword [_n_]         	;Push global var to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jle       Label21             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label22             	;Skip pushing 1
Label21:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label22:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label20             	;If comparison is false, jump to end
               push      dword [ebp - 8]     	;Push local real to stack in two parts
               push      dword [ebp - 12]    
               push      dword [ebp - 4]     	;Push local var to stack
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               lea       esi, [ebp - 12]     	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - 8]      
               pop       dword [esi]         
               push      dword [ebp - 4]     	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       esi, [ebp - 4]      	;Load address of local int
               pop       dword [esi]         
               jmp       Label19             	;Jump back to the top of while loop
Label20:                                     	;Destination if while condition fails
               push      dword [_term_ + 4]  	;Push global real to stack in two parts
               push      dword [_term_]      
               push      dword [ebp - 8]     	;Push local real to stack in two parts
               push      dword [ebp - 12]    
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               divsd     xmm0, xmm1          	;Divide floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               push      dword [_sum_ + 4]   	;Push global real to stack in two parts
               push      dword [_sum_]       
               push      dword [_term_ + 4]  	;Push global real to stack in two parts
               push      dword [_term_]      
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               pop       dword [_sum_]       	;Pop top of stack in two parts
               pop       dword [_sum_+ 4]    
               push      dword [_n_]         	;Push global var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               jmp       Label6              	;Jump back to the top of while loop
Label7:                                      	;Destination if while condition fails
               push      Label23             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [_x_ + 4]     	;Push global real to stack in two parts
               push      dword [_x_]         
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      Label24             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [_sum_ + 4]   	;Push global real to stack in two parts
               push      dword [_sum_]       
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label0              	;Jump back to the top of while loop
Label1:                                      	;Destination if while condition fails
               mov       esp, ebp            
               pop       ebp                 
                                             
               section   .data               
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
realFrmtIn:    db        "%lf", 0            	;Read real
intFrmtIn:     db        "%i", 0             	;Read int
stringFrmtIn:  db        "%s", 0             	;Read string
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -1.0                	;Negative one
Label4:        db        "Please enter a value of x: ", 0
Label10:       dq        2.0                 
Label23:       db        "sin(", 0           
Label24:       db        ") = ", 0           
                                             
               section   .bss                
_x_:           resb(8)                       
_sum_:         resb(8)                       
_n_:           resb(4)                       
_term_:        resb(8)                       
