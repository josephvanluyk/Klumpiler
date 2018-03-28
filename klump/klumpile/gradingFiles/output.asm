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
               push      Label0              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label1              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label2              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label3              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label4              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label5              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               mov       eax, ebp            
               sub       eax, 4              	;Subtract offset from ebp to find address of input variable
               push      eax                 
               push      intFrmtIn           
               call      scanf               	;Retrieve input from user
               add       esp, 8              	;Remove arguments from stack
Label6:        call      getchar             	;Remove characters until \n
               cmp       eax, 0xA            
               jne       Label6              	;If the character isn't \n, continue removing
               push      Label7              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               push      Label8              	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      dword [ebp - 4]     	;Push local var to stack
               pop       eax                 	;Pop case expression to eax
               push      1                   	;Push int literal to stack
               pop       ebx                 	;Remove case instance value from stack
               cmp       eax, ebx            	;Compare case expression to instance
               jne       Label10             
               push      Label11             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label9              	;Jump to end of case_statement
Label10:                                     	;Try next case instance
               push      2                   	;Push int literal to stack
               pop       ebx                 	;Remove case instance value from stack
               cmp       eax, ebx            	;Compare case expression to instance
               jne       Label12             
               push      Label13             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label9              	;Jump to end of case_statement
Label12:                                     	;Try next case instance
               push      3                   	;Push int literal to stack
               pop       ebx                 	;Remove case instance value from stack
               cmp       eax, ebx            	;Compare case expression to instance
               jne       Label14             
               push      Label15             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label9              	;Jump to end of case_statement
Label14:                                     	;Try next case instance
               push      4                   	;Push int literal to stack
               pop       ebx                 	;Remove case instance value from stack
               cmp       eax, ebx            	;Compare case expression to instance
               jne       Label16             
               push      Label17             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
               jmp       Label9              	;Jump to end of case_statement
Label16:                                     	;Try next case instance
               push      Label18             	;Push address of string literal to stack
               push      stringFrmt          	;Push format string for printf
               call      printf              
               add       esp, 8              
               push      NewLine             	;Push newline to stack for printf
               call      printf              
               add       esp, 4              	;Clean up stack after printf
Label9:                                      	;End of case statement
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
Label0:        db        "enter class status:", 0
Label1:        db        "  1 = freshman", 0 
Label2:        db        "  2 = sophomore", 0
Label3:        db        "  3 = junior", 0   
Label4:        db        "  4 = senior", 0   
Label5:        db        "     enter status: ", 0
Label7:        db        "", 0               
Label8:        db        "student status: ", 0
Label11:       db        "freshman", 0       
Label13:       db        "sophomore", 0      
Label15:       db        "junior", 0         
Label17:       db        "senior", 0         
Label18:       db        "do not know", 0    
                                             
               section   .bss                
