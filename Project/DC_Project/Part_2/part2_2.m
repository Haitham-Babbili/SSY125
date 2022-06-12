% ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D2, 1 + D + D2)
% Gray-mapping QPSK
% ======================================================================= %
clc
clear all

% ======================================================================= %
% Simulation Parameters
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:12; % power efficiency range
% ======================================================================= %

BER_uncoded= uncoded(N,maxNumErrs,maxNum,EbN0)
[BER_soft_g1,BER_soft_g2,BER_soft_g3,trellis]= Coded_part2_2(N,maxNumErrs,maxNum,EbN0)


spect_g1 = distspec(trellis(1,:),4);
berub_g1 = bercoding(EbN0,'conv','soft',1/2,spect_g1); % BER bound

spect_g2 = distspec(trellis(2,:),4);
berub_g2 = bercoding(EbN0,'conv','soft',1/2,spect_g2); % BER bound

spect_g3 = distspec(trellis(3,:),4);
berub_g3 = bercoding(EbN0,'conv','soft',1/2,spect_g3); % BER bound

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

semilogy(EbN0,BER_uncoded);
hold on
semilogy(EbN0,BER_soft_g1);
hold on
semilogy(EbN0,berub_g1);
hold on
semilogy(EbN0,BER_soft_g2);
hold on
semilogy(EbN0,berub_g2);
hold on
semilogy(EbN0,BER_soft_g3);
hold on
semilogy(EbN0,berub_g3);
ylim([1e-4 1]);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('Encoders Comparison');
legend('uncoded','Encoder1(soft)', 'Encoder1(soft upperbound)','Encoder2(soft)', 'Encoder2(soft upperbound)','Encoder3(soft)', 'Encoder3(soft upperbound)','FontSize',14);
