 % ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D^2, 1 + D + D^2)
% Gray-mapping QPSK
% ======================================================================= %
clc
clear

% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e7; % OR stop if maxNum bits have been simulated
EbN0 = -1:0.5:12; % power efficiency range in logarithm

% ======================================================================= %
% Other Options
% ======================================================================= %
% ...  

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results
parfor i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed
  
  while((totErr < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    b = randsrc(1,N,[0 1]);
    
    infobits = [b 0 0]; % zero termination
  % [ENC] convolutional encoder
    code_bit0=conv([1 0 1], infobits); % 1st output bit
    code_bit1=conv([1 1 1], infobits); % 2nd output bit

    code_bit0(code_bit0 == 2)=0; % for binary codes 1+1=0
    code_bit0(code_bit0 == 3)=1; % for binary codes 1+1+1=1
    code_bit1(code_bit1 == 2)=0;
    code_bit1(code_bit1 == 3)=1;

  % [MOD] symbol mapper
    symbols = bits2symbols(code_bit0(1:end-2), code_bit1(1:end-2));

  % [CHA] add Gaussian noise
    sigma = 1/(10^(EbN0(i)/10)*0.5*2*2);
    w = sqrt(sigma)*(randn(1,N+2) + 1i*randn(1,N+2)); % AWGN Channel
    y = symbols + w;

  % scatterplot: plot(y, 'b.')  
  % figure;plot(y, 'b.');
  % [HR] Hard Receiver
    bits_encoded = symbols2bits(y); % demap symbol
    bits_decoded = viterbi_hardDecoding( bits_encoded, N+2 );
    bits_decoded = bits_decoded(1:end-2); % discard two end bits
    err = b-bits_decoded; % compare to find errors
  % [SR] Soft Receiver
  % ...
  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = length(find(err~=0)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N;

  disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
      num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
      num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
end
figure;semilogy(EbN0,BER);grid on
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('BER versus Eb/N0');
% ======================================================================= %
% End
% ======================================================================= %