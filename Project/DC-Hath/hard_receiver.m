function message = hard_receiver(y,encoder)
% This function is used for hard receiver for this system.
% Input
% y is the receive signal
% encoder is the encode type
% Output
% output is decision by hard receiver.
y_r = real(y);
y_i = imag(y);
y_r = heaviside(y_r);
y_i = heaviside(y_i);
y_bit = zeros(1,2*length(y_r));
y_bit(1:2:end) = y_r;
y_bit(2:2:end) = y_i;

switch encoder
    case 0
        message = y_bit;
    case 1
        message = Viterbi(y_bit);
    case 2
        message = Viterbi(y_bit);
    case 3
        message = Viterbi(y_bit);
end
end