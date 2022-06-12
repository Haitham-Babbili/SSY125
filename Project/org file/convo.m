function [encoded_sequence] = convo(code,message)    
    if code ==1 % G =(1+D2,1+D +D2) 
        enco_mem=[0 0];   %# of memory elements=3
        encoded_sequence=zeros(1,(length(message)+2)*2);

        temp=xor(enco_mem(1),enco_mem(2));      
        o1=xor(message(1),enco_mem(2));            
        o2=xor(message(1),temp);      
        encoded_sequence(1)=o1;
        encoded_sequence(2)=o2;
        c=3;
        enco_mem(2)=enco_mem(1);
        enco_mem(1)=message(1);

        for i=2: (length(message)+2)
           if(i<length(message))
               temp=xor(enco_mem(2),enco_mem(1));    
               o1=xor(message(i),enco_mem(2));            
               o2=xor(message(i),temp);
               encoded_sequence(c)=o1;    %o1 generating polynomial(1,0,1)
               c=c+1;
               encoded_sequence(c)=o2;    %o2 generating polynomial(1,1,1)
               c=c+1;
               enco_mem(2)=enco_mem(1);
               enco_mem(1)=message(i);
           else
               temp=xor(enco_mem(1),enco_mem(2));    
               o1=xor(0,enco_mem(2));            
               o2=xor(0,temp);
               encoded_sequence(1,c)=o1;    %o1 generating polynomial(1,0,1)
               c=c+1;
               encoded_sequence(1,c)=o2;    %o2 generating polynomial(1,1,1)
               c=c+1;
               enco_mem(1)=0;
           end
        end
    end
end     


        
    
