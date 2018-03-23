               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      Label0              	;Push address of string literal to stack
               pop       dword [_prompt1_]   	;Assign string address to const variable
               push      Label1              	;Push address of string literal to stack
               pop       dword [_prompt2_]   	;Assign string address to const variable
               push      Label2              	;Push address of string literal to stack
               pop       dword [_prompt3_]   	;Assign string address to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 36             
               push      dword [_prompt1_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 8              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label3:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label3              	;If the character isn't \n, continue removing
               push      Label4              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 4]     	;Push local real to stack in two parts
               push      dword [ebp - 8]     
               call      Entry_cube          
               add       esp, 8              	;Remove args from stack
               sub       esp, 8              
               movsd     [esp], xmm0         	;Push return value to stack
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_prompt2_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 12             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label5:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label5              	;If the character isn't \n, continue removing
               push      Label6              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 12]    	;Push local var to stack
               call      Entry_factorial     
               add       esp, 4              	;Remove args from stack
               push      eax                 	;Push return value to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      dword [_prompt3_]   	;Push global var to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 20             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
               mov       eax, ebp            
               sub       eax, 28             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
               mov       eax, ebp            
               sub       eax, 36             	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label8:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label8              	;If the character isn't \n, continue removing
               push      dword [ebp - 16]    	;Push local real to stack in two parts
               push      dword [ebp - 20]    
               push      dword [ebp - 24]    	;Push local real to stack in two parts
               push      dword [ebp - 28]    
               push      dword [ebp - 32]    	;Push local real to stack in two parts
               push      dword [ebp - 36]    
               call      Entry_sort          
               add       esp, 24             	;Remove args from stack
               push      Label9              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label10             	;Push address of string literal to stack
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
Entry_cube:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 0              
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               movsd     xmm1, [esp]         	;Remove operands from stack to mulop
               movsd     xmm0, [esp + 8]     
               add       esp, 8              	;Remove extra space from stack
               mulsd     xmm0, xmm1          	;Multiply floating point operands
               movsd     [esp], xmm0         	;Push result to stack
               movsd     xmm0, [esp]         	;Move return value to xmm0
               add       esp, 8              
Exit_cube:                                   
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_factorial:                              
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 0              
               push      dword [ebp - -8]    	;Push local var to stack
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
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
               pop       eax                 	;Move return value to eax
               jmp       Label14             	;Skip the else clause
Label13:                                     	;Beginning of else clause
               push      dword [ebp - -8]    	;Push local var to stack
               push      dword [ebp - -8]    	;Push local var to stack
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
Label14:                                     	;End of else clause
Exit_factorial:                              
               mov       esp, ebp            
               pop       ebp                 
               ret                           	;Return control to calling function
Entry_sort:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 8              
               push      dword [ebp - -28]   	;Push local real to stack in two parts
               push      dword [ebp - -24]   
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               movsd     xmm1, [esp]         
               movsd     xmm0, [esp + 8]     
               add       esp, 8              
               cmpsd     xmm0, xmm1, 6       	;Compare floating point
               movsd     [esp], xmm0         	;Put result on stack
               add       esp, 4              	;Throw away half of result
               pop       eax                 
               cmp       eax, 0              	;Was the results 0's or 1's?
               jne       Label15             	;If it wasn't 0, jump to push 1
               push      0                   	;Push 0 for false comparison
               jmp       Label16             	;Skip pushing 1
Label15:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label16:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label17             	;If bool is 0, jump to the else clause
               push      dword [ebp - -28]   	;Push local real to stack in two parts
               push      dword [ebp - -24]   
               lea       esi, [ebp - 8]      	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - 4]      
               pop       dword [esi]         
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               lea       esi, [ebp - -24]    	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -28]    
               pop       dword [esi]         
               push      dword [ebp - 4]     	;Push local real to stack in two parts
               push      dword [ebp - 8]     
               lea       esi, [ebp - -16]    	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -20]    
               pop       dword [esi]         
               jmp       Label18             	;Skip the else clause
Label17:                                     	;Beginning of else clause
Label18:                                     	;End of else clause
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               movsd     xmm1, [esp]         
               movsd     xmm0, [esp + 8]     
               add       esp, 8              
               cmpsd     xmm0, xmm1, 6       	;Compare floating point
               movsd     [esp], xmm0         	;Put result on stack
               add       esp, 4              	;Throw away half of result
               pop       eax                 
               cmp       eax, 0              	;Was the results 0's or 1's?
               jne       Label19             	;If it wasn't 0, jump to push 1
               push      0                   	;Push 0 for false comparison
               jmp       Label20             	;Skip pushing 1
Label19:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label20:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label21             	;If bool is 0, jump to the else clause
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               lea       esi, [ebp - 8]      	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - 4]      
               pop       dword [esi]         
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               lea       esi, [ebp - -16]    	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -20]    
               pop       dword [esi]         
               push      dword [ebp - 4]     	;Push local real to stack in two parts
               push      dword [ebp - 8]     
               lea       esi, [ebp - -8]     	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -12]    
               pop       dword [esi]         
               push      dword [ebp - -28]   	;Push local real to stack in two parts
               push      dword [ebp - -24]   
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               movsd     xmm1, [esp]         
               movsd     xmm0, [esp + 8]     
               add       esp, 8              
               cmpsd     xmm0, xmm1, 6       	;Compare floating point
               movsd     [esp], xmm0         	;Put result on stack
               add       esp, 4              	;Throw away half of result
               pop       eax                 
               cmp       eax, 0              	;Was the results 0's or 1's?
               jne       Label23             	;If it wasn't 0, jump to push 1
               push      0                   	;Push 0 for false comparison
               jmp       Label24             	;Skip pushing 1
Label23:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label24:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label25             	;If bool is 0, jump to the else clause
               push      dword [ebp - -28]   	;Push local real to stack in two parts
               push      dword [ebp - -24]   
               lea       esi, [ebp - 8]      	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - 4]      
               pop       dword [esi]         
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               lea       esi, [ebp - -24]    	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -28]    
               pop       dword [esi]         
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               lea       esi, [ebp - -16]    	;Load address of local real
               pop       dword [esi]         	;Store first half of real
               lea       esi, [ebp - -20]    
               pop       dword [esi]         
               jmp       Label26             	;Skip the else clause
Label25:                                     	;Beginning of else clause
Label26:                                     	;End of else clause
               jmp       Label22             	;Skip the else clause
Label21:                                     	;Beginning of else clause
Label22:                                     	;End of else clause
               push      dword [ebp - -28]   	;Push local real to stack in two parts
               push      dword [ebp - -24]   
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      Label27             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - -20]   	;Push local real to stack in two parts
               push      dword [ebp - -16]   
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      Label28             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - -12]   	;Push local real to stack in two parts
               push      dword [ebp - -8]    
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Exit_sort:                                   
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
Label0:        db        "enter x: ", 0      
Label1:        db        "enter n: ", 0      
Label2:        db        "enter three real numbers: ", 0
Label4:        db        "x^3 is ", 0        
Label6:        db        "n! is ", 0         
Label7:        db        "", 0               
Label9:        db        "", 0               
Label10:       db        "all done!", 0      
Label27:       db        "  ", 0             
Label28:       db        "  ", 0             
                                             
               section   .bss                
_prompt1_:     resb(4)                       
_prompt2_:     resb(4)                       
_prompt3_:     resb(4)                       
