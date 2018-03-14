               global    main                
               extern    printf              
               section   .text               
main:                                        
               push      0                   	;Push int literal to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               pop       dword [_x_]         	;Assign expression to real in two parts
               pop       dword [_x_ + 4]     
               push      0                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_sum_]       	;Pop top of stack in two parts
               pop       dword [_sum_+ 4]    
Label1:                                      	;Start of while loop
               push      dword [_n_]         	;Push identifier to stack
               push      10                  	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label3              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label4              	;Skip pushing 1
Label3:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label4:                                      	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label2              	;If comparison is false, jump to end
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               push      dword [_n_]         	;Push identifier to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               cdq                           	;Sign extend eax
               idiv      ebx                 	;Divide operands
               push      eax                 	;Push result to stack
               push      dword [_n_]         	;Push identifier to stack
               push      dword [Label5 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label5]      
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
               push      1                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_term_]      	;Pop top of stack in two parts
               pop       dword [_term_+ 4]   
               jmp       Label9              	;Skip the else clause
Label8:                                      	;Beginning of else clause
Label9:                                      	;End of else clause
               push      0                   	;Push int literal to stack
               pop       dword [_i_]         	;Pop top of stack to memory location
Label10:                                     	;Start of while loop
               push      dword [_i_]         	;Push identifier to stack
               push      2                   	;Push int literal to stack
               push      dword [_n_]         	;Push identifier to stack
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
               jl        Label12             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label13             	;Skip pushing 1
Label12:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label13:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label11             	;If comparison is false, jump to end
               push      dword [_term_+ 4]   	;Push real to stack
               push      dword [_term_]      
               push      dword [_x_+ 4]      	;Push real to stack
               push      dword [_x_]         
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       dword [_term_]      	;Assign expression to real in two parts
               pop       dword [_term_ + 4]  
               push      dword [_i_]         	;Push identifier to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       dword [_i_]         	;Pop top of stack to memory location
               jmp       Label10             	;Jump back to the top of while loop
Label11:                                     	;Destination if while condition fails
               push      1                   	;Push int literal to stack
               fild      dword [esp]         	;Load top of stack to floating point stack
               sub       esp, 4              	;Make room on stack for 64-bit float
               fstp      qword [esp]         	;Convert 32-bit int to 64-bit float
               pop       dword [_fact_]      	;Pop top of stack in two parts
               pop       dword [_fact_+ 4]   
               push      1                   	;Push int literal to stack
               pop       dword [_i_]         	;Pop top of stack to memory location
Label14:                                     	;Start of while loop
               push      dword [_i_]         	;Push identifier to stack
               push      2                   	;Push int literal to stack
               push      dword [_n_]         	;Push identifier to stack
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
               jle       Label16             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label17             	;Skip pushing 1
Label16:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label17:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label15             	;If comparison is false, jump to end
               push      dword [_fact_+ 4]   	;Push real to stack
               push      dword [_fact_]      
               push      dword [_i_]         	;Push identifier to stack
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       dword [_fact_]      	;Assign expression to real in two parts
               pop       dword [_fact_ + 4]  
               push      dword [_i_]         	;Push identifier to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       dword [_i_]         	;Pop top of stack to memory location
               jmp       Label14             	;Jump back to the top of while loop
Label15:                                     	;Destination if while condition fails
               push      dword [_term_+ 4]   	;Push real to stack
               push      dword [_term_]      
               push      dword [_fact_+ 4]   	;Push real to stack
               push      dword [_fact_]      
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               divsd     xmm0, xmm1          	;Divide floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       dword [_term_]      	;Assign expression to real in two parts
               pop       dword [_term_ + 4]  
               push      dword [_sum_+ 4]    	;Push real to stack
               push      dword [_sum_]       
               push      dword [_term_+ 4]   	;Push real to stack
               push      dword [_term_]      
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               pop       dword [_sum_]       	;Assign expression to real in two parts
               pop       dword [_sum_ + 4]   
               push      dword [_n_]         	;Push identifier to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       dword [_n_]         	;Pop top of stack to memory location
               jmp       Label1              	;Jump back to the top of while loop
Label2:                                      	;Destination if while condition fails
               push      dword [_sum_+ 4]    	;Push real to stack
               push      dword [_sum_]       
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
                                             
               section   .data               
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -1.0                	;Negative one
Label0:        dq        0.523598775         
Label5:        dq        2.0                 
                                             
               section   .bss                
_x_:           resb(8)                       
_sum_:         resb(8)                       
_n_:           resb(4)                       
_term_:        resb(8)                       
_i_:           resb(4)                       
_fact_:        resb(8)                       
