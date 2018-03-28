               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      100                 	;Push int literal to stack
               pop       dword [_maxsize_]   	;Assign int value to const variable
               push      Label0              	;Push address of string literal to stack
               pop       dword [_prompt_]    	;Assign string address to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 1620           
               push      dword [_prompt_]    	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      _actualsize_        	;Push address to input variable
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label1:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label1              	;If the character isn't \n, continue removing
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label2:                                      	;Start of while loop
               push      dword [ebp - 1620]  	;Push local var to stack
               push      dword [_actualsize_]	;Push global var to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label4              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label5              	;Skip pushing 1
Label4:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label5:                                      	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label3              	;If comparison is false, jump to end
               push      Label6              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               lea       eax, [ebp - 800]    	;Load address into eax
               push      eax                 
               pop       eax                 	;Pop array head address
               pop       ebx                 	;Pop offset calculation
               lea       eax, [eax + 8*ebx]  	;Perform offset calculation
               push      eax                 	;Push address to array variable
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label8:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label8              	;If the character isn't \n, continue removing
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label2              	;Jump back to the top of while loop
Label3:                                      	;Destination if while condition fails
               push      Label9              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label10:                                     	;Start of while loop
               push      dword [ebp - 1620]  	;Push local var to stack
               push      dword [_actualsize_]	;Push global var to stack
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
               push      Label14             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label15             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               lea       eax, [ebp - 800]    	;Load address into eax
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
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label10             	;Jump back to the top of while loop
Label11:                                     	;Destination if while condition fails
               push      Label16             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [ebp - 800]   	;Push local var to stack
               lea       eax, [ebp - 1600]   	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label17:                                     	;Start of while loop
               push      dword [ebp - 1620]  	;Push local var to stack
               push      dword [_actualsize_]	;Push global var to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label19             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label20             	;Skip pushing 1
Label19:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label20:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label18             	;If comparison is false, jump to end
               push      Label21             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label22             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1620]  	;Push local var to stack
               lea       eax, [ebp - 1600]   	;Load address into eax
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
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label17             	;Jump back to the top of while loop
Label18:                                     	;Destination if while condition fails
               push      Label23             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               push      dword [Label24 + 4] 	;Push value of real literal to stack in two parts
               push      dword [Label24]     
               lea       eax, [ebp - 1608]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
Label25:                                     	;Start of while loop
               push      dword [ebp - 1620]  	;Push local var to stack
               push      dword [_actualsize_]	;Push global var to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jl        Label27             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label28             	;Skip pushing 1
Label27:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label28:                                     	;End of comparison
               pop       eax                 	;Remove bool to test while condition
               mov       ebx, 1              
               cmp       eax, ebx            	;See if while condition is true
               jne       Label26             	;If comparison is false, jump to end
               push      dword [ebp - 1604]  	;Push local real to stack in two parts
               push      dword [ebp - 1608]  
               push      dword [ebp - 1620]  	;Push local var to stack
               lea       eax, [ebp - 800]    	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*8]  	;Calculate offset
               push      dword [esi + 4]     	;Push real from array to stack in two parts
               push      dword [esi]         	;Push from array to stack
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               lea       eax, [ebp - 1608]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               push      dword [ebp - 1620]  	;Push local var to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 1620]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label25             	;Jump back to the top of while loop
Label26:                                     	;Destination if while condition fails
               push      dword [ebp - 1604]  	;Push local real to stack in two parts
               push      dword [ebp - 1608]  
               push      dword [_actualsize_]	;Push global var to stack
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               divsd     xmm0, xmm1          	;Divide floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               lea       eax, [ebp - 1616]   	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               push      Label29             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [_actualsize_]	;Push global var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label30             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 1612]  	;Push local real to stack in two parts
               push      dword [ebp - 1616]  
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label31             	;Push address of string literal to stack
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
Label0:        db        "enter the number of actual elements (1 <= n <= 100)", 0
Label6:        db        "data [", 0         
Label7:        db        "]: ", 0            
Label9:        db        "", 0               
Label14:       db        "data [", 0         
Label15:       db        "] = ", 0           
Label16:       db        "", 0               
Label21:       db        "duplicate [", 0    
Label22:       db        "] = ", 0           
Label23:       db        "", 0               
Label24:       dq        0.0                 
Label29:       db        "the mean for the sample of size ", 0
Label30:       db        " is ", 0           
Label31:       db        "", 0               
                                             
               section   .bss                
_actualsize_:  resb(4)                       
_maxsize_:     resb(4)                       
_prompt_:      resb(4)                       
