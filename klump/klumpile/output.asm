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
               push      0                   	;Push int literal to stack
               push      1                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 8*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               fild      dword [esp + 4]     	;Load top of stack to floating point stack
               pop       eax                 	;Store address in eax
               sub       esp, 4              	;Make room for new float
               push      eax                 	;Push address back on stack
               fstp      qword [esp + 4]     	;Convert 32-bit int to 64-bit float
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               add       esp, 4              	;Remove offset from stack
               push      1                   	;Push int literal to stack
               push      2                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 8*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               fild      dword [esp + 4]     	;Load top of stack to floating point stack
               pop       eax                 	;Store address in eax
               sub       esp, 4              	;Make room for new float
               push      eax                 	;Push address back on stack
               fstp      qword [esp + 4]     	;Convert 32-bit int to 64-bit float
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               add       esp, 4              	;Remove offset from stack
               push      2                   	;Push int literal to stack
               push      3                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 8*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               fild      dword [esp + 4]     	;Load top of stack to floating point stack
               pop       eax                 	;Store address in eax
               sub       esp, 4              	;Make room for new float
               push      eax                 	;Push address back on stack
               fstp      qword [esp + 4]     	;Convert 32-bit int to 64-bit float
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               add       esp, 4              	;Remove offset from stack
               push      3                   	;Push int literal to stack
               push      4                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 8*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               fild      dword [esp + 4]     	;Load top of stack to floating point stack
               pop       eax                 	;Store address in eax
               sub       esp, 4              	;Make room for new float
               push      eax                 	;Push address back on stack
               fstp      qword [esp + 4]     	;Convert 32-bit int to 64-bit float
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               add       esp, 4              	;Remove offset from stack
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               call      Entry_testArr       
               add       esp, 4              	;Remove args from stack
               push      0                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
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
               lea       eax, [_test_]       	;Load address into eax
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
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      3                   	;Push int literal to stack
               lea       eax, [_test_]       	;Load address into eax
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
Exit_main:                                   
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_testArr:                               
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 8              
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label0:                                      	;Begin compiling for expression
               push      3                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label1              
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - -8]    	;Load callBy address onto stack
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
Label2:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label0              
Label1:                                      	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label3:                                      	;Begin compiling for expression
               push      3                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label4              
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - 4]     	;Push local var to stack
               push      dword [ebp - -8]    	;Load callBy address onto stack
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               push      1                   	;Push int literal to stack
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               push      dword [ebp - -8]    	;Load callBy address onto stack
               mov       ebx, [esp + 12]     	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 8*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               add       esp, 4              	;Remove offset from stack
Label5:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label3              
Label4:                                      	;Exit destination for loop
               add       esp, 4              	;Remove counter from stack
Exit_testArr:                                
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
_test_:        resb(32)                      
