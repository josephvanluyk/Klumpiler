               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 4              
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*8]  	;Calculate new offset
               push      eax                 	;Push new address to stack
               push      2                   	;Push int literal to stack
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
               lea       eax, [_test_]       	;Load address into eax
               push      eax                 
               push      1                   	;Push int literal to stack
               pop       eax                 	;Pop top of stack to negate
               neg       eax                 
               push      eax                 	;Push negated term to stack
               pop       ebx                 	;Pop offset expression to ebx
               pop       eax                 	;Pop head address to eax
               lea       eax, [eax + ebx*8]  	;Calculate new offset
               push      eax                 	;Push new address to stack
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
