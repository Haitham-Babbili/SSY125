clc
clear
N = 1e5; % simulate N bits each transmission ( one block )
maxNumErrs = 100; % get at least 100 bit errors ( more is better )
maxNum = 40*1e5; % OR stop if maxNum bits have been simulated
EbN0 = -6:1:11; % power efficiency range

% Other Options ...
%trellis = poly2trellis(3,[5 7]);
% trellis = poly2trellis(5,[27 26]);
 trellis = poly2trellis(5,[23 33]);
%trellis = struct('numInputSymbols',4,'numOutputSymbols',8,...
%'numStates',8,'nextStates',[0 1 2 3;4 5 6 7;1 0 3 2;5 4 7 6;2 3 0 1;6 7 4 5;3 2 1 0;7 6 5 4],...
%'outputs',[0 1 2 3;4 5 6 7;0 1 2 3;4 5 6 7;0 1 2 3;4 5 6 7;0 1 2 3;4 5 6 7]);

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
M=2;
x = qammod(c',M,'gray','InputType','bit');
%scatterplot(x);

% % [CHA] add Gaussian noise
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))

y = awgn(x,EbN0(i));
%plot (y, 'b. ')


yhatt = y;


rxDataSoft = qamdemod(yhatt,M,'OutputType','approxllr','NoiseVariance',10^(EbN0(i)/10));
mhatt = vitdec(rxDataSoft,trellis,32,'trunc','unquant');

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

semilogy(EbN0 + 10*log10(1),BER,'xb');

hold on
grid on

%% QPSK

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
%scatterplot(x);

% % [CHA] add Gaussian noise
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))

y = awgn(x,EbN0(i));
%plot (y, 'b. ')


yhatt = y;


rxDataSoft = qamdemod(yhatt,M,'OutputType','approxllr','NoiseVariance',10^(EbN0(i)/10));
mhatt = vitdec(rxDataSoft,trellis,32,'trunc','unquant');

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

semilogy(EbN0 + 10*log10(2),BER,'xr');

hold on
grid on


%% Uncoded
BER = zeros (1 , length ( EbN0 )); % pre - allocate a vector for the BER results
for i = 1: length ( EbN0 ) % use parfor ( ?help parfor ? to parallelize
    totErr = 0; % running number of errors observed
    num = 0; % running w of bits processed
while (( totErr < maxNumErrs ) && ( num < maxNum ))
% ===================================================================== %
% Begin processing one block of information
% ===================================================================== %
% [SRC] generate N information bits
m = randi([0 1],1,N);
bitsend = m;

c = bitsend;

% % [MOD] symbol mapper
M=4;
x = qammod(c',M,'gray','InputType','bit');

% % [CHA] add Gaussian noise
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))
%sigma = sqrt(1/(2*10^(EbN0(i)/10)))

y = awgn(x,EbN0(i));
%plot (y, 'b. ')


yhatt = y;

mhatt = qamdemod(yhatt,M,'gray','OutputType','bit');

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
% Therotical
EbN0_T = -3:1:11; % power efficiency range
EbN0t= 10.^(EbN0_T/10);
BER_T=qfunc(sqrt(2*EbN0t));

semilogy(EbN0_T,BER_T,'-black')
xlabel('$\frac{E_b}{N_0}$','Interpreter','latex')
ylabel('BER','Interpreter','latex')
grid on
hold on

legend('E3 BPSK','E3 QPSK','Uncoded transmission (QPSK)','Theoretical Uncoded (QPSK)')
axis([-4 12 10^(-7) 1])
