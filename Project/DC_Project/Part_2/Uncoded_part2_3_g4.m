function [BER_Uncoded_g4_Am] = Uncoded_part2_3_g4(N,maxNumErrs,maxNum,EbN0)
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
    bits = randsrc(1,N,[0 1]);
    
%     infobits = bits; % zero termination
  % [ENC] convolutional encoder
    const = [1-1i -3+3i 1+3i -3-1i 3-3i -1+1i 3+1i -1-3i]/sqrt(10);
%     trellis = poly2trellis([4 4],[4 11 0;2 0 11]);
%     dataEnc = convenc(infobits, trellis);
    packets = buffer(bits, 3)';
    sym = bi2de(packets, 'left-msb')'+1;
    symbols = const(sym);
  % [CHA] add Gaussian noise
    sigma = 1/(10^(EbN0(i)/10)*3*2);
    w = sqrt(sigma)*(randn(1,ceil(N/3)) + 1i*randn(1,ceil(N/3))); % AWGN Channel
    y = symbols + w;
  % uncoded version
    bits_recevd = symb2bits_g4(const,y);
    bits_recevd = bits_recevd(1:N);
    err = bits-bits_recevd;
  % scatterplot: plot(y, 'b.')  
  % figure;plot(y, 'b.');
  % [HR] Hard Receiver     bits_encoded = symbols2bits(y); % demap symbol
%     bits_encoded = symbols2bits(y); % demap symbol
%     tblen = 3*5; % traceback length (usually five times of the constraint length of the code)
%     bits_decoded = vitdec(bits_encoded,trellis,tblen,'trunc','hard');
%     err = b-bits_decoded; % compare to find errors
  % [SR] Soft Receiver
  % ...
  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
%   BitErrs = length(find(err~=0)); % count the bit errors and evaluate the bit error rate
  BitErrs = (sum(abs(bits-bits_recevd).^2));
  totErr = totErr + BitErrs;
  num = num + N;

%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
end
BER_Uncoded_g4_Am=BER;
end
% ======================================================================= %
% End
% ======================================================================= %