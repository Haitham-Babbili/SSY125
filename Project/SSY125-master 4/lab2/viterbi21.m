function y = viterbi21(yhat)%,states)

aggrHamw = inf(length(yhat)+1,4);
inputBit = -1*ones(length(yhat)+1,4);
path = -1*ones(length(yhat)+1,4);

aggrHamw(1,1) = 0;
inputBit(1,1) = 0;
path(1,1) = 0;
posState = [[0 0],[0 1],[1 0],[1 1]];
constellation = [1+1j 1-1j -1+1j -1-1j];
g = [];
%states = [0,0,0];
for i = 1:length(yhat)
    for j =  1:4
        if path(i,j) >= 0
            g = posState(2*j-1:2*j);
            c01 = mod(0 + 0*g(1) + 1*g(2),2); % output of conv (c1) when input = 0
            c02 = mod(0 + 1*g(1) + 1*g(2),2); % output of conv (c2) when input = 0
            newState1 = [0 g(1)];
            c1=[c01,c02];
            cc=b2down(c1);
            d=constellation(cc+1);
            tempWeight1 = aggrHamw(i,j)+((real(yhat(i))-real(d))+(imag(yhat(i))-imag(d)))^2; % EUCLIDEAN DISTANCE  from this transition
            valb2d1 = b2down(newState1);
            if tempWeight1 < aggrHamw(i+1,valb2d1+1)
                aggrHamw(i+1,valb2d1+1) = tempWeight1;
                inputBit(i+1,valb2d1+1) = 0;
                path(i+1,valb2d1+1) = j;
            end
            
            c11 = mod(1 + 0*g(1) + 1*g(2),2); % output of conv (c1) when input = 1
            c12 = mod(1 + 1*g(1) + 1*g(2),2);% output of conv (c2) when input = 1
            newState2 = [1 g(1)] ;
            c2=[c11,c12];
             cc=b2down(c2);
            d=constellation(cc+1);
            tempWeight2 = aggrHamw(i,j)+((real(yhat(i))-real(d))+(imag(yhat(i))-imag(d)))^2;
            valb2d2 = b2down(newState2);
            if tempWeight2 < aggrHamw(i+1,valb2d2+1)
                aggrHamw(i+1,valb2d2+1) = tempWeight2;
                inputBit(i+1,valb2d2+1) = 1;
                path(i+1,valb2d2+1) = j;
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