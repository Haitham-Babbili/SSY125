% Decoding receiving message using viterbi algorithem
function [ bits_decoded ] = viterbi_hardDecoding( bits_encoded, N )
bits_decoded = zeros(1,N); % store decoded bits
survivor = false(4,N); % path survivored
cumulation = zeros(4,N+1); % initialize cumulative metrics
branch = zeros(4,N); % initialize branch metrics between two states
cumulation(1,1) = 0; cumulation(2:4,1) = Inf; % the trellis is initialized to the all-zero state

branch_1 = reshape(bitxor(repmat([0 0],1,N), bits_encoded),2,N)';
branch_2 = reshape(bitxor(repmat([1 1],1,N), bits_encoded),2,N)';
branch_3 = reshape(bitxor(repmat([0 1],1,N), bits_encoded),2,N)';
branch_4 = reshape(bitxor(repmat([1 0],1,N), bits_encoded),2,N)';
branch(1,:) = sum(branch_1~=0,2);
branch(2,:) = sum(branch_2~=0,2);
branch(3,:) = sum(branch_3~=0,2);
branch(4,:) = sum(branch_4~=0,2);

for i = 1:N
%     bits = [bits_encoded(2*i-1) bits_encoded(2*i)];
%     % mertic for transition from state 00 to 00 and 01 to 10
%     branch(1,i) = hamm_dist([0 0], bits);
%     branch(2,i) = hamm_dist([1 1], bits); % 00 to 10 and 01 to 00
%     branch(3,i) = hamm_dist([0 1], bits); % 10 to 01 and 11 to 11
%     branch(4,i) = hamm_dist([1 0], bits); % 10 to 11 and 11 to 01
    % compute the cumulative metrics for the paths extending from one state
    % to another, and choose the minimum ones as the survivors
    if (cumulation(1,i)+branch(1,i) <= cumulation(3,i)+branch(2,i)) % minimum distance to reach state 00 at time i
        cumulation(1,i+1) = cumulation(1,i)+branch(1,i);
        survivor(1,i) = true;
    else
        cumulation(1,i+1) = cumulation(3,i)+branch(2,i);
    end
    
    if (cumulation(1,i)+branch(2,i) <= cumulation(3,i)+branch(1,i)) % 10
        cumulation(2,i+1) = cumulation(1,i)+branch(2,i);
        survivor(2,i) = true;
    else
        cumulation(2,i+1) = cumulation(3,i)+branch(1,i);
    end
    
    if (cumulation(2,i)+branch(3,i) <= cumulation(4,i)+branch(4,i)) % 01
        cumulation(3,i+1) = cumulation(2,i)+branch(3,i);
        survivor(3,i) = true;
    else
        cumulation(3,i+1) = cumulation(4,i)+branch(4,i);
    end
    
    if (cumulation(2,i)+branch(4,i) <= cumulation(4,i)+branch(3,i)) % 11
        cumulation(4,i+1) = cumulation(2,i)+branch(4,i);
        survivor(4,i) = true;
    else
        cumulation(4,i+1) = cumulation(4,i)+branch(3,i);
    end   
end
[~,state] = min(cumulation(:,N+1)); % find the last stage with minimum weight
%state = 1; % with zero termination, the final stage is always 00
% trace back the previous state and decode the corresponding bit
for j = N:-1:1
    [state, bits_decoded(j)] = prev_stage(state, survivor(:,j));
end
end

