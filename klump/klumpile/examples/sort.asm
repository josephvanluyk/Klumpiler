               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 60             
               push      Label0              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 60]     	;Load address into eax
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
               lea       eax, [ebp - 56]     	;Load address into eax
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label3:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label3              	;If the character isn't \n, continue removing
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label4:                                      	;Begin compiling for expression
               push      9                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label5              
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               sub       esp, 4              	;Make room for file descriptor later
               lea       eax, [ebp - 56]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 60]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               mov       eax, 5              	;Move sys_open call to eax
               mov       ebx, randIn         	;filename to ebx
               mov       ecx, 0              	;Permissions are read-only
               int       0x80                	;syscall
               mov       [esp + 8], eax      	;Store file descriptor
               mov       ebx, eax            	;Move file descriptor to ebx
               mov       eax, 3              	;Move sys_read call to eax
               sub       esp, 4              	;Make room for read integer
               mov       ecx, esp            	;Make input pointer esp
               mov       edx, 4              	;Input 4 bytes
               int       0x80                	;syscall
               mov       eax, [esp + 4]      	;Move upper bound to eax
               mov       ebx, [esp + 8]      	;Move lower bound to ebx
               sub       eax, ebx            	;Calculate randint range
               push      eax                 	;Push range to stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Test if the range is 0
               je        Label7              	;If it is, jump to the end
               mov       eax, [esp + 4]      	;Move random int to eax
               mov       ebx, [esp]          	;Move range to ebx
               cdq                           
               idiv      ebx                 
               mov       eax, edx            
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare if the result is negative
               jge       Label7              	;If it's not, jump to the end
               mov       ebx, [esp]          	;Move range to ebx
               add       eax, ebx            	;Increment result by range
Label7:                                      
               mov       ebx, [esp + 12]     	;Move lower bound to ebx
               add       eax, ebx            	;Add lower bound to result
               add       esp, 16             	;Clean up stack
               pop       ebx                 	;Move file descriptor for /dev/urandom
               push      eax                 	;Push result to stack
               mov       eax, 6              	;sys_close
               int       0x80                
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label6:                                      	;End-of-loop maintenance
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label4              
Label5:                                      	;Exit destination for loop
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label8:                                      	;Begin compiling for expression
               push      9                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label9              
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label11:                                     	;Begin compiling for expression
               push      8                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               sub       eax, ebx            	;Subtract operands
               push      eax                 	;Push result to stack
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label12             
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               jg        Label14             	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label15             	;Skip pushing 1
Label14:                                     	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label15:                                     	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label16             	;If bool is 0, jump to the else clause
               lea       eax, [ebp - 52]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack to addop
               pop       eax                 
               add       eax, ebx            	;Add operands
               push      eax                 	;Push result to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               lea       eax, [ebp - 52]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       eax                 	;Reorder address and expression on stack
               pop       ecx                 	;Pop address to stack
               push      eax                 	;Push expression back to stack
               push      ecx                 	;Push address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               jmp       Label17             	;Skip the else clause
Label16:                                     	;Beginning of else clause
Label17:                                     	;End of else clause
Label13:                                     	;End-of-loop maintenance
               lea       eax, [ebp - 48]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label11             
Label12:                                     	;Exit destination for loop
Label10:                                     	;End-of-loop maintenance
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label8              
Label9:                                      	;Exit destination for loop
               push      Label18             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
Label19:                                     	;Begin compiling for expression
               push      9                   	;Push int literal to stack
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to counter variable
               mov       dword eax, [esi]    
               pop       ebx                 	;Remove for-condition for comparison
               cmp       eax, ebx            
               jg        Label20             
               lea       eax, [ebp - 40]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label21:                                     	;End-of-loop maintenance
               lea       eax, [ebp - 44]     	;Load address into eax
               push      eax                 
               pop       esi                 
               mov       dword eax, [esi]    
               inc       eax                 	;Increment Loop Counter
               mov       [esi], eax          	;Put updated Loop Counter into memory location
               jmp       Label19             
Label20:                                     	;Exit destination for loop
               push      Label22             	;Push address of string literal to stack
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
randIn:        db        "/dev/urandom"      	;File for random bytes
negone:        dq        -1.0                	;Negative one
Label0:        db        "Enter the upper bound: ", 0
Label2:        db        "Enter the lower bound: ", 0
Label18:       db        "------", 0         
Label22:       db        "", 0               
                                             
               section   .bss                
