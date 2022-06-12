function symb = ampm(bits)
bpm = 3;
N2 = length(bits);
m = reshape(bits,[bpm, N2/bpm])';
mdec = bi2de(m,'left-msb')+1;


constellation = [-1-1j -3+3*1j 1+3*1j -3-1j 3-3*1j -1+1j 3+1j -1-3*1j]; % QPSK

symb = constellation(mdec);

end