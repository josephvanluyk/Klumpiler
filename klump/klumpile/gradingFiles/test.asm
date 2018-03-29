               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               pop       dword [_pi_]        	;Assign first half of real to const variable
               pop       dword [_pi_ + 4]    
               push      dword [Label1 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label1]      
               pop       dword [_rad2_]      	;Assign first half of real to const variable
               pop       dword [_rad2_ + 4]  
               push      3                   	;Push int literal to stack
               pop       dword [_three_]     	;Assign int value to const variable
               push      dword [Label2 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label2]      
               pop       dword [_five_]      	;Assign first half of real to const variable
               pop       dword [_five_ + 4]  
               push      Label3              	;Push address of string literal to stack
               pop       dword [_prompt1_]   	;Assign string address to const variable
               push      Label4              	;Push address of string literal to stack
               pop       dword [_prompt2_]   	;Assign string address to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 36             
               push      dword [_prompt1_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 4              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label5:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label5              	;If the character isn't \n, continue removing
               push      dword [_prompt1_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 8              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label6:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label6              	;If the character isn't \n, continue removing
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - 8]     	;Push local var to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_prompt2_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 20             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label8:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label8              	;If the character isn't \n, continue removing
               push      dword [_prompt2_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 28             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label9:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label9              	;If the character isn't \n, continue removing
               push      dword [ebp - 16]    	;Push local real to stack in two parts
               push      dword [ebp - 20]    
               push      dword [ebp - 24]    	;Push local real to stack in two parts
               push      dword [ebp - 28]    
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               lea       eax, [ebp - 36]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               push      Label10             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 32]    	;Push local real to stack in two parts
               push      dword [ebp - 36]    
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_pi_ + 4]    	;Push global real to stack in two parts
               push      dword [_pi_]        
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - 16]    	;Push local real to stack in two parts
               push      dword [ebp - 20]    
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
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               push      dword [ebp - 8]     	;Push local var to stack
               push      dword [ebp - 24]    	;Push local real to stack in two parts
               push      dword [ebp - 28]    
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
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               subsd     xmm0, xmm1          	;Subtract operands
               movsd     [esp], xmm0         	;Push result to top of stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               lea       eax, [ebp - 36]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               push      dword [ebp - 32]    	;Push local real to stack in two parts
               push      dword [ebp - 36]    
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               movsd     xmm0, [esp + 4]     	;Move real into xmm0 for conversion
               cvtsd2si  eax, xmm0           	;Convert real to int
               pop       esi                 	;Pop address to esi
               mov       [esi], eax          	;Move converted float to address
               add       esp, 8              	;Clean up stack
               push      Label11             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 32]    	;Push local real to stack in two parts
               push      dword [ebp - 36]    
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label12             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 12]    	;Push local var to stack
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
                                             
               section   .data               
realFrmt:      db        "%f", 0             	;Print real without \n
intFrmt:       db        "%d", 0             	;Print int without \n
stringFrmt:    db        "%s", 0             	;Print string without \n
realFrmtIn:    db        "%lf", 0            	;Read real
intFrmtIn:     db        "%i", 0             	;Read int
stringFrmtIn:  db        "%s", 0             	;Read string
NewLine:       db        0xA, 0              	;Print NewLine
negone:        dq        -1.0                	;Negative one
Label0:        dq        3.14159             
Label1:        dq        1.41421             
Label2:        dq        5.0                 
Label3:        db        'enter an integer number: ', 0
Label4:        db        'enter a  real    number: ', 0
Label7:        db        'sum is: ', 0       
Label10:       db        'sum is: ', 0       
Label11:       db        'rz equals: ', 0    
Label12:       db        'iz equals: ', 0    
                                             
               section   .bss                
_pi_:          resb(8)                       
_rad2_:        resb(8)                       
_three_:       resb(4)                       
_five_:        resb(8)                       
_prompt1_:     resb(4)                       
_prompt2_:     resb(4)                       
