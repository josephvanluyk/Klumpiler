               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 16             
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
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
               push      1                   	;Push int literal to stack
               lea       eax, [ebp - 16]     	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               pop       dword [esi]         	;Pop expression to address in esi
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               lea       eax, [ebp - 12]     	;Load address into eax
               push      eax                 
               push      dword [ebp - 16]    	;Push local var to stack
               call      Entry_testone       
               add       esp, 12             	;Remove args from stack
               push      dword [ebp - 4]     	;Push local real to stack in two parts
               push      dword [ebp - 8]     
               push      realFrmt            	;Push format string for printf
               call      printf              
               add       esp, 12             
               push      Label1              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 12]    	;Push local var to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      Label2              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 16]    	;Push local var to stack
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
Entry_testone:                               
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 0              
               push      dword [ebp - -16]   	;Push address of callby variable to stack
               push      realFrmtIn          
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label3:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label3              	;If the character isn't \n, continue removing
Exit_testone:                                
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
Label0:        dq        1.0                 
Label1:        db        " ", 0              
Label2:        db        " ", 0              
                                             
               section   .bss                
