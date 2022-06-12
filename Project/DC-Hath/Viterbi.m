function [ u_hat ] = Viterbi( data )
%Predefining vectors
t_max = length(data)/2;
data = reshape(data,2,[])';
u_hat = -1*zeros(1,t_max);

D = [0 ;inf ;inf ;inf];
D_mat = [0 inf; inf inf;0 inf;inf inf];
I = zeros(4,t_max)+inf;

c1c2 = [0 0;1 1;0 1;1 0;1 1;0 0;1 0;0 1]; 
for t=1:t_max
    lamda = sum(bitxor(repmat(data(t,:),8,1),c1c2),2);  %sums the data between our output bits with our databits to check
    lamda_mat = reshape(lamda,2,[])'; %rearrange into a 2x4 matrix
    D_mat = D_mat+lamda_mat; %sum up the current "disntance" our fault
    [D,I(:,t)] = min(D_mat,[],2);  %find the minimum of two paths that go to the same temp and pick the smallest one, save index in I and value in D
    D_mat = reshape([D' D'],2,[])';
end

state = 1; % Setting starting point since... it is known
for t = t_max:-1:1

temp = I(state,t); % fetch node index from I

    if state == 1
        if temp == 1
            u_hat(t) = 0;
            state_next = 1;
        else
            u_hat(t) = 0;
            state_next = 2;
        end
    elseif state == 2
        if temp == 1
            u_hat(t) = 0;
            state_next = 3;
        else
            u_hat(t) = 0;
            state_next = 4;
        end
    elseif state == 3
        if temp == 1
            u_hat(t) = 1;
            state_next = 1;
        else
            u_hat(t) = 1;
            state_next = 2;
        end
    elseif state == 4
        if temp == 1
            u_hat(t) = 1;
            state_next = 3;
        else
            u_hat(t) = 1;
            state_next = 4;
        end
    end
    state=state_next;

end

