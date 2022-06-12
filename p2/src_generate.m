function output = src_generate(N)
% This function is used to generate random information bit
% Input
% The input n is the length of this random inforamtion
% Ouput
% The output is random information bits of length N
output = fix(rand(1,N)*2);
end