function [code_word] = gen_pol1(pack)
%UNTITLED17 Summary of this function goes here
ini_memo=[0 0];
%   Detailed explanation goes here

% [ENC] convolutional encoder
    updat_memo=[0 0]; % updated state
    
    for i=1:length(pack)
j=1;
output1=xor(pack(i),ini_memo(2)); % C1=xor(u,D^2)
temp=xor(ini_memo(1),ini_memo(2));
output2=xor(pack(i),temp); % C2=xor(u,D,D^2)
code_word(i,:)=[output1 output2]; %bits to encoded codewords

% updating state by shifting input bits into initial state
bit=ini_memo(1);
updat_memo=[pack(i),bit]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updat_memo;
    end
    
end

