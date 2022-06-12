function [BER_uncoded_bpsk,BER_uncoded_qpsk] = Uncoded_part2_3(N,maxNumErrs,maxNum,EbN0)

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

% % parpool(length(EbN0));% parallelize
%     Coded_Flag = true;     % (true) for Coded || (false) for Uncoded Simulation
% 
%     BPSK = false;           % BSPK Flag
%     QPSK = true;            % QPSK Flag
%     AMPM = false;           % AMPM Flag
%     

for i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
%   totErr_soft_g1= 0;  % Number of errors observed
  totErr_uncoded_qpsk=0;
  totErr_uncoded_bpsk=0;
  num = 0; % Number of bits processed
  
  while((totErr_uncoded_qpsk < maxNumErrs) && (num < maxNum)) 
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
%     if (BPSK == true)
%         modulation = 1;
%     %QPSK    
%     elseif (QPSK == true)
%         modulation = 2;
%     %AMPM    
%     elseif (AMPM == true)
%         modulation = 3;
%     else
%         modulation = 0;
%     end
%     
%     [symb_code_qpsk,const,trellis_qpsk] = symbol_mapper_3(bits,modulation);
%     modulation=1;
%      [symb_code_bpsk,const,trellis] = symbol_mapper_3(bits,modulation); % 1 means bpsk selection
  % [MOD] symbol mapper
    % QPSK
    const_qpsk = [(1 + 1i) (1 - 1i) (-1 + 1i) (-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
                                                        % s = exp(1i*((0:3)*pi/2 + pi/4)); % Constellation 1 - same constellation generated as PSK
    packets_buffer = buffer(bits, 2)';               % Group bits into bits per symbol
    sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
    symb_uncoded_qpsk = const_qpsk(sym_idx);  
    
 % BPSK
%  const_bpsk=[-1 1];
 
%  symb_uncoded_bpsk = zeros(1,length(bits));
%         for n = 1:length(bits)
%             if bits(n)==0
%                 symb_uncoded_bpsk(n)=-1;
%             else bits(n)==1
%                 symb_uncoded_bpsk(n)=1;
%             end
%         end
 symb_uncoded_bpsk = 2*bits - 1;
%     packets_buffer = buffer(bits, 2)';               % Group bits into bits per symbol
%     sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
%     symb_uncoded_bpsk = const_bpsk(sym_idx); 
    
%      ber = berawgn(EbN0,'qam',4,symb_coded);                          

  %% [CHA] add Gaussian noise
%   
%     sigma = 1/(10^(EbN0(i)/10)*0.5*2*2);
%     w = sqrt(sigma)*(randn(1,N+4) + 1i*randn(1,N+4)); % AWGN Channel

    Es = mean(abs(symb_uncoded_qpsk).^2);
    snr = 10^(EbN0(i)/10);
    sigma = sqrt(Es*0.5/snr);
    w_uncoded_qpsk = sigma*1/sqrt(2)*(randn(1,N/2)+1i*randn(1,N/2));

%     sigma_bpsk = 1/(10^(EbN0(i)/10)*0.5*2);
%     w_bpsk = sqrt(sigma_bpsk)*randn(1,2*(N+4)); % AWGN Channel
    sigma_bpsk = 1/((10^(EbN0(i)/10)*2));
    w_bpsk = sqrt(sigma_bpsk)*randn(1,N); % AWGN Channel
    
    
%     y1 = symb_coded(1,:) + w;
    y2 = symb_uncoded_bpsk + w_bpsk;
    y3 = symb_uncoded_qpsk + w_uncoded_qpsk;
    
    
    
    %% ==================Receiver Part ===================================
bits_estimted_bpsk = symb2bits_bpsk(y2);
bits_estimted_qpsk= qpsk2bits(y3);
  %% ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
%   BitErrs_soft_g1 = (sum(abs(err_soft_g1).^2)); % count the bit errors and evaluate the bit error rate
%   totErr_soft_g1 = totErr_soft_g1 + BitErrs_soft_g1;
 
%    
  BitErrs_uncoded_bpsk = (sum(abs(bits_estimted_bpsk-bits).^2)); % count the bit errors and evaluate the bit error rate
%   BitErrs_uncoded_bpsk = length(find((bits_estimted_bpsk-bits)~=0));
  totErr_uncoded_bpsk = totErr_uncoded_bpsk + BitErrs_uncoded_bpsk;
  
  
  BitErrs_uncoded_qpsk = (sum(abs(bits_estimted_qpsk-bits).^2)); % count the bit errors and evaluate the bit error rate
  totErr_uncoded_qpsk = totErr_uncoded_qpsk + BitErrs_uncoded_qpsk;
  
 num = num + N; 
%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
%   BER_soft_g1(i) = totErr_soft_g1/num; 
  BitErrs_uncoded_bpsk(i) = totErr_uncoded_bpsk/num;
  BitErrs_uncoded_qpsk(i) = totErr_uncoded_qpsk/num;
end
% BER_soft_g1 = BER_soft_g1;
BER_uncoded_bpsk = BitErrs_uncoded_bpsk;
BER_uncoded_qpsk = BitErrs_uncoded_qpsk;

end

