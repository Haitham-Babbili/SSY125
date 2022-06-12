% ======================================================================= %
% SSY125 Project
% Rate-1/2 convolutional encoder, generator polynomial G = (1 + D2 + D3 +
% D4, 1 + D2 + D3) % 10111,10110
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
for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed
  
  while((totErr < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    b = randsrc(1,N,[0 1]);
    
    infobits = [b 0 0 0 0]; % zero termination
  % [ENC] convolutional encoder
    codeGenerator1 = str2double(dec2base(bin2dec('10011'),8)); % 10111
    codeGenerator2 = str2double(dec2base(bin2dec('11011'),8)); %10110
    trellis = poly2trellis(5,[codeGenerator1 codeGenerator2]);
    dataEnc = convenc(infobits, trellis);
  
    
  % [MOD] symbol mapper
    s = [(1 + 1i) (1 - 1i) (-1 + 1i) (-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
                                                % s = exp(1i*((0:3)*pi/2 + pi/4)); % Constellation 1 - same constellation generated as PSK
    packets_buffer = buffer(dataEnc, 2)';               % Group bits into bits per symbol
    sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
    symbols = s(sym_idx);                               % Look up symbols using the indices

  % [CHA] add Gaussian noise
    sigma = 1/(10^(EbN0(i)/10)*0.5*2*2);
    w = sqrt(sigma)*(randn(1,N+4) + 1i*randn(1,N+4)); % AWGN Channel
    y = symbols + w;

  % scatterplot: plot(y, 'b.')  
  % figure;plot(y, 'b.');
  % [HR] Hard Receiver
%     bits_encoded = symbols2bits(y); % demap symbol
    tblen = 5*5; % traceback length (usually five times of the constraint length of the code)
%     bits_decoded = vitdec(bits_encoded,trellis,tblen,'term','hard');
%     bits_decoded = bits_decoded(1:end-4); % discard two end bits
%     err = b(1:end)-bits_decoded; % compare to find errors
  % [SR] Soft Receiver
    code = zeros(1,2*(N+4));
    [~,code(1:2:end)] = quantiz(real(y),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
    [~,code(2:2:end)] = quantiz(imag(y),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]);
    bits_decoded = vitdec(code,trellis,tblen,'term','soft',3);
    bits_decoded = bits_decoded(1:end-4); % discard four end bits
    err = b(1:end)-bits_decoded; % compare to find errors
  
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
xlabel('Eb/N0');ylabel('BER');
% ======================================================================= %
% End
% ======================================================================= %