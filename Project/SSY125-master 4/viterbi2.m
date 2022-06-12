function y = viterbi2(yhat)%,states)

aggrHamw = 1000*ones(length(yhat)/2+1,4);
inputBit = -1*ones(length(yhat)/2+1,4);
path = -1*ones(length(yhat)/2+1,4);

aggrHamw(1,1) = 0;
inputBit(1,1) = 0;
path(1,1) = 0;
posState = [[0 0 0],[0 0 1],[0 1 0],[0 1 1], [1 0 0], [1 0 1], [1 1 0], [1 1 1]];

constellation = [-1-1j -3+3*1j 1+3*1j -3-1j 3-3*1j -1+1j 3+1j -1-3*1j]; % QPSK

g = [];
%states = [0,0,0];
for i = 1:length(yhat)/3
    for j =  1:8
        if path(i,j) >= 0
            g = posState(3*j-2:3*j);
            c01 = mod(0 + 0*g(1) + 1*g(2),2); % output of conv (c1) when input = 0
            c02 = mod(0 + 1*g(1) + 1*g(2),2); % output of conv (c2) when input = 0
            c03 = 
            newState1 = [0 g(1) g(3)];
            tempWeight1 = aggrHamw(i,j)+(c01~=yhat(2*i -1)) + (c02~=yhat(2*i)); % hamming dist from this transition

            if tempWeight1 < aggrHamw(i+1,bi2de(newState1,'left-msb')+1)
                aggrHamw(i+1,bi2de(newState1,'left-msb')+1) = tempWeight1;
                inputBit(i+1,bi2de(newState1,'left-msb')+1) = 0;
                path(i+1,bi2de(newState1,'left-msb')+1) = j;
            end
            
            c11 = mod(1 + 0*g(1) + 1*g(2),2); % output of conv (c1) when input = 1
            c12 = mod(1 + 1*g(1) + 1*g(2),2);% output of conv (c2) when input = 1
            newState2 = [1 g(1)] ;
            tempWeight2 = aggrHamw(i,j)+(c11~=yhat(2*i -1)) + (c12~=yhat(2*i)); 
            
            if tempWeight2 < aggrHamw(i+1,bi2de(newState2,'left-msb')+1)
                aggrHamw(i+1,bi2de(newState2,'left-msb')+1) = tempWeight2;
                inputBit(i+1,bi2de(newState2,'left-msb')+1) = 1;
                path(i+1,bi2de(newState2,'left-msb')+1) = j;
            end
        end
    end
end

[val, ind] = min(aggrHamw(end,:));
prev = ind;
y = nan((length(path)-1),1);

l = length(y);

for k = 1:l
    y(l-k+1) = inputBit(l-k+2,prev);
    prev = path(l-k+2,prev);
end
end