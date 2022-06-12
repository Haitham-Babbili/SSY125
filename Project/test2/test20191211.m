clc;
clear all;
% Create 1x432 bits-vector
%pack = randi([0 1],1,100000);
pack=[0 1 0 1 1 1 0 1 0 1];

   %% Transmitter 
%% Use convolution encoder for coding part
flag = 0
switch flag
case 0
function [G1] = Generator1(pack,initial_memory)
%UNTITLED17 Summary of this function goes here
ini_memo=initial_memory
%   Detailed explanation goes here
%% Transmitter 
%% ENC] convolutional encoder
%  codwords=zeros(1,(length(pack))*2);
    updated_memo=[0 0]; % updated state
    
    for i=1:length(pack)
j=1;
output1=xor(pack(i),ini_memo(2)); % output1=xor(u,D^2)
tem=xor(ini_memo(1),ini_memo(2));
output2=xor(pack(i),tem); % output2=xor(u,D,D^2)
code_word(i,:)=[output1 output2]; %bits into encoded codewords

 % updating state by shifting input bits into initial state
bit=ini_memo(1,1);
updated_memo=[pack(i),bit]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
    end
end

 %%   
case 1
    
function [G2] = Generator2(u,initial_memory)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
ini_memo=initial_memory
%% Transmitter 
%% ENC] convolutional encoder
updated_memo=[0 0 0 0]; % updated state
    
 for i=1:length(u)
% G=[1+D2+D3+D4; 1+D2+D3];
% generator 1st output
o1=xor(u(i),ini_memo(2));
o2=xor(ini_memo(3),ini_memo(4));
output1=xor(o1,o2);
% generator 2nd output
temp=xor(ini_memo(2),ini_memo(3));
output2=xor(u(i),temp);
G2(i,:)=[output1 output2]; % complete G

 % updating state by shifting input bits into initial state
bits=ini_memo(1:(end-1));
updated_memo=[u(i) bits]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
 end
 
end

%%
case 2
function [G3] = Generator3(u,initial_memory)
%UNTITLED16 Summary of this function goes here
ini_memo=initial_memory
%   Detailed explanation goes here
%% Transmitter 
%% ENC] convolutional encoder
%     ini_memo(1)
    updated_memo=[0 0 0 0]; % updated state
    
 for i=1:length(u)
% G=[1+D3+D4; 1+D+D3+D4];
% generator 1st output
o1=xor(u(i),ini_memo(3));
output1=xor(o1,ini_memo(4));
% generator 2nd output
temp1=xor(u(i),ini_memo(1));
temp2=xor(ini_memo(3),ini_memo(4));
output2=xor(temp1,temp2);

G3(i,:)=[output1 output2]; % complete G

 % updating state by shifting input bits into initial state
bits=ini_memo(1:(end-1));
updated_memo=[u(i) bits]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
 end
end


end
%%
%%  bits To Symbols
    %%%%%%%%%%% Change const
    const = [1+(1*j),-1+(1*j),1-(1*j),-1-(1*j)]/sqrt(2);     % Constellation 1 - QPSK/4-QAM -- Divide by sqrt(2), so E_s = 1
    
    cut_m = buffer(pack,2)';
    cut_m_idx = bi2de(cut_m, 'left-msb') +1;
    symbols_pack = const(cut_m_idx); % look up symbols over constellation
    N=length(symbols_pack);
    
%     %codeword data
%     cut_m_codwrd = buffer(pack_codewrd,2)';
%     cut_m_idx_cdwrd = bi2de(cut_m_codwrd, 'left-msb') +1;
%     symbols_pack_cdwrd = const(cut_m_idx_cdwrd); % look up symbols over constellation
%     N_cdwrd=length(symbols_pack_cdwrd);
    
    %% Add SNR
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
