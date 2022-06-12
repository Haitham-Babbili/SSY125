function [ symbols ] = bits2symbols( code_bit0, code_bit1 )
% Transfer the data bits to symbols
% Constellation or bit to symbol mapping
s = [(1 + 1i) (-1 + 1i) (1 - 1i) (-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
                                                        % s = exp(1i*((0:3)*pi/2 + pi/4)); % Constellation 1 - same constellation generated as PSK
% scatterplot(s); grid on;                            % Constellation visualization
packets_buffer = [code_bit0' code_bit1'];               % Group bits into bits per symbol
sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
symbols = s(sym_idx);                                     % Look up symbols using the indices  

end

