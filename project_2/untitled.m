function [output] = encoder(src,mod)
% This function is used for convolutional Encoder
% Input
% src is the source information bit
% mod is to choose which encoder want to use
%     0 is uncoded src
%     1 is encoder 1
%     2 is encoder 2
%     3 is encoder 3
% Output
% output is encoded information
switch mod
    case 0
        output = src;
    case 1
        d1 = [1,0,1];
        d2 = [1,1,1];
        u1 = conv(src,d1);
        u1 = rem(u1,2);
        u2 = conv(src,d2);
        u2 = rem(u2,2);
        output = zeros(1,length(u1)+length(u2));
        output(1:2:end) = u1;
        output(2:2:end) = u2;
    case 2
        d1 = [1,0,1,1,1];
        d2 = [1,0,1,1,0];
        u1 = conv(src,d1);
        u1 = rem(u1,2);
        u2 = conv(src,d2);
        u2 = rem(u2,2);
        output = zeros(1,length(u1)+length(u2));
        output(1:2:end) = u1;
        output(2:2:end) = u2;
    case 3
        d1 = [1,0,0,1,1];
        d2 = [1,1,0,1,1];
        u1 = conv(src,d1);
        u1 = rem(u1,2);
        u2 = conv(src,d2);
        u2 = rem(u2,2);
        output = zeros(1,length(u1)+length(u2));
        output(1:2:end) = u1;
        output(2:2:end) = u2;
    case 4
        src1 = src(1)
end
end