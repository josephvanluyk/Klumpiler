               global    main                
               extern    printf              
               section   .text               
main:                                        
               push      3                   
               pop       dword [_a_]         	;Assign expression to a
               push      5                   
               push      dword [_a_]         
               pop       ebx                 
               pop       eax                 
               imul      eax, ebx            
               push      eax                 
               push      2                   
               pop       ebx                 
               pop       eax                 
               sub       eax, ebx            
               push      eax                 
               pop       dword [_b_]         	;Assign expression to b
               push      10                  
               push      2                   
               pop       ebx                 
               pop       eax                 
               xor       edx, edx            
               div       ebx                 
               push      eax                 
               pop       dword [_c_]         	;Assign expression to c
               push      dword [_c_]         
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 
               push      dword [_a_]         
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 
               push      dword [_b_]         
               push      frmt                
               call      printf              
               pop       eax                 
               pop       eax                 
               ret                           

               section   .data               
frmt:          db        "%d", 0xA, 0        
               section   .bss                
_a_:           resb(4)                       
_b_:           resb(4)                       
_c_:           resb(4)                       
