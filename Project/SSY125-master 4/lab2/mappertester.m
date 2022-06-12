%mapper tester

clc
clear
N = 10002;   % simulate N bits  each  transmission (one  block)
bpm = 3; %bits per message
E = 4;

m = randi([0 1],1,N);
% [ENC] convolutional  encoder

c = convolutionalencoder(E,m);

% c = [c 1]; % Hardcoding to fit E4 + QPSK
a = symbolmapper(c,bpm);
scatterplot(a);grid on;