clc
clear
N = 1e5; % simulate N bits each transmission ( one block )
maxNumErrs = 100; % get at least 100 bit errors ( more is better )
maxNum = 1e6; % OR stop if maxNum bits have been simulated
 EbN0 = -1:0.5:11; % power efficiency range
% Other Options ...
% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros (1 , length ( EbN0 )); % pre - allocate a vector for the BER results
for i = 1: length ( EbN0 ) % use parfor ( ’ help parfor ’) to parallelize
    totErr = 0; % running number of errors observed
    num = 0; % running w of bits processed
    while (( totErr < maxNumErrs ) && ( num < maxNum ))
% ===================================================================== %
% Begin processing one block of information
% ===================================================================== %
% [SRC] generate N information bits
k = 5; % Number of information bits per code word m = randb (N, k);
m = randi([0 1],1,N);
% [ENC] convolutional encoder
% g1 = [0 1];
% g2 = [1 1]; 
% d1 = 0;
% d2 = 0;
% 
% %c = zeros(1,2*N);
% for i = 1:N
%     c(2*i-1) = mod(g1(2)*d2,mod(g1(1)*d1,m(i)));
%     c(2*i) = mod(g2(2)*d2,mod(g2(1)*d1,m(i)));
%     d2 = d1;
%     d1 = m(i);
% end
% c = [];

bpm = 2;

c = m;

m = reshape(c,[bpm, N/bpm])';
mdec = bi2de(m,'left-msb')+1;


% [MOD] symbol mapper
%constellation = [-1 1]; % BPSK
Eb = 0.5;
N0 = Eb./(10.^(EbN0(i)/10));
constellation = [1+1j 1-1j -1+1j -1-1j]; % QPSK
%constellation = [];
x = (1/sqrt(2)).*constellation(mdec);


% [CHA] add Gaussian noise
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
sigma = sqrt(N0/2);
nI = normrnd(0,sigma,[1 length(x)]);
nQ = normrnd(0,sigma,[1 length(x)]);
y = x + nI + 1i*nQ;
plot (y, 'b. ')



% [HR] Hard Receiver

%yhatt = sign(real(y)) + 1i*sign(imag(y));
yhatt = y;
bhatt = zeros(1,2*length(yhatt));
for a = 1:length(yhatt)
    if real(yhatt(a))>0
        bhatt(2*a-1) = 0;
    else
        bhatt(2*a-1) = 1; 
    end
    if imag(yhatt(a)) > 0
        bhatt(2*a) = 0;
    else
        bhatt(2*a) = 1;
    end
end
%yhatt2 = [real(yhatt);imag(yhatt)];
%bhatt = yhatt2(:)';
 

% [SR] Soft Receiver
% ...
% ===================================================================== %
% End processing one block of information
% ===================================================================== %
BitErrs = 0; % count the bit errors and evaluate the bit error rate
BitErrs = sum(bhatt ~= c);
totErr = totErr + BitErrs ;
num = num + N;
disp ([ '+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors . ' num2str(num ) '/' num2str( maxNum ) 'bits . Projected error rate ='...
     num2str( totErr /num , '%10.1 e') '. +++ ']);
end
BER(i) = totErr /num;
end;


% Therotical
EbN0_T = -1:1:11; % power efficiency range
EbN0t= 10.^(EbN0_T/10);
BER_T=qfunc(sqrt(2*EbN0t));
figure
semilogy(EbN0,BER,'x',EbN0_T,BER_T,'-')
xlabel('$\frac{E_b}{N_0}$','Interpreter','latex')
ylabel('BER','Interpreter','latex')
grid on
% ======================================================================= %
% End
% ======================================================================= %