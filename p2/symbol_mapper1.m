function [symbol] = symbol_mapper1(bits)
%     % BPSK Selection - 0 as 1, 1 as -1
%     if (modulation == 1)
%         const=[-1 1];
%         Symb_vec = zeros(1,length(c));
%         for n = 1:length(c)
%             if c(n)==0
%                 Symb_vec(n)=-1;
%             end
%             if c(n)==1
%                 Symb_vec(n)=1;
%             end
%         end
%     end
% 
%     % QPSK Selection - Gray code labeling
%     if (modulation == 2)
%         const = [(1 +1i), (1 -1i), (-1 +1i), (-1 -1i)]/sqrt(2);
%         
%           infobits = [c]; % zero termination
%            packets_buffer = buffer(infobits, 2)'; 
%         sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
%         Symb_vec = const(sym_idx);  
%   % [ENC] convolutional encoder
%       
% %     %======= generator 1 =======
% %       codeGeneratorg11 = str2double(dec2base(bin2dec('101'),8)); % 10111
% %     codeGeneratorg12 = str2double(dec2base(bin2dec('111'),8)); %10110
% %     trellisg1 = poly2trellis(3,[codeGeneratorg11 codeGeneratorg12]);
% %     dataEnc_e1 = convenc(infobits, trellisg1);
% %       packets_buffer = buffer(dataEnc_e1, 2)';               % Group bits into bits per symbol
% %     sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
% %     Symb_vec_e1 = const(sym_idx);  
% %     %========== ends here==========
%     
%   %======= generator 2  =======
% %     codeGenerator1 = str2double(dec2base(bin2dec('10111'),8)); % 10111
% %     codeGenerator2 = str2double(dec2base(bin2dec('10110'),8)); %10110
% % % g2=gen_2(c);
% %     trellisg2 = poly2trellis(5,[codeGenerator1 codeGenerator2]);
% %     dataEnc_e2 = convenc(infobits, trellisg2);
% %     packets_buffer = buffer(dataEnc_e2, 2)';               % Group bits into bits per symbol
% %     sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
% %     Symb_vec = const(sym_idx);  
%     %========== ends here==========
%     
%         
% %     %======= generator 3 ======= 
% %     codeGenerator_g3_1 = str2double(dec2base(bin2dec('10011'),8)); % 10111
% %     codeGenerator_g3_2 = str2double(dec2base(bin2dec('11011'),8)); % 10110
% % %     g3=gen_pol1(c);
% %     trellis_g3 = poly2trellis(5,[codeGenerator_g3_1 codeGenerator_g3_2]);
% %     dataEnc_e3 = convenc(infobits, trellis_g3);
% %     packets_buffer = buffer(dataEnc_e3, 2)';               % Group bits into bits per symbol
% %     sym_idx = bi2de(packets_buffer, 'left-msb')'+1;     % Bits to symbol index
% %     Symb_vec_e3 = const(sym_idx);  
% %     %========== ends here==========
% 
% %     Symb_vec=[Symb_vec_e1;Symb_vec_e2;Symb_vec_e3];
% %     trellis=[trellisg1;trellisg2;trellis_g3];
% %     Symb_vec= Symb_vec;
% %     trellis= trellisg2;
%     
% % %         m = reshape(c,[2,length(c)]);
% % %         m = m';
% % %         m_idx = bi2de(m, 'left-msb');
% % %         m_idx = m_idx'+1;
% % %         Symb_vec = const(m_idx);
% % %     s = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 - 1i)]/sqrt(2); % Constellation 1 - QPSK/4-QAM
% %     pack = buffer(c, 2)';               % Group bits into bits per symbol
% %     s_idx = bi2de(pack, 'left-msb')'+1;    
% %     Symb_vec = const(s_idx);                                
% 
%     end
% 
%     % AMPM Selection - Labeling from figure 2 in project description.
%     if (modulation == 3)
%         if (length(c) > 150000)
%             c = [c 0 0 0 0]; %(Cant divide 200k/3, so add 4 0's.) Coded -1/2 Rate => Length is 200k.
%         else
%             c = [c 0 0]; %(Cant divide 100k/3, so add 2 0's.) Uncoded - 1 Rate => Length is 200k.
%         end
%         const=[(1 -1i), (-3 +3i), (1 +3i), (-3 -1i), (3 -3i), (-1 +1i), (3 +1i), (-1 -3i)]/sqrt(12);
%         m = reshape(c,[3,length(c)/3]);
%         m = m';
%         m_idx = bi2de(m, 'left-msb');
%         m_idx = m_idx'+1;
%         Symb_vec = const(m_idx);
%     end

if rem(length(bits),2) == 1
    error('bits must be of even length');
end
bits(bits ~= 0) = 1;
bits(bits == 0) = -1;
real = bits(1:2:end);
imag = bits(2:2:end);

symbol = (real*1+imag*1j)/sqrt(2);
end

