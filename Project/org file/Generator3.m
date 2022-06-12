%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% clc
% clear
% close all
u=randi([0 1],1,100000); %message_pack 
u=[0 1 0 1 1];
% ======================================================================= %
% SSY125 Project
% ======================================================================= %

%% Transmitter 
%% ENC] convolutional encoder
%  codwords=zeros(1,(length(message_pack))*2);
    ini_memo=[0 0 0 0];  %initial state
%     ini_memo(1)
    updated_memo=[0 0 0 0]; % updated state
    
 for i=1:length(u)
% G=[1+D3+D4; 1+D+D3+D4];
% generator 1st output
o1=xor(u(i),ini_memo(3));
output1=xor(o1,ini_memo(4));
% generator 2nd output
temp1=xor(u(i),ini_memo(1));
temp2=xor(ini_memo(3),ini_memo(4));
output2=xor(temp1,temp2);

G3(i,:)=[output1 output2]; % complete G

 % updating state by shifting input bits into initial state
bits=ini_memo(1:(end-1));
updated_memo=[u(i) bits]; % make 1st bit from data and 2nd bit from the 1st bit of initial state
% upting state ends here
ini_memo=updated_memo;
 end
    G3