function compile_mex_calc_llr

if ispc %windows   
    display('Compiling mex_calc_llr.cpp');
    mex -O -L. -output ./mex_calc_llr ./mex_calc_llr.cpp       
else %linux
    display('Compiling mex_calc_llr.cpp');
    mex -O -L. CC=gcc4 -output ./mex_calc_llr ./mex_calc_llr.cpp
end