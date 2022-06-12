% Decoding receiving message using viterbi algorithem
function [ bits_decoded ] = viterbi_hardDecoding_v2( bits_encoded, N )

bits_decoded = zeros(1,N); % store decoded bits
survivor = zeros(4,N); % path survivored
cumulation = zeros(4,N+1); % initialize cumulative metrics
branch = zeros(4,N); % initialize branch metrics between two states
cumulation(1,1) = 0; cumulation(2:4,1) = Inf; % the trellis is initialized to the all-zero state

for i=1:N
branch(1,i) = hamm_dist([0 0], [bits_encoded(2*i-1) bits_encoded(2*i)]);
branch(2,i) = hamm_dist([1 1], [bits_encoded(2*i-1) bits_encoded(2*i)]); % 00 to 10 and 01 to 00
branch(3,i) = hamm_dist([0 1], [bits_encoded(2*i-1) bits_encoded(2*i)]); % 10 to 01 and 11 to 11
branch(4,i) = hamm_dist([1 0], [bits_encoded(2*i-1) bits_encoded(2*i)]); % 10 to 11 and 11 to 01
end
for i = 1:N
    % mertic for transition from state 00 to 00 and 01 to 10
    % compute the cumulative metrics for the paths extending from one state
    % to another, and choose the minimum ones as the survivors
    if (cumulation(1,i)+branch(1,i) <= cumulation(3,i)+branch(2,i)) % minimum distance to reach state 00 at time i
        cumulation(1,i+1) = cumulation(1,i)+branch(1,i);
        survivor(1,i) = 0;
    else
        cumulation(1,i+1) = cumulation(3,i)+branch(2,i);
        survivor(1,i) = 3;
    end
    
    if (cumulation(1,i)+branch(2,i) <= cumulation(3,i)+branch(1,i)) % 10
        cumulation(2,i+1) = cumulation(1,i)+branch(2,i);
        survivor(2,i) = 3;
    else
        cumulation(2,i+1) = cumulation(3,i)+branch(1,i);
        survivor(2,i) = 0;
    end
    
    if (cumulation(2,i)+branch(3,i) <= cumulation(4,i)+branch(4,i)) % 01
        cumulation(3,i+1) = cumulation(2,i)+branch(3,i);
        survivor(3,i) = 1;
    else
        cumulation(3,i+1) = cumulation(4,i)+branch(4,i);
        survivor(3,i) = 2;
    end
    
    if (cumulation(2,i)+branch(4,i) <= cumulation(4,i)+branch(3,i)) % 11
        cumulation(4,i+1) = cumulation(2,i)+branch(4,i);
        survivor(4,i) = 2;
    else
        cumulation(4,i+1) = cumulation(4,i)+branch(3,i);
        survivor(4,i) = 1;
    end   
end
%[~,state] = min(cumulation(:,N+1)); % find the last stage with minimum weight
state = 1; % with zero termination, the final stage is always 00
% trace back the previous state and decode the corresponding bit
for j = N:-1:1
    [state, bits_decoded(j)] = prev_stage_old(state, survivor(:,j));
end

end

