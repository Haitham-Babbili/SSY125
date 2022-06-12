function output = add_awgn(symbol,EbN0,encode_mod)
% This function is for simulation of additive Gaussian Noise Channel
% Input
% symbol is the symbols to transmit
% EbN0 is Eb/N0 
% Output
% output is symbol after awgn channel
%% This part only for QPSK mapper
switch encode_mod
    case 0
        Es = mean(abs(symbol).^2);% Es here is considered in the process of QPSK
        snr = 10^(EbN0/10);
        n = length(symbol);
        sigma = sqrt(Es/(4*snr));
        w = sigma*1*(randn(1,n)+1i*randn(1,n));
        output = symbol + w;
    case 1
        Es = mean(abs(symbol).^2);
        snr = 10^(EbN0/10)/2;% Encoding introduce more bits, so need to multiple Rc, which is 1/2 in encoder 1. 
        n = length(symbol);
        sigma = sqrt(Es/(4*snr));
        w = sigma*1*(randn(1,n)+1i*randn(1,n));
        output = symbol + w;
    case 2
        Es = mean(abs(symbol).^2);
        snr = 10^(EbN0/10)/2;% Encoding introduce more bits, so need to multiple Rc, which is 1/2 in encoder 1. 
        n = length(symbol);
        sigma = sqrt(Es/(4*snr));
        w = sigma*1*(randn(1,n)+1i*randn(1,n));
        output = symbol + w;
    case 3
        Es = mean(abs(symbol).^2);
        snr = 10^(EbN0/10)/2;% Encoding introduce more bits, so need to multiple Rc, which is 1/2 in encoder 1. 
        n = length(symbol);
        sigma = sqrt(Es/(4*snr));
        w = sigma*1*(randn(1,n)+1i*randn(1,n));
        output = symbol + w;
end
% Es = mean(abs(symbol).^2);
% snr = 10^(EbN0/10);
% n = length(symbol);
% sigma = sqrt(Es/snr);
% w = sigma*1/sqrt(2)*(randn(1,n)+1i*randn(1,n));
% output = symbol + w;
end