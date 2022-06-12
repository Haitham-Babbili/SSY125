function [ bits_encoded ] = gen_4( bits )
L = length(bits);
u1 = zeros(1,L/2);
u2 = zeros(1,L/2); % inputs
c1 = zeros(1,L/2);
c2 = zeros(1,L/2);
c3 = zeros(1,L/2); % outputs
D1 = 0;D2 = 0;D3 = 0; % initial states
for i = 1:L/2
    u1(i) = bits(2*i-1);u2(i) = bits(2*i);
    c1(i) = D3;c2(i) = u1(i);c3(i) = u2(i);
    D1_new = D3;
    D3_new = bitxor(D2,u1(i));
    D2_new = bitxor(D1,u2(i));
    D1 = D1_new;
    D2 = D2_new;
    D3 = D3_new;
end
%c1 = bitxor(c1,ones(1,N/2));
c = [c1;c2;c3];
bits_encoded=reshape(c,1,1.5*L);