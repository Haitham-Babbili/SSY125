function x = symbolmapper(c,bpm)
% [MOD] symbol  mapper

if bpm == 1
% BPSK
X = [1+1i*0 -1+1i*0];
idx = c+1;
x = X(idx);
end

if bpm == 2
% QPSK-GRAY
m = reshape(c,[bpm, length(c)/bpm])';
idx = bi2de(m,'left-msb')+1;
X = (1/sqrt(2)).*[1+1j 1-1j -1+1j -1-1j];
x = X(idx);
end

if bpm ==3
% AMPM
m = reshape(c,[bpm, length(c)/bpm])';
idx = bi2de(m,'left-msb')+1;
a = 8/sqrt(240);
X = a.*[1-1i -3+3*1i 1+3*1j -3-1j 3-3*1j -1+1j 3+1j -1-3*1j];
x = X(idx);
end

end