clc;
clear all;
% Create 1x432 bits-vector
pack = randi([0 1],1,100000);
pack=[0 1 0 1 1 1 0 1 0 1];

   %% Transmitter 
%% Use convolution encoder for coding part
%  codwords=zeros(1,(length(pack))*2);
    inital_state=[0 0];   %initial state
    updated_state=[0 0];  % updated state
    
    for i=1:length(pack)
j=1;
o1=xor(pack(i),inital_state(j+1)); % o1=xor(u,D^2)
tem=xor(inital_state(j),inital_state(j+1));
o2=xor(pack(i),tem); % o2=xor(u,D,D^2)
pack_codewrd(i,:)=[o1 o2]; %bits into encoded codewords

 % updating state by shifting input bits into initial state
bit=inital_state(1,1);
updated_state=[pack(i),bit]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
inital_state=updated_state;
    end
%%  bits To Symbols
    %%%%%%%%%%% Change const
    const = [1+(1*j), -1+(1*j),  1-(1*j),-1-(1*j)]/sqrt(2);     % Constellation 1 - QPSK/4-QAM -- Divide by sqrt(2), so E_s = 1
    
    cut_m = buffer(pack,2)';
    cut_m_idx = bi2de(cut_m, 'left-msb') +1;
    symbols_pack = const(cut_m_idx); % look up symbols over constellation
    N=length(symbols_pack);
    
%     %codeword data
%     cut_m_codwrd = buffer(pack_codewrd,2)';
%     cut_m_idx_cdwrd = bi2de(cut_m_codwrd, 'left-msb') +1;
%     symbols_pack_cdwrd = const(cut_m_idx_cdwrd); % look up symbols over constellation
%     N_cdwrd=length(symbols_pack_cdwrd);
    
    % Add SNR
    SNR=[-10:2:20];
    
   for i=1:length(SNR)
       
    s=SNR(i)*symbols_pack;
    
%     OFDM_symbols=ifft(s,N); % this is our signal s
    noise=rand(1,N);
    y=s+noise; %genr_signal
    
%%
%Receiver
Received_codeword=[0011010010];

%============================== Viterbi Algorithm ========================
rx=y;
% Minimum Eucledian distance detector (soft decoding)
% Relate the detection to Detection region
metric = abs(repmat(rx.',1,4) - repmat(const, length(rx), 1)).^2; % compute the distance to each possible symbol
[tmp m_hat] = min(metric, [], 2); % find the closest for each received symbol
m_hat = m_hat'-1;   % get the index of the symbol in the constellation

symbols = const(m_hat+1);


%%
SER = symerr(cut_m_idx'-1, m_hat); %count symbol errors
b_hat_buffer = de2bi(m_hat, 2, 'left-msb')'; %make symbols into bits
b_hat = b_hat_buffer(:)'; %write as a vector
BER_uncoded(i)=(sum((abs(pack-b_hat).^2))/length(pack));
% BER(i) = biterr(pack, b_hat); %count of bit errors
% fprintf('SER = %d, BER = %d\n', SER, BER)
 end
plot(BER_uncoded) 


