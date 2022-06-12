% Decoding receiving message using viterbi algorithem
function [ bits_decoded ] = viterbi_softDecoding( symbols_encoded, s )
N = length(symbols_encoded);
bits_decoded = zeros(2,N); % store decoded bits 
survivor = zeros(8,N); % path survivored
cumulation = zeros(8,N+1); % initialize cumulative metrics
branch = zeros(8,N); % initialize branch metrics between two states
cumulation(1,1) = 0; cumulation(2:8,1) = inf; % the trellis is initialized to the all-zero state

for i = 1:N
    symbols = symbols_encoded(i);
    for j=1:8
        branch(j,i) = norm(s(j) - symbols);
    end
    % compute the cumulative metrics for the paths extending from one state
    % to another, and choose the minimum ones as the survivors
    [cumulation(1,i+1),I] = min([cumulation(1,i)+branch(1,i) cumulation(3,i)+branch(3,i) cumulation(5,i)+branch(2,i) cumulation(7,i)+branch(4,i)]); % minimum distance to reach state 000 at time i
    survivor(1,i) = I;
    [cumulation(2,i+1),I] = min([cumulation(1,i)+branch(3,i) cumulation(3,i)+branch(1,i) cumulation(5,i)+branch(4,i) cumulation(7,i)+branch(2,i)]); % 001
    survivor(2,i) = I;
    [cumulation(3,i+1),I] = min([cumulation(1,i)+branch(2,i) cumulation(3,i)+branch(4,i) cumulation(5,i)+branch(1,i) cumulation(7,i)+branch(3,i)]);
    survivor(3,i) = I;
    [cumulation(4,i+1),I] = min([cumulation(1,i)+branch(4,i) cumulation(3,i)+branch(2,i) cumulation(5,i)+branch(3,i) cumulation(7,i)+branch(1,i)]);
    survivor(4,i) = I;
    [cumulation(5,i+1),I] = min([cumulation(2,i)+branch(5,i) cumulation(4,i)+branch(7,i) cumulation(6,i)+branch(6,i) cumulation(8,i)+branch(8,i)]);
    survivor(5,i) = I;
    [cumulation(6,i+1),I] = min([cumulation(2,i)+branch(7,i) cumulation(4,i)+branch(5,i) cumulation(6,i)+branch(8,i) cumulation(8,i)+branch(6,i)]);
    survivor(6,i) = I;
    [cumulation(7,i+1),I] = min([cumulation(2,i)+branch(6,i) cumulation(4,i)+branch(8,i) cumulation(6,i)+branch(5,i) cumulation(8,i)+branch(7,i)]);
    survivor(7,i) = I;
    [cumulation(8,i+1),I] = min([cumulation(2,i)+branch(8,i) cumulation(4,i)+branch(6,i) cumulation(6,i)+branch(7,i) cumulation(8,i)+branch(5,i)]);
    survivor(8,i) = I;
end
[~,state] = min(cumulation(:,N+1)); % find the last stage with minimum weight
%state = 1; % with zero termination, the final stage is always 00
% trace back the previous state and decode the corresponding bit
for j = N:-1:1
    [state, bits_decoded(:,j)] = prev_stage_soft(state, survivor(:,j));
end
end


