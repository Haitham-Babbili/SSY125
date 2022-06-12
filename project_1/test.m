N =5000;
encode_mod = 2;
bits = src_generate(N);
bits_encoded = encoder(bits,encode_mod);%encode by encoder 1
bits_encoded(bits_encoded == 0) = -1;
% x = mapper(bits_encoded,1);
[code,message] = Viterbi_soft(bits_encoded,encode_mod);%decode by 1
message = message(1:length(bits));
BitErrs = biterr(bits,message);
disp('BER: ');
disp(BitErrs);
