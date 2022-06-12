function [ bits_encoded ] = encoder4( bits )
N = length(bits);
u1 = zeros(1,N/2);u2 = zeros(1,N/2); % inputs
c1 = zeros(1,N/2);c2 = zeros(1,N/2);c3 = zeros(1,N/2); % outputs
r1 = 0;r2 = 0;r3 = 0;
for i = 1:N/2
    u1(i) = bits(2*i-1);u2(i) = bits(2*i);
    c1(i) = r3;c2(i) = u1(i);c3(i) = u2(i);
    r1_new = r3;
    r3_new = bitxor(r2,u1(i));
    r2_new = bitxor(r1,u2(i));
    r1 = r1_new;
    r2 = r2_new;
    r3 = r3_new;
end
%c1 = bitxor(c1,ones(1,N/2));
c = [c1;c2;c3];
bits_encoded=reshape(c,1,1.5*N);

