% ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D2, 1 + D + D2)
% Gray-mapping QPSK
% ======================================================================= %
clc
clear

% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range
% ======================================================================= %
% Other Options
% ======================================================================= %
% ...

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

% parpool(length(EbN0));% parallelize

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed
  
  while((totErr < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    bits = randsrc(1,N,[0 1]);
    
  % [ENC] convolutional encoder
  C_encoded= gen_pol1(bits);

  % [MOD] symbol mapper
    s = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
                                                        % s = exp(1i*((0:3)*pi/2 + pi/4)); % Constellation 1 - same constellation generated as PSK
%     pack = buffer(C_encoded, 2)';               % Group bits into bits per symbol
    s_idx = bi2de(C_encoded, 'left-msb')'+1;    
    symb_coded = s(s_idx);                                

  % [CHA] add Gaussian noise
    sigma = 1/((10^(EbN0(i)*0.1)*4));
    noise = sqrt(sigma)*(randn(1,N) + 1i*randn(1,N)); % AWGN Channel
    y = symb_coded + noise;

    %% ==================Receiver Part ===================================
    
  % [HR] Hard Receiver
    bits_estimted = qpsk2bits(y);

% if bits_estimted==C_encoded
%     disp('Haris is a bad guy');
% end
%% Viterbi
v_bits= Viterbi_decoder(bits_estimted);

  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = (sum(abs(v_bits-bits).^2)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 
% 
%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
end
BER_coded = BER;
figure;semilogy(EbN0,BER_coded);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('BER versus Eb/N0');
% ======================================================================= %
% End
% ======================================================================= %