function [G2] = gen_2(pack)
%G=[1+D2+D3+D4; 1+D2+D3];
%   Detailed explanation goes here
ini_memo=[0 0 0 0];
%% Transmitter 
%% ENC] convolutional encoder
updated_memo=[0 0 0 0]; % updated state
    
 for i=1:length(pack)
% G=[1+D2+D3+D4; 1+D2+D3];
% generator 1st output
o1=xor(pack(i),ini_memo(2));
o2=xor(ini_memo(3),ini_memo(4));
output1=xor(o1,o2);
% generator 2nd output
temp=xor(ini_memo(2),ini_memo(3));
output2=xor(pack(i),temp);
G2(i,:)=[output1 output2]; % complete G

 % updating state by shifting input bits into initial state
bits=ini_memo(1:(end-1));
updated_memo=[pack(i) bits]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
 end
 G2
end

