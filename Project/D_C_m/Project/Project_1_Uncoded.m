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
maxNum = 1e7; % OR stop if maxNum bits have been simulated
EbN0 = -1:0.5:12; % power efficiency range
% ======================================================================= %
% Other Options
% ======================================================================= %
% ...

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

% parpool(length(EbN0));% parallelize

parfor i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed
  
  while((totErr < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    b = randsrc(1,N,[0 1]);
    
  % [ENC] convolutional encoder

  % [MOD] symbol mapper
    s = [(1 + 1i) (1 - 1i) (-1 + 1i) (-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
                                                        % s = exp(1i*((0:3)*pi/2 + pi/4)); % Constellation 1 - same constellation generated as PSK
    packets_buffer = buffer(b, 2)';               % Group bits into bits per symbol
    sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
    symbols = s(sym_idx);                               % Look up symbols using the indices  

  % [CHA] add Gaussian noise
    sigma = 1/((10^(EbN0(i)/10)*2*2));
    w = sqrt(sigma)*(randn(1,N/2) + 1i*randn(1,N/2)); % AWGN Channel
    y = symbols + w;

  % scatterplot: plot(y, 'b.')  
    % figure;plot(y, 'b.');
  % [HR] Hard Receiver
  % ...
    bitsRec = symbols2bits(y);
  % [SR] Soft Receiver
  % ...
  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = length(find((bitsRec-b)~=0)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 

%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
   end 
  BER(i) = totErr/num; 
end
BER_uncoded = BER;
figure;semilogy(EbN0,BER_uncoded);
xlabel('Eb/N0 [dB]');ylabel('BER');grid on;
title('BER versus Eb/N0');
% ======================================================================= %
% End
% ======================================================================= %