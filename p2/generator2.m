function [output] = generator2(c)
% This function is used for convolutional Encoder
% Input
% c is the source information bit

% Output
% output is encoded information

        d1 = [1,0,1,1,1];
        d2 = [1,0,1,1,0];
        u1 = conv(c,d1);
        u1 = rem(u1,2);
        u2 = conv(c,d2);
        u2 = rem(u2,2);
        output = zeros(1,length(u1)+length(u2));
        output(1:2:end) = u1;
        output(2:2:end) = u2;
 
end