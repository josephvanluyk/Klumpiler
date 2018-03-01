               global    main                
               extern    printf              
               section   .text               
main:                                        
               push      1                   
               pop       dword [_a_]         	;Assign expression to a
               push      2                   
               pop       dword [_b_]         	;Assign expression to b
               push      3                   
               pop       dword [_c_]         	;Assign expression to c
               push      3                   
               pop       dword [_d_]         	;Assign expression to d
               push      4                   
               pop       dword [_e_]         	;Assign expression to e
               push      dword [_a_]         
               push      dword [_d_]         
               pop       ebx                 	;Prepare for addop
               pop       eax                 
               add       eax, ebx            
               push      eax                 
               pop       dword [_a_]         	;Assign expression to a
               push      dword [_a_]         	;***Begin Printing a***
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 	;***End Printing a***
               push      dword [_d_]         
               push      dword [_e_]         
               pop       ebx                 	;Prepare for mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 
               pop       dword [_d_]         	;Assign expression to d
               push      dword [_d_]         	;***Begin Printing d***
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 	;***End Printing d***
               push      dword [_a_]         
               push      dword [_b_]         
               pop       ebx                 	;Prepare for mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 
               push      4                   
               pop       ebx                 	;Prepare for addop
               pop       eax                 
               add       eax, ebx            
               push      eax                 
               pop       dword [_c_]         	;Assign expression to c
               push      dword [_e_]         
               push      2                   
               pop       ebx                 	;Prepare for mulop
               pop       eax                 
               imul      eax, ebx            
               push      eax                 
               pop       dword [_e_]         	;Assign expression to e
               push      dword [_e_]         	;***Begin Printing e***
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 	;***End Printing e***
               ret                           

               section   .data               
frmt:          db        "%d", 0xA, 0        
               section   .bss                
_a_:           resb(4)                       
_b_:           resb(4)                       
_c_:           resb(4)                       
_d_:           resb(4)                       
_e_:           resb(4)                       
_out_:         resb(4)                       
