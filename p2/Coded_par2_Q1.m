function [BER_soft,BER_hard,trellis] = Coded_par2_Q1(N,maxNumErrs,maxNum,EbN0)

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
%   totErr_soft= 0;  % Number of errors observed
  totErr_hard=0;
  num = 0; % Number of bits processed
  
  while((totErr_hard < maxNumErrs) && (num < maxNum)) 
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
    bits = randsrc(1,N,[0 1]);
    
  % [ENC] convolutional encoder
  %C_encoded= gen_pol1(bits);
%   C_encoded= gen_4(bits); % 4th encoder
%generator 2
    d1 = [1,0,1,1,1];
        d2 = [1,0,1,1,0];
        u1 = conv(bits,d1);
        u1 = rem(u1,2);
        u2 = conv(bits,d2);
        u2 = rem(u2,2);
        output = zeros(1,length(u1)+length(u2));
        output(1:2:end) = u1;
        output(2:2:end) = u2;
        
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
%     [symb_coded] = symbol_mapper1(output,modulation);
    [symb_coded] = symbol_mapper1(output);
%      ber = berawgn(EbN0,'qam',4,symb_coded);                          

  %% [CHA] add Gaussian noise
      Es = mean(abs(symb_coded).^2);
        snr = 10^(EbN0(i)/10)/2;% Encoding introduce more bits, so need to multiple Rc, which is 1/2 in encoder 1. 
        n = length(symb_coded);
        sigma = sqrt(Es/(4*snr));
        w = sigma*1*(randn(1,n)+1i*randn(1,n));
%         
%     sigma = 1/(10^(EbN0(i)/10)*0.5*2*2);
%     w = sqrt(sigma)*(randn(1,N+4) + 1i*randn(1,N+4)); % AWGN Channel
    y = symb_coded + w;
    
    %% ==================Receiver Part ===================================
    
  % [HR] Hard Receiver
  
%   bits_decoded=Viterbi_hard(y);
bits_decoded=Viterbi(y,2)

  
  %v_bits = Viterbi_decoder( bits_estimted ); % hard VB
%    tblen = 5*5; % traceback length (usually five times of the constraint length of the code)
  
%     bits_estimted = qpsk2bits(y);

%     bits_decoded = vitdec(bits_estimted,trellis,tblen,'term','hard');
%     bits_decoded = Viterbi_decoder(bits_estimted);
    bits_decoded = bits_decoded(1:end-4); % discard two end bits
    err_hard = bits(1:end)-bits_decoded; % compare to find errors

  % [SR] Soft Receiver
  
 % Soft Viterbi

% % % v_bits = viterbi_softDecoding(y,const);
%     tblen = 5*5; % traceback length (usually five times of the constraint length of the code)
%     code1 = zeros(1,2*(N+4));
%     [~,code1(1:2:end)] = quantiz(real(y),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]); % Values in qcode are between 0 and 2^3-1.
%     [~,code1(2:2:end)] = quantiz(imag(y),[-0.75 -0.5 -0.25 0 0.25 0.5 0.75],[7 6 5 4 3 2 1 0]);
%     bits_decoded = vitdec(code1,trellis,tblen,'term','soft',3);
%     bits_decoded = bits_decoded(1:end-4); % discard four end bits
%     
%     err_soft = bits(1:end)-bits_decoded; % compare to find errors

  %% ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
%   BitErrs_soft = (sum(abs(err_soft).^2)); % count the bit errors and evaluate the bit error rate
%   totErr_soft = totErr_soft + BitErrs_soft;
%    num = num + N; 
   
   BitErrs_hard = (sum(abs(err_hard).^2)); % count the bit errors and evaluate the bit error rate
  totErr_hard = totErr_hard + BitErrs_hard;
 

%   disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
%       num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
%       num2str(totErr/num, '%10.1e') '. +++']);
  end 
%   BER_soft(i) = totErr_soft/num; 
  BER_hard(i) = totErr_hard/num; 
end
% BER_soft = BER_soft;
BER_hard = BER_hard;

end

