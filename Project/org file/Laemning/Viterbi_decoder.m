function [ u_code ] = Viterbi_decoder(rx_QPSK_bits)
% Decoding receiving message using viterbi algorithem
Itr = length(rx_QPSK_bits)/2;
rx_QPSK_bits = reshape(rx_QPSK_bits,2,[])';
u_code = -1*zeros(1,Itr);

X = [0 ;inf ;inf ;inf];
D_hat = [0 inf; inf inf;0 inf;inf inf];
ind = zeros(4,Itr)+inf;

R = [0 0;1 1;0 1;1 0;1 1;0 0;1 0;0 1];
for t=1:Itr
    Branch_Met = sum(bitxor(repmat(rx_QPSK_bits(t,:),8,1),R),2); % calculating hamming distances
    Branch_mod = reshape(Branch_Met,2,[])'; % converting into matrix
    D_hat = D_hat+Branch_mod;               % Accumulating hMMING DISTANCES
    [X,ind(:,t)] = min(D_hat,[],2);         % Finding minimum per iteration
    D_hat = reshape([X' X'],2,[])';
end

state = 1; 
for t = Itr:-1:1

temp = ind(state,t); 

    if state == 1
        if temp == 1
            u_code(t) = 0;
            state_next = 1;
        else
            u_code(t) = 0;
            state_next = 2;
        end
    elseif state == 2
        if temp == 1
            u_code(t) = 0;
            state_next = 3;
        else
            u_code(t) = 0;
            state_next = 4;
        end
    elseif state == 3
        if temp == 1
            u_code(t) = 1;
            state_next = 1;
        else
            u_code(t) = 1;
            state_next = 2;
        end
    elseif state == 4
        if temp == 1
            u_code(t) = 1;
            state_next = 3;
        else
            u_code(t) = 1;
            state_next = 4;
        end
    end
    state=state_next;

end

