clc 
function [Encoded_vector] = c_encoder(Encoder,u)    
    if (Encoder == 1)                   % G =(1+D2,1+D +D2) 
        enco_mem=[0 0];                 % Number of memory elements, in our case 2.
        Encoded_vector=zeros(1,(length(u))*2);

        temp=xor(enco_mem(1),enco_mem(2));      
        o1=xor(u(1),enco_mem(2));            
        o2=xor(u(1),temp);      
        Encoded_vector(1)=o1;
        Encoded_vector(2)=o2;
        c=3;
        enco_mem(2)=enco_mem(1);
        enco_mem(1)=u(1);

        for (i = 2:(length(u)))
            if (i < length(u))
                temp=xor(enco_mem(2),enco_mem(1));    
                o1=xor(u(i),enco_mem(2));            
                o2=xor(u(i),temp);
                Encoded_vector(c)=o1;    %o1 generating polynomial(1,0,1)
                c=c+1;
                Encoded_vector(c)=o2;    %o2 generating polynomial(1,1,1)
                c=c+1;
                enco_mem(2)=enco_mem(1);
                enco_mem(1)=u(i);
            else
                temp=xor(enco_mem(1),enco_mem(2));    
                o1=xor(0,enco_mem(2));            
                o2=xor(0,temp);
                Encoded_vector(1,c)=o1;  %o1 generating polynomial(1,0,1)
                c=c+1;
                Encoded_vector(1,c)=o2;  %o2 generating polynomial(1,1,1)
                c=c+1;
                enco_mem(1)=0;
            end
        end
    end

    end
    
        
    
