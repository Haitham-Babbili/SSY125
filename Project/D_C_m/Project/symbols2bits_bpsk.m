function [ Xhat ] = symbols2bits_bpsk( y )
% Transfer the symbols back to data bits
Xhat = zeros(length(y),0);
for i=1:length(y)
    if y(i)>0
        Xhat(i) = 1;
    else
        Xhat(i) = 0;
    end
end
end

