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
N=16;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range
% ======================================================================= %

BER_uncoded= uncoded(N,maxNumErrs,maxNum,EbN0);
BER_coded= Coded(N,maxNumErrs,maxNum,EbN0);

% Ploting starts here

semilogy(EbN0,BER_coded);
hold on
semilogy(EbN0,BER_uncoded);
% ylim([1e-4 1]);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('BER versus Eb/N0');
legend('BER coded', 'BER Uncoded');
