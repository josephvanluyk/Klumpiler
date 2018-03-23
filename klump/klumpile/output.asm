               global    main                
               extern    printf              
               extern    scanf               
               extern    getchar             
               section   .text               
main:                                        
               push      3                   	;Push int literal to stack
               pop       dword [_x_]         	;Assign int value to const variable
Entry_main:                                  
               push      ebp                 	;Store base pointer
               mov       ebp, esp            	;Create new base pointer
               sub       esp, 16             
               push      dword [Label0 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label0]      
               push      dword [Label1 + 4]  	;Push value of real literal to stack in two parts
               push      dword [Label1]      
               fld       qword [esp + 8]     	;Put operands on stack for comparison
               fld       qword [esp]         
               add       esp, 16             	;Remove extra space on stack
               fcompp                        	;Complete comparison
               wait                          
               fstsw     ax                  	;Copy fpu flags into cpu flags
               sahf                          
               jg        Label2              	;Push appropriate bool if based on comparison
               push      0                   	;Push 0 for false comparison
               jmp       Label3              	;Skip pushing 1
Label2:                                      	;Label if comparison was true
               push      1                   	;Push 1 for true comparison
Label3:                                      	;End of comparison
               pop       eax                 	;Remove bool from stack
               mov       ebx, 0              
               cmp       eax, ebx            	;Compare bool to 0
               je        Label4              	;If bool is 0, jump to the else clause
               push      1                   	;Push int literal to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label5              	;Skip the else clause
Label4:                                      	;Beginning of else clause
               push      0                   	;Push int literal to stack
               push      intFrmt             	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label5:                                      	;End of else clause
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
Label0:        dq        10.0                
Label1:        dq        1.0                 
                                             
               section   .bss                
_ret_:         resb(4)                       
_x_:           resb(4)                       
