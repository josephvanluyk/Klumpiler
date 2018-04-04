               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      Label0              	;Push address of string literal to stack
               pop       dword [_str_]       	;Assign string address to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 8              
               lea       eax, [_str_]        	;Load address into eax
               push      eax                 
               pop       esi                 	;Pop address to esi
               push      dword [esi]         	;Push factor to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label1:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label1              	;If the character isn't \n, continue removing
               lea       eax, [ebp - 8]      	;Load address into eax
               push      eax                 
               push      0                   	;Push int literal to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*4]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               push      1                   	;Push int literal to stack
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
Label0:        db        "test string", 0    
                                             
               section   .bss                
_str_:         resb(4)                       
