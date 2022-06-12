% ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D2, 1 + D + D2)
% Gray-mapping QPSK
% ======================================================================= %
clc
clear all;

% ======================================================================= %
% Simulation Parameters
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
% N=10;
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range
% ======================================================================= %
[BER_uncoded_qpsk,BER_uncoded_bpsk]= uncoded(N,maxNumErrs,maxNum,EbN0);
% [BER_uncoded_bpsk,BER_uncoded_qpsk]= Uncoded_part2_3(N,maxNumErrs,maxNum,EbN0);
[BER_soft_bpsk,BER_soft_qpsk,trellis]= Coded_part2_3(N,maxNumErrs,maxNum,EbN0);

[BER_g4_Am] = Coded_part2_3_g4(N,maxNumErrs,maxNum,EbN0);
[BER_Uncoded_g4_Am] = Uncoded_part2_3_g4(N,maxNumErrs,maxNum,EbN0);

% spect_g1 = distspec(trellis(1,:),4);
% berub_g1 = bercoding(EbN0,'conv','soft',1/2,spect_g1); % BER bound
% 
% spect_g2 = distspec(trellis(2,:),4);
% berub_g2 = bercoding(EbN0,'conv','soft',1/2,spect_g2); % BER bound

% spect_g3 = distspec(trellis(1,:),4);
% berub_g3 = bercoding(EbN0,'conv','soft',1/2,spect_g3); % BER bound


% capacity calculation
R=[0.5 1 2];
for i=1:length(R)
capacity(i)= 10*log10((2^R(i)-1)/R(i));
end
% BER_uncoded_bpsk=[0.1040 0.0786 0.0563 0.0376 0.0228 0.0127 0.0060 0.0024 1.0e-03*0.7710 1.0e-03*0.1680];


semilogy(EbN0,BER_soft_bpsk);
hold on
semilogy(EbN0,BER_soft_qpsk);
hold on
semilogy(EbN0,BER_uncoded_bpsk);
hold on
semilogy(EbN0,BER_uncoded_qpsk);
hold on
% semilogy(EbN0,berub_g2);
% hold on
% semilogy(EbN0,berub_g3);
% hold on
semilogy(EbN0,BER_g4_Am);
hold on
semilogy(EbN0,BER_Uncoded_g4_Am);
hold on
xline(capacity(1),'r','BPSK capacity');
hold on
xline(capacity(2),'b','QPSK capacity');
hold on
xline(capacity(3),'g','AMPA capacity');

ylim([1e-4 1]);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('Encoders Comparison');
legend({'Soft Coded Bpsk','Soft Coded Qpsk','Uncoded Bpsk','Uncoded Qpsk','G4 Soft Coded AMPM','G4 Uncoded AMPM'},'FontSize',14);
