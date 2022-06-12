function [BER, BER_uncoded_bpsk ] = uncoded(N,maxNumErrs,maxNum,EbN0)

% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  totErr_bpsk=0;
  num = 0; % Number of bits processed
  
  while((totErr < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    bits = randsrc(1,N,[0 1]);
    
  % [ENC] convolutional encoder
  

    %% [MOD] Symbol Mapper - Mode is based on the flags set in the beginning.

  % [MOD] symbol mapper
    s = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM 
    pack = buffer(bits, 2)';               % Group bits into bits per symbol
    s_idx = bi2de(pack, 'left-msb')'+1;    
    symb = s(s_idx);                                

    %%% BPSK
    s_bpsk=[1+ 1i*0 -1+1i*0];
    idx=bits+1;
%  symb_uncoded_bpsk = 2*bits - 1;
    symb_uncoded_bpsk = s_bpsk(idx);
 
  %% [CHA] add Gaussian noise
% 
Es = mean(abs(symb).^2);
snr = 10^(EbN0(i)/10);
sigma = sqrt(Es*0.5/snr);
w = sigma*1/sqrt(2)*(randn(1,N/2)+1i*randn(1,N/2));
y = symb + w;


w_bpsk = 1/sqrt(2)*10^(-EbN0(i)/20) * randn(1,N);

%     sigma_bpsk = 1/((10^(EbN0(i)/10)*2));
%     w_bpsk = sqrt(sigma_bpsk)*randn(1,N); % AWGN Channel
    y2 = symb_uncoded_bpsk + w_bpsk;
% SNR=(10^(EbN0(i)/10));
% y2=awgn(symb_uncoded_bpsk,SNR);
%     rxData = bpskDemodulator(y2); 
  %% ==================Receiver Part ===================================
  % [HR] Hard Receiver
    bits_estimted = qpsk2bits(y);

    bits_estimted_bpsk = symb2bits_bpsk(y2);

  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = (sum(abs(bits_estimted-bits).^2)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
 
  BER_bpsk = (sum(abs(bits_estimted_bpsk-bits).^2)); % count the bit errors and evaluate the bit error rate
%   BitErrs_bpsk = length(find((bits_estimted_bpsk-bits)~=0));
  totErr_bpsk = totErr_bpsk + BER_bpsk;
  
  num = num + N; 
% 
%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
  BitErrs_bpsk(i) = totErr_bpsk/num;
end
BER = BER;
BER_uncoded_bpsk = BitErrs_bpsk;
end

