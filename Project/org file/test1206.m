clc;
clear all;
% Create 1x432 bits-vector
    pack = randi([0 1],1,100000);
% pack=[0 1];
   %% Transmitter 
    %% Use convolution encoder for coding part
%     enco_mem=[0 0];   %# of memory elements=3
% encoded_sequence=zeros(1,(length(pack))*2);
% 
% o1=xor(pack,enco_mem(2)); % o1=xor(u,D^2)
% o2=xor(pack,enco_mem(1),enco_mem(2)); % o2=xor(u,D,D^2)
%     
% pack_codewrd=[o1 o2]; %bits into encoded codewords
 
    
%%  bits To Symbols
    %%%%%%%%%%% Change const
    const = [1+(1*j), -1+(1*j),  1-(1*j),-1-(1*j)]/sqrt(2);     % Constellation 1 - QPSK/4-QAM -- Divide by sqrt(2), so E_s = 1
    
    cut_m = buffer(pack,2)';
    cut_m_idx = bi2de(cut_m, 'left-msb') +1;
    symbols_pack = const(cut_m_idx); % look up symbols over constellation
    N=length(symbols_pack);
    
    %codeword data
%     cut_m_codwrd = buffer(pack_codewrd,2)';
%     cut_m_idx_cdwrd = bi2de(cut_m_codwrd, 'left-msb') +1;
%     symbols_pack_cdwrd = const(cut_m_idx_cdwrd); % look up symbols over constellation
%     N_cdwrd=length(symbols_pack_cdwrd);
    
    % Add SNR
    SNR=[0:2:20];
    
   for i=1:length(SNR)
       
    s=SNR(i)*symbols_pack;
    
%     OFDM_symbols=ifft(s,N); % this is our signal s
    noise=rand(1,N);
    y=s+noise; %genr_signal
    
% %% Symbols To Signal
%     M = length(const);
%     bpsymb = log2(M);           % Number of bits per Symbol
%     Rb = 500;                   % bit rate [bit/sec] 
%     fsymb = Rb / bpsymb;        % Symbol rate [symb/s]
%     Tsymb = 1 / fsymb;          % Symbol time
%     fs = 50000;                 % sampling Frequency [Hz]       
%     fsfd = ceil(fs / fsymb);          % Number of samples per symbol (choose fs such that fsfd is an integer for simplicity) [samples/symb]
%     Tsamp = 1/fs;               % Sampling time
%     
% 
% 
%     symbols_upsample = upsample(symbols, fsfd);     % Space the symbols fsfd apart, to enable pulse shaping using conv.
%     % Create Signal
%     span = 8;                                       % how many symbol times do we want of pulse (note that RC and RRC is not zero outside of symbol time!)
%     [pulse, t] = rtrcpuls(0.4,1/fsymb,fs,span);  

%     signal = conv(pulse,symbols_upsample);
%     x = length(symbols);
%     y = length(pulse);
%     m = x+y-1;
%     for i=1:x
%     signal(i)=0;
%     for j=1:x
%         if(i-j+1>0)
%             signal(i)=signal(i)+symbols_upsample(j)*pulse(i-j+1);
%         else
%         end
%     end
% end
    
  
    
    
% %% Signal on Carrier
%     fc = 4000;
%    
% theta = 0;
% 
% tx_signal_real = real(signal) .* cos(2*pi*fc*(0:length(signal)-1)*Tsamp + theta) .* sqrt(2);
% tx_signal_imag = imag(signal) .* sin(2*pi*fc*(0:length(signal)-1)*Tsamp + theta) .* sqrt(2);
% tx_signal = tx_signal_real + tx_signal_imag;
% 
%     figure(); 
%     plot(tx_signal);
%     title('Tx Signal')
% 
%     toc
%% Reciever 


% %% Signal to Symbols
% % Real Part
% % Add AWGN noise to the signal
%     SNRdB = 0; %decide noise level
%     tx_signal = awgn(symbols_pack, SNRdB, 'measured'); % add noise
% 
% %%%%%%%%%%%%%%%%% SCALING PARAMETER NEEDED?!?!?!?
%     rx_real = tx_signal .* cos(2*pi*fc*(0:length(signal)-1)*Tsamp) .* sqrt(2);
%     rx_imag = tx_signal .* (1*j).*sin(2*pi*fc*(0:length(signal)-1)*Tsamp) .* sqrt(2);
%     
%     rx_signal = rx_real + rx_imag;

% % Correlation
% corr = conv(real(rx_vec), real(fliplr(rx_preamble)));   % correlate the sequence and received vector
% figure; plot(1:length(corr),corr, '.-r')       % plot correlation
% 
% [tmp, Tmax] = max(corr);       %find location of max correlation
% Tx_hat = Tmax - length(rx_preamble);  %find delay (it will take length(pream
% fprintf('delay = %d, estimation = %d\n', delay, Tx_hat)
% rx_preamble = rx_vec(Tx_hat+1:Tx_hat+length(preamble));
% rx_vec = rx_vec(Tx_hat+length(rx_preamble)+1:end);
%     

%%
%Receiver
rx=y;
% Minimum Eucledian distance detector
% Relate the detection to Detection region
metric = abs(repmat(rx.',1,4) - repmat(const, length(rx), 1)).^2; % compute the distance to each possible symbol
[tmp m_hat] = min(metric, [], 2); % find the closest for each received symbol
m_hat = m_hat'-1;   % get the index of the symbol in the constellation

symbols = const(m_hat+1);


%%
SER = symerr(cut_m_idx'-1, m_hat); %count symbol errors
b_hat_buffer = de2bi(m_hat, 2, 'left-msb')'; %make symbols into bits
b_hat = b_hat_buffer(:)'; %write as a vector
BER(i)=(sum((abs(pack-b_hat).^2))/length(pack));
% BER(i) = biterr(pack, b_hat); %count of bit errors
% fprintf('SER = %d, BER = %d\n', SER, BER)
 end
BER 

plot(BER)
