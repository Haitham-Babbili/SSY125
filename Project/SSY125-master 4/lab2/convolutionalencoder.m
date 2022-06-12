function c = convolutionalencoder(E,m)

if E == 1
%myCell = {'1 + x^2', '1 + x + x^2'};
trellis = poly2trellis(3,[5 7]);
c = convenc(m,trellis);
end

if E == 2
%myCell = {'1 + x^2 + x^3 + x^4', '1 + x^2 + x^3'};
trellis = poly2trellis(5,[27 26]);
c = convenc(m,trellis);
end

if E == 3
%myCell = {'1 + x^3 + x^4', '1 + x + x^3 + x^4'};
trellis = poly2trellis(5,[23 33]);
c = convenc(m,trellis);
end

% Not done
if E == 4
% myCell = {'(1 + x^2)/x^3','1','0'
%           '(1 + x^2)/x^3','0','1'};
%myCell = {'1 + x^2','x^3','0'
%          '1 + x^2','0','x^3'};
trellis = poly2trellis([4 0], [2 1 0 ; 4 0 1],[11 10] );
c = convenc(m,trellis);
end

end