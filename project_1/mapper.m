function symbol = mapper(bits,mod)
% This function is used for symbol mapper
% Input
% bit is bits stream
% mod is to choose which mapper you want to use
% Ouput
% symbol is mapped symbol

if rem(length(bits),2) == 1
    error('bits must be of even length');
end
bits(bits ~= 0) = 1;
bits(bits == 0) = -1;
real = bits(1:2:end);
imag = bits(2:2:end);

symbol = (real*1+imag*1j)/sqrt(2);
end