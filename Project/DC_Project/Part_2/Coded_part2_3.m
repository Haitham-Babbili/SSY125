function [BER_soft_bpsk,BER_soft_qpsk,trellis] = Coded_part2_3(N,maxNumErrs,maxNum,EbN0)

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
%   totErr_soft_g1= 0;  % Number of errors observed
  totErr_soft_qpsk=0;
  totErr_soft_bpsk=0;
  num = 0; % Number of bits processed
  
  while((totErr_soft_bpsk < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    bits = randsrc(1,N,[0 1]);
    
  % [ENC] convolutional encoder
  %C_encoded= gen_pol1(bits);
%   C_encoded= gen_4(bits); % 4th encoder

  % [MOD] symbol mapper
  %% [MOD] Symbol Mapper - Mode is based on the flags set in the beginning.
    % BPSK
    if (BPSK == true)
        modulation = 1;
    %QPSK    
    elseif (QPSK == true)
        modulation = 2;
    %AMPM    
    elseif (AMPM == true)
        modulation = 3;
    else
        modulation = 0;
    end
    
    [symb_code_qpsk,const,trellis_qpsk] = symbol_mapper_3(bits,modulation);
    modulation=1;
     [symb_code_bpsk,const,trellis] = symbol_mapper_3(bits,modulation); % 1 means bpsk selection

%      ber = berawgn(EbN0,'qam',4,symb_coded);                          

  %% [CHA] add Gaussian noise
  
    sigma = 1/(10^(EbN0(i)/10)*0.5*2*2);
    w = sqrt(sigma)*(randn(1,N+4) + 1i*randn(1,N+4)); % AWGN Channel
          
    sigma_bpsk = 1/(10^(EbN0(i)/10)*0.5*2);
    w_bpsk = sqrt(sigma_bpsk)*randn(1,2*(N+4)); % AWGN Channel
%     y1 = symb_coded(1,:) + w;
    y2 = symb_code_bpsk + w_bpsk;
    y3 = symb_code_qpsk + w;
    
    %% ==================Receiver Part ===================================
    
  % [HR] Hard Receiver
  
  %v_bits = Viterbi_decoder( bits_estimted ); % hard VB
%    tblen = 5*5; % traceback length (usually five times of the constraint length of the code)
  
%     bits_estimted = qpsk2bits(y);
% 
%     bits_decoded = vitdec(bits_estimted,trellis,tblen,'term','hard');
%     bits_decoded = bits_decoded(1:end-4); % discard two end bits
%     err_hard = bits(1:end)-bits_decoded; % compare to find errors

  % [SR] Soft Receiver
  
 % Soft Viterbi

% v_bits = viterbi_softDecoding(y,const);
    tblen = 5*5; % traceback length (usually five times of the constraint length of the code)
%     code1 = zeros(1,2*(N+4));
%     [~,code1(1:2:end)] = quantiz(real(y1),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
%     [~,code1(2:2:end)] = quantiz(imag(y1),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]);
%     
%     bits_decoded_g1 = vitdec(code1,trellis(1,:),tblen,'term','soft',3);
%     bits_decoded_g1 = bits_decoded_g1(1:end-4); % discard four end bits
%     err_soft_g1 = bits(1:end)-bits_decoded_g1; % compare to find errors
%      
%     code2 = zeros(1,2*(N+4));
%     [~,code2(1:2:end)] = quantiz(real(y2),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
%     [~,code2(2:2:end)] = quantiz(imag(y2),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]);
%      
%     bits_decoded_g2 = vitdec(code2,trellis,tblen,'term','soft',3);
%     bits_decoded_g2 = bits_decoded_g2(1:end-4); % discard four end bits
%     err_soft_bpsk  = bits(1:end)-bits_decoded_g2; % compare to find errors
    
    code2 = 1 - 2*y2; % Values in qcode are between 0 and 2^3-1.
    bits_decoded = vitdec(code2,trellis,tblen,'term','unquant');
    bits_decoded = bits_decoded(1:end-4); % discard four end bits
    err_soft_bpsk = bits(1:end)-bits_decoded; % compare to find errors
    
    code3 = zeros(1,2*(N+4));
    [~,code3(1:2:end)] = quantiz(real(y3),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
    [~,code3(2:2:end)] = quantiz(imag(y3),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]);
     
    bits_decoded_g3 = vitdec(code3,trellis,tblen,'term','soft',3);
    bits_decoded_g3 = bits_decoded_g3(1:end-4); % discard four end bits
    err_soft_qpsk  = bits(1:end)-bits_decoded_g3; % compare to find errors

  %% ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
%   BitErrs_soft_g1 = (sum(abs(err_soft_g1).^2)); % count the bit errors and evaluate the bit error rate
%   totErr_soft_g1 = totErr_soft_g1 + BitErrs_soft_g1;
  num = num + N; 
%    
  BitErrs_soft_g2 = (sum(abs(err_soft_bpsk).^2)); % count the bit errors and evaluate the bit error rate
  totErr_soft_bpsk = totErr_soft_bpsk + BitErrs_soft_g2;
  
  
  BitErrs_soft_g3 = (sum(abs(err_soft_qpsk).^2)); % count the bit errors and evaluate the bit error rate
  totErr_soft_qpsk = totErr_soft_qpsk + BitErrs_soft_g3;
  

%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
%   BER_soft_g1(i) = totErr_soft_g1/num; 
  BER_soft_bpsk(i) = totErr_soft_bpsk/num;
  BER_soft_qpsk(i) = totErr_soft_qpsk/num;
end
% BER_soft_g1 = BER_soft_g1;
BER_soft_bpsk = BER_soft_bpsk;
BER_soft_qpsk = BER_soft_qpsk;

end

