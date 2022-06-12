function [G1] = Generator1(message_pack,initial_memory)
%UNTITLED17 Summary of this function goes here
ini_memo=initial_memory
%   Detailed explanation goes here
%% Transmitter 
%% ENC] convolutional encoder
%  codwords=zeros(1,(length(message_pack))*2);
    updated_memo=[0 0]; % updated state
    
    for i=1:length(message_pack)
j=1;
output1=xor(message_pack(i),ini_memo(2)); % output1=xor(u,D^2)
tem=xor(ini_memo(1),ini_memo(2));
output2=xor(message_pack(i),tem); % output2=xor(u,D,D^2)
code_word(i,:)=[output1 output2]; %bits into encoded codewords

 % updating state by shifting input bits into initial state
bit=ini_memo(1,1);
updated_memo=[message_pack(i),bit]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
    end
end

