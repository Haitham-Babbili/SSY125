% ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D2, 1 + D + D2)
% Gray-mapping QPSK
% ======================================================================= %
clc
clear

% ======================================================================= %
% Simulation Parameters
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range
% ======================================================================= %
% 
BER_uncoded= uncoded(N,maxNumErrs,maxNum,EbN0);
[BER_soft,BER_hard,trellis]= Coded(N,maxNumErrs,maxNum,EbN0);

% 
trellis = poly2trellis([5 4],[23 35 0; 0 5 13]);
spect = distspec(trellis,4);
berub = bercoding(EbN0,'conv','soft',1/2,spect); % BER bound

% Asysmptotic gains
% g=10*log10(5*0.5)
% 
% % EbNodB=-6:2:24
% % EbNo=10.^(EbNodB/10);
% k=1e5; % bits per symbol
% M=2^k;% No. of symbols
% x=sqrt(3*k*EbN0/(M-1));
% Pb=(4/k)*(1-1/sqrt(M))*(1/2)*erfc(x/sqrt(2));
% X=sqrt(2*EbN0);
% plot(EbN0,qfunc(X));
% semilogy(EbN0,Pb)
% hold on
% Ploting starts here

semilogy(EbN0,BER_soft);
hold on
semilogy(EbN0,BER_hard);
hold on
semilogy(EbN0,BER_uncoded);
hold on
semilogy(EbN0,berub);
ylim([1e-4 1]);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('BER versus Eb/N0');
legend('Coded(soft)', 'Coded(hard)','Uncoded','Coded(soft) upperbound');
