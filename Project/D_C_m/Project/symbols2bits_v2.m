function [ Xhat ] = symbols2bits_v2( s,y )
% Transfer the symbols back to data bits
bitsRec=zeros(length(y),3);
bitsmap = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
for i=1:length(y)
    D1 = norm(s(1)-y(i));
    D2 = norm(s(2)-y(i));
    D3 = norm(s(3)-y(i));
    D4 = norm(s(4)-y(i));
    D5 = norm(s(5)-y(i));
    D6 = norm(s(6)-y(i));
    D7 = norm(s(7)-y(i));
    D8 = norm(s(8)-y(i));
    D = [D1 D2 D3 D4 D5 D6 D7 D8];
    [~,I] = min(D);
    bitsRec(i,:) = bitsmap(I,:);

end
bitsRec=bitsRec';
Xhat=reshape(bitsRec,1,length(y)*3);
end



