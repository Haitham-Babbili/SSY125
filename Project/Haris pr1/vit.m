function [u] = vit(trellis,bits,N)

N_out = trellis.numOutputSymbols;
numStates = trellis.numStates;
nextStates=trellis.nextStates+1;
outputs=trellis.outputs;

survivor=zeros(numStates,N);
cumulation=zeros(numStates,N+1);
cumulation(1,1)=0; cumulation(2:numStates,1)=Inf;

input=zeros(numStates,N);

M=zeros(1,numStates);
M(1:numStates)=Inf;



indice=1;
received_out=zeros(1,log2(N_out));
out=de2bi(outputs,2,'left-msb')
for c =2:N+1
   for k = 0:(log2(N_out)-1)
       received_out(k+1)=bits(indice+k);
   end
   
   for i = 1:numStates
       for j= 1 : 2
           if j==1
               %out=de2bi(outputs(i,j),2,'left-msb');
               if((cumulation(i,c-1)+sum(xor(out(i,:) ,received_out))<M(nextStates(i,j))))
                   M(nextStates(i,j))=(cumulation(i,c-1)+sum(xor(out(i,:) ,received_out)));
                   cumulation(nextStates(i,j),c)=M(nextStates(i,j));
                   survivor(nextStates(i,j),c-1)=i;
                   input(nextStates(i,j),c-1)=j-1;

               end
           
           else
               if((cumulation(i,c-1)+sum(xor(out(i+numStates,:) ,received_out))<M(nextStates(i,j))))
                   M(nextStates(i,j))=(cumulation(i,c-1)+sum(xor(out(i+numStates,:) ,received_out)));
                   cumulation(nextStates(i,j),c)=M(nextStates(i,j));
                   survivor(nextStates(i,j),c-1)=i;
                   input(nextStates(i,j),c-1)=j-1;

               end
           end
               
           %M(nextStates(i,j))=min(M(nextStates(i,j)),(cumulation(i,c-1)+sum(xor(out ,received_out))));
       end
   end 
   
%    for i=1:numStates
%        cumulation(i,c)=M(i);
%        survivor(i,c-1)=s(i);
%        input(i,c-1)=b(i);
%    end
   M(1:numStates)=Inf;
   indice=indice+log2(N_out);
end
ind = N ;
a=1;
u=zeros(1,N);
for n=1:N     
    u(ind)=input(a,ind);
    a=survivor(a,ind);
    ind=ind-1;   
end
end
       
   
