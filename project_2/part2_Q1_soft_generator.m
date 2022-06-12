% ======================================================================= %
% SSY125 Project Part 1
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
t = poly2trellis(5,[27,26]);
spect = distspec(t,15);

for encode_mod = [0,2]

% ======================================================================= %
% Other Options
% ======================================================================= %
% ...

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

parfor (i = 1:length(EbN0),4) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
  % ... 
    bits = src_generate(N);
  % [ENC] convolutional encoder
  % ...
    bits_encoded = encoder(bits,encode_mod);%encode by encoder 1
%     bits_encoded = bits;
  % [MOD] symbol mapper
  % ...
    x = mapper(bits_encoded,1);
  % [CHA] add Gaussian noise
  % ...
    y = add_awgn(x,EbN0(i),encode_mod);
  % scatterplot: plot(y, 'b.')  
%     figure();
%     plot(y,'b.')
  % [HR] Hard Receiver
  % ...
%     y_hard = hard_receiver(y,encode_mod);%decode by 1
%     y_final = y_hard(1:length(bits));
  % [SR] Soft Receiver
    y_soft = soft_receiver(y,encode_mod);%decode by 1
    y_final = y_soft(1:length(bits));
  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = biterr(bits,y_final); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 

  disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
      num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
      num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 
  BER_ub(i) = 0;
  Rc = 1/2;
  for n = 1:15
      d = spect.dfree + n - 1;
      BER_ub(i) = BER_ub(i) + spect.weight(n)*qfunc(sqrt(2*Rc*d*10.^(EbN0(i)/10)));
  end
end
figure(1);
semilogy(EbN0,BER);ylim([1e-4,1]);hold on;
end

semilogy(EbN0,BER_ub);
legend('uncoded transmission','coded transmision with encoder 2','theoritical BER upper bound');

xlabel('EbN0');
ylabel('BER');
title('Part2 Q1 soft receiver');
% ======================================================================= %
% End
% ====================================================================== %