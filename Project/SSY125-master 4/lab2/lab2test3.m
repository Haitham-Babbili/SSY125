clc
clear
N = 1e5; % simulate N bits each transmission ( one block )
maxNumErrs = 100; % get at least 100 bit errors ( more is better )
maxNum = 40*1e5; % OR stop if maxNum bits have been simulated
EbN0 = -5:1:11; % power efficiency range
receiver = 2; % Hard receiver = 1, Soft receiver = 2
% Other Options ...
 trellis = poly2trellis(3,[5 7]);
% trellis = poly2trellis(5,[27 26]);
% trellis = poly2trellis(5,[23 33]);
%trellis = poly2trellis([1 2], [0 1 1 ; 0 1 1]); %not sure

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros (1 , length ( EbN0 )); % pre - allocate a vector for the BER results
for i = 1: length ( EbN0 ) % use parfor ( ?help parfor ? to parallelize
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



c = convenc(m,trellis);

% % [MOD] symbol mapper
M=4;
x = qammod(c',M,'gray','InputType','bit');

% % [CHA] add Gaussian noise
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))

y = awgn(x,EbN0(i));
%plot (y, 'b. ')


yhatt = y;


switch receiver
    % % [HR] Hard Receiver
    case 1
        rxDataHard = qamdemod(yhatt,M,'OutputType','bit');
        mhatt = vitdec(rxDataHard,trellis,32,'trunc','hard');

    % % [SR] Soft Receiver
    case 2
        rxDataSoft = qamdemod(yhatt,M,'OutputType','approxllr','NoiseVariance',10.^(EbN0(i)/10));
        mhatt = vitdec(rxDataSoft,trellis,32,'trunc','unquant');
    otherwise
        warning('Unexpected receiver')
end
% ===================================================================== %
% End processing one block of information
% ===================================================================== %
BitErrs = 0; % count the bit errors and evaluate the bit error rate
BitErrs = sum(mhatt' ~= bitsend);
totErr = totErr + BitErrs ;
num = num + N;
%disp ([ '+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors . ' num2str(num ) '/' num2str( maxNum ) 'bits . Projected error rate ='...
%     num2str( totErr /num , '%10.1 e') '. +++ ']);
end
BER(i) = totErr /num;
end

semilogy(EbN0 + 10*log10(1),BER,'xblack')

hold on
grid on


%%
% Upper bound
spect = distspec(trellis,4);
berub = bercoding(EbN0,'conv','soft',1/2,spect); % BER bound
semilogy(EbN0,berub,'black'); %ylabel('Upper Bound on BER');

%legend('Hard Decoded','Soft Decoded','Theoetical uncoded','Upper bound (Soft)')
%%
% Therotical
EbN0_T = -3:1:11; % power efficiency range
EbN0t= 10.^(EbN0_T/10);
BER_T=qfunc(sqrt(2*EbN0t));

semilogy(EbN0_T,BER_T,'-')
xlabel('$\frac{E_b}{N_0}$','Interpreter','latex')
ylabel('BER','Interpreter','latex')
grid on
hold on

legend('E1','E1 upper bound','E2','E2 upper bound','E3','E3 upper bound','Theoretical uncoded')
axis([-4 12 10^(-7) 1])
