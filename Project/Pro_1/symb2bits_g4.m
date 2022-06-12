function [ Xhat ] = symb2bits_g4( const,y )
% Transfer the symbols back to data bits
bits_recevd=zeros(length(y),3);
bits_map = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
for i=1:length(y)
    dis1 = norm(const(1)-y(i));       % calculate distance between constillation and recived symboles  
    dis2 = norm(const(2)-y(i));
    dis3 = norm(const(3)-y(i));
    dis4 = norm(const(4)-y(i));
    dis5 = norm(const(5)-y(i));
    dis6 = norm(const(6)-y(i));
    dis7 = norm(const(7)-y(i));
    dis8 = norm(const(8)-y(i));
    dis = [dis1 dis2 dis3 dis4 dis5 dis6 dis7 dis8];
    [~,I] = min(dis);                   % find the minimum dictance
    bits_recevd(i,:) = bits_map(I,:);      % lookup our bits 

end
bits_recevd=bits_recevd';                     % transposse
Xhat=reshape(bits_recevd,1,length(y)*3);  % reshape recived bit
end



