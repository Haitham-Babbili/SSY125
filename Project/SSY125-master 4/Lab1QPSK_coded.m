clc
clear
N = 1e5; % simulate N bits each transmission ( one block )
maxNumErrs = 10; % get at least 100 bit errors ( more is better )
maxNum = 1e4; % OR stop if maxNum bits have been simulated
EbN0 = -3:1:11; % power efficiency range
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
bitsend = m;
% [ENC] convolutional encoder
g1 = [0 1];
g2 = [1 1]; 
d1 = 0;
d2 = 0;

c = [];
for j = 1:N
    c(2*j-1) = mod(g1(2)*d2 + g1(1)*d1 + m(j),2);
    c(2*j) = mod(g2(2)*d2 + g2(1)*d1+ m(j),2);
    d2 = d1;
    d1 = m(j);
end

N2 = length(c)
bpm = 2;


m = reshape(c,[bpm, N2/bpm])';
mdec = bi2de(m,'left-msb')+1;


% [MOD] symbol mapper
%constellation = [-1 1]; % BPSK
EbN0(i)
Eb = 0.5;
N0 = Eb./(10.^(EbN0(i)./10));
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
yhatt = y;
bhatt = zeros(1,2*length(yhatt));

metric = abs(repmat(y.',1,length(constellation)) - repmat(constellation, length(y), 1)).^2 ;
[tmp,y_idx] = min(metric, [], 2); % find the closest for each received symbol
y_i = de2bi(y_idx-1,'left-msb')'; % symbol indexes
bhatt = reshape(y_i,[1 length(c)]);

bhatt = viterbi2(bhatt);

% [SR] Soft Receiver
% ...
% ===================================================================== %
% End processing one block of information
% ===================================================================== %
BitErrs = 0; % count the bit errors and evaluate the bit error rate
BitErrs = sum(bhatt' ~= bitsend);
totErr = totErr + BitErrs ;
num = num + N;
disp ([ '+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors . ' num2str(num ) '/' num2str( maxNum ) 'bits . Projected error rate ='...
     num2str( totErr /num , '%10.1 e') '. +++ ']);
end
BER(i) = totErr /num;
end


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