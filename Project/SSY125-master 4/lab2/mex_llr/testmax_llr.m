bits = [ 1 0 0 1 1 1 1 0 0 0 1 0 1 1 0 0 1 0 1 1 1 ]
constellation = [-1-1j -3+3*1j 1+3*1j -3-1j 3-3*1j -1+1j 3+1j -1-3*1j]; % QPSK
mapping = [0 1 2 3 4 5 6 7];
symbols = ampm(bits);

demod_obj = mex_llr_demod(constellation, mapping, 'approx')

%out = calc_llr(demod_obj,symbols,0.1)
