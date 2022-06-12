function [Symb_vec,const] = symbol_mapper(c,modulation)
    % BPSK Selection - 0 as 1, 1 as -1
    if (modulation == 1)
        const=[-1 1];
        Symb_vec = zeros(1,length(c));
        for n = 1:length(c)
            if c(n)==0
                Symb_vec(n)=-1;
            end
            if c(n)==1
                Symb_vec(n)=1;
            end
        end
    end

    % QPSK Selection - Gray code labeling
    if (modulation == 2)
        const = [(1 +1i), (1 -1i), (-1 +1i), (-1 -1i)]/sqrt(2);
        m = reshape(c,[2,length(c)/2]);
        m = m';
        m_idx = bi2de(m, 'left-msb');
        m_idx = m_idx'+1;
        Symb_vec = const(m_idx);
    end

    % AMPM Selection - Labeling from figure 2 in project description.
    if (modulation == 3)
        if (length(c) > 150000)
            c = [c 0 0 0 0]; %(Cant divide 200k/3, so add 4 0's.) Coded -1/2 Rate => Length is 200k.
        else
            c = [c 0 0]; %(Cant divide 100k/3, so add 2 0's.) Uncoded - 1 Rate => Length is 200k.
        end
        const=[(1 -1i), (-3 +3i), (1 +3i), (-3 -1i), (3 -3i), (-1 +1i), (3 +1i), (-1 -3i)]/sqrt(12);
        m = reshape(c,[3,length(c)/3]);
        m = m';
        m_idx = bi2de(m, 'left-msb');
        m_idx = m_idx'+1;
        Symb_vec = const(m_idx);
    end
end

