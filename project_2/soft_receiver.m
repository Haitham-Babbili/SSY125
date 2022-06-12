function message = soft_receiver(y,encoder)
% This function is used for hard receiver for this system.
% Input
% y is the receive signal
% encoder is the encode type
% Output
% output is decision by hard receiver.
y_r = real(y);
y_i = imag(y);
if encoder == 0
    y_r = heaviside(y_r);
    y_i = heaviside(y_i);
end
y_bit = zeros(1,2*length(y_r));
y_bit(1:2:end) = y_r;
y_bit(2:2:end) = y_i;


switch encoder
    case 0
        message = y_bit;
    case 1
        [code,message] = Viterbi_soft(y_bit,encoder);
%         code(code < 0.5) = 0;
%         code(code >= 0.5) = 1;
%         [~,message] = Viterbi_soft(code,encoder);
    case 2
        [code,message] = Viterbi_soft(y_bit,encoder);
    case 3
        [code,message] = Viterbi_soft(y_bit,encoder);
end


end