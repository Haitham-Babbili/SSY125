function output = add_awgn(symbol,EbN0)
% This function is for simulation of additive Gaussian Noise Channel
% Input
% symbol is the symbols to transmit
% EbN0 is Eb/N0 
% Output
% output is symbol after awgn channel
%% This part only for QPSK mapper
Es = mean(abs(symbol).^2);
snr = 10^(EbN0/10);
n = length(symbol);
sigma = sqrt(Es/snr);
w = sigma*1/sqrt(2)*(randn(1,n)+1i*randn(1,n));
output = symbol + w;
end