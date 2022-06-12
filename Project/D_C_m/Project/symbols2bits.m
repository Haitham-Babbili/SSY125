function [ Xhat ] = symbols2bits( y )
% Transfer the symbols back to data bits
bitsRec=zeros(length(y),2);
% s = [(1 + 1i) (1 - 1i) (-1 -1i) (-1 + 1i)];
% bitsmap = [0 0;0 1;1 0;1 1];
for i=1:length(y)
%     D1 = norm(s(1)-y(i));
%     D2 = norm(s(2)-y(i));
%     D3 = norm(s(3)-y(i));
%     D4 = norm(s(4)-y(i));
%     D = [D1 D2 D3 D4];
%     [~,I] = min(D);
%     bitsRec(i,:) = bitsmap(I,:);
    if real(y(i))>=0 && imag(y(i))>=0
        bitsRec(i,:) = [0;0];
    elseif real(y(i))>=0 && imag(y(i))<0
        bitsRec(i,:) = [0;1];
    elseif real(y(i))<0 && imag(y(i))<0
        bitsRec(i,:) = [1;1];
    else
        bitsRec(i,:) = [1;0];
    end
end
bitsRec=bitsRec';
Xhat=reshape(bitsRec,1,length(y)*2);
end

