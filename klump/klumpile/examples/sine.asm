               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 48             
               lea       eax, [ebp - 24]     	;Load address into eax
               push      eax                 
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      11                  	;Push int literal to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
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
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label1:                                      	;Begin compiling for expression
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label2              
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               call      Entry_nthSineTerm   
               add       esp, 4              	;Remove args from stack
               sub       esp, 8              
               movsd     [esp], xmm0         	;Push return value to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 24]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               call      Entry_pow           
               add       esp, 12             	;Remove args from stack
               sub       esp, 8              
               movsd     [esp], xmm0         	;Push return value to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               lea       eax, [ebp - 32]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 32]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
Label3:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label1              
Label2:                                      	;Exit destination for loop
               push      Label4              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 24]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      Label5              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
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
Entry_nthSineTerm:                              
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 8              
               lea       eax, [ebp - -8]     	;Load address into eax
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
               push      0                   	;Push int literal to stack
               fild      dword [esp]         
               sub       esp, 4              
               fstp      qword [esp]         	;Move return value to xmm0
               movsd     xmm0, [esp]         
               add       esp, 8              
               jmp       Exit_nthSineTerm    	;Jump to function exit
               jmp       Label9              	;Skip the else clause
Label8:                                      	;Beginning of else clause
Label9:                                      	;End of else clause
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               cdq                           	;Sign extend eax
               idiv      ebx                 	;Divide operands
               push      eax                 	;Push result to stack
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
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               push      1                   	;Push int literal to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label13             	;Skip the else clause
Label12:                                     	;Beginning of else clause
               lea       eax, [ebp - 4]      	;Load address into eax
               push      eax                 
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label13:                                     	;End of else clause
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               call      Entry_factorial     
               add       esp, 4              	;Remove args from stack
               push      eax                 	;Push return value to stack
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
               push      dword [Label14 + 4] 	;Push value of real literal to stack in two parts
               push      dword [Label14]     
               movsd     xmm0, [esp]         	;Switch order of operands on stack
               mov       eax, [esp + 8]      
               movsd     [esp + 4], xmm0     
               mov       [esp], eax          	;Finish pushing in reverse order
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Put top of stack into floating point registers
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               addsd     xmm0, xmm1          	;Add operands
               movsd     [esp], xmm0         	;Push result to top of stack
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               fild      dword [esp]         	;Convert int on stack to float
               sub       esp, 4              	;Make room on stack for float
               fstp      qword [esp]         	;Put new float on stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               divsd     xmm0, xmm1          	;Divide floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               movsd     xmm0, [esp]         	;Move return value to xmm0
               add       esp, 8              
               jmp       Exit_nthSineTerm    	;Jump to function exit
Exit_nthSineTerm:                              
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_factorial:                              
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 0              
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
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
               push      1                   	;Push int literal to stack
               pop       eax                 	;Move return value to eax
               jmp       Exit_factorial      	;Jump to function exit
               jmp       Label18             	;Skip the else clause
Label17:                                     	;Beginning of else clause
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               call      Entry_factorial     
               add       esp, 4              	;Remove args from stack
               push      eax                 	;Push return value to stack
               pop       ebx                 	;Remove operands from stack to mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 	;Push result to stack
               pop       eax                 	;Move return value to eax
               jmp       Exit_factorial      	;Jump to function exit
Label18:                                     	;End of else clause
Exit_factorial:                              
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_pow:                                   
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 12             
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      dword [Label19 + 4] 	;Push value of real literal to stack in two parts
               push      dword [Label19]     
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label20:                                     	;Begin compiling for expression
               lea       eax, [ebp - -8]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label21             
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - -12]    	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ebx                 	;Pop second part of real to ebx
               pop       ecx                 	;Pop address to stack
               push      ebx                 	;Push first part of real to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       eax                 
               pop       ebx                 
               mov       [esi + 4], ebx      	;Assign real in two parts
               mov       [esi], eax          
Label22:                                     	;End-of-loop maintenance
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label20             
Label21:                                     	;Exit destination for loop
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi + 4]     	;Push first half of real to stack
               push      dword [esi]         	;Push factor to stack
               movsd     xmm0, [esp]         	;Move return value to xmm0
               add       esp, 8              
               jmp       Exit_pow            	;Jump to function exit
Exit_pow:                                    
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
Label0:        dq        3.14                
Label4:        db        "Sine evaluated at ", 0
Label5:        db        " is approximately ", 0
Label14:       dq        0.0                 
Label19:       dq        1.0                 
                                             
               section   .bss                
