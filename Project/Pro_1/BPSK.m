% This program simulate the bit error rate of BPSK and compare the results
% with the theoretical value
% Name: Rian Jacob 
% Graduate student at UCLA

N = 1e7;
E = 0:.5:12;
c = [-1 1];

nError = zeros(1,length(E));
for i=1:length(E)
    m = randsrc(1,N,c);
    n = 1/sqrt(2)*10^(-E(i)/20) * randn(1,N);
   x = m+n;
   
   for j=1:N
       if (x(j)>0)
           x(j)=1;
       else
           x(j)=-1;
       end
   end
   counter = 0;
   for k=1:N
       if (x(k)~=m(k))
           counter=counter+1;
       end
   end
   nError(i) = counter;
end


snr = 10.^(E./10);
P = qfunc(sqrt(2*snr));

semilogy(E,P,'LineWidth',1.5)
BER = nError/N;
hold on
semilogy(E,BER,'O','LineWidth',1.5)
xlabel('Eb/No (dB)')
ylabel('BER')
title ('BER for BPSK')
grid on 


   