function [ est_bits ] = qpsk2bits( x )
% Transfer the qpsk to bits
bit_rx=zeros(length(x),2); % make zero matrix
% function objective: Is to compare estimated sybmols and then mapped on
% bits by deciding the coordrant.

for i=1:length(x)

    if real(x(i))>=0 && imag(x(i))>=0
        bit_rx(i,:) = [0;0];
    elseif real(x(i))>=0 && imag(x(i))<0
        bit_rx(i,:) = [0;1];
    elseif real(x(i))<0 && imag(x(i))<0
        bit_rx(i,:) = [1;1];
    else
        bit_rx(i,:) = [1;0];
    end
end
bit_rx=bit_rx';
est_bits=reshape(bit_rx,1,length(x)*2);
end

