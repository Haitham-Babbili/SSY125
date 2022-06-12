function [BER_coded] = Coded(N,maxNumErrs,maxNum,EbN0)

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

% parpool(length(EbN0));% parallelize
    Coded_Flag = true;     % (true) for Coded || (false) for Uncoded Simulation

    BPSK = false;           % BSPK Flag
    QPSK = true;            % QPSK Flag
    AMPM = false;           % AMPM Flag
    

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
  C_encoded= gen_2(bits);
%  C_encoded= gen_pol1(bits);
  % [MOD] symbol mapper
  %% [MOD] Symbol Mapper - Mode is based on the flags set in the beginning.
    % BPSK
    if (BPSK == true)
        modulation = 1;
    elseif (QPSK == true)
        modulation = 2;    
    elseif (AMPM == true)
        modulation = 3;
    else
        modulation = 0;
    end
    [symb_coded,const] = symbol_mapper(C_encoded,modulation);
    
    
%     s = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
% %     pack = buffer(C_encoded, 2)';               % Group bits into bits per symbol
%     s_idx = bi2de(C_encoded, 'left-msb')'+1;    
%     symb_coded = s(s_idx);                                

  %% [CHA] add Gaussian noise

Es = mean(abs(symb_coded).^2);
snr = 10^(EbN0(i)/10);
sigma = sqrt(Es/snr);
w = sigma*1/sqrt(2)*(randn(1,N)+1i*randn(1,N));
y = symb_coded + w;
    %% ==================Receiver Part ===================================
    
  % [HR] Hard Receiver
    bits_estimted = qpsk2bits(y);


%% Viterbi

v_bits = Viterbi_decoder( bits_estimted );

  %% ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = (sum(abs(v_bits-bits).^2)); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 

%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
end
BER_coded = BER;

end

