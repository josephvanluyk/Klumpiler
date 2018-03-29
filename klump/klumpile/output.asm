               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 24             
               push      0                   	;Push int literal to stack
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 4*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               add       esp, 4              	;Remove offset from stack
               push      1                   	;Push int literal to stack
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 4*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               add       esp, 4              	;Remove offset from stack
               push      2                   	;Push int literal to stack
               push      2                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               mov       ebx, [esp + 8]      	;Move offset from array head to eax
               pop       eax                 	;Pop array location
               lea       eax, [eax + 4*ebx]  	;Calculate offset
               push      eax                 	;Push new address to stack
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               add       esp, 4              	;Remove offset from stack
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*4]  	;Calculate offset
               push      dword [esi]         	;Push from array to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*4]  	;Calculate offset
               push      dword [esi]         	;Push from array to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      2                   	;Push int literal to stack
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*4]  	;Calculate offset
               push      dword [esi]         	;Push from array to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               lea       eax, [ebp - 24]     	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop copy address to edi
               pop       edi                 	;Pop original address to esi
               mov       eax, 0              	;Set offset to 0
               mov       ebx, 12             	;Set target offset in ebx
Label0:                                      	;Start copying
               push      dword [esi + eax]   	;Push source copy to stack
               pop       dword [edi + eax]   	;Pop copy to destination copy
               add       eax, 4              	;Increment offset
               cmp       eax, ebx            	;Compare offset to storage size
               jl        Label0              	;If it's less than, jump back to the top
               push      0                   	;Push int literal to stack
               lea       eax, [ebp - 24]     	;Load address into eax
               push      eax                 
               pop       ebx                 
               pop       eax                 
               lea       esi, [ebx + eax*4]  	;Calculate offset
               push      dword [esi]         	;Push from array to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      1                   	;Push int literal to stack
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove operands from stack for comparison
               pop       eax                 
               cmp       eax, ebx            
               je        Label1              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label2              	;Skip pushing 1
Label1:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label2:                                      	;End of comparison
               pop       eax                 	;Pop bool to eax for NOT operator
               mov       ebx, 0              	;Move 0 into ebx to compare for NOT operator
               cmp       eax, ebx            
               je        Label3              	;If equal jump to push 1
               push      0                   
               jmp       Label4              	;Jump to end to skip pushing 1
Label3:                                      
               push      1                   
Label4:                                      
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label5              	;If bool is 0, jump to the else clause
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label6              	;Skip the else clause
Label5:                                      	;Beginning of else clause
               push      Label8              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label6:                                      	;End of else clause
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
Label7:        db        "Worked", 0         
Label8:        db        "Didnt work", 0     
                                             
               section   .bss                
