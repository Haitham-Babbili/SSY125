function [code, message] = Viterbi_soft(y,encode_mod)

switch encode_mod
    case 1
        K = 1;
        N = 2;
        numStates = 4;
        nextStates = [0,2;0,2;1,3;1,3];
        outputs = [0,3;3,0;1,2;2,1];
    case 2
        K = 1;
        N = 2;
        numStates = 16;
        nextStates = [0,8;0,8; 1,9;1,9; 2,10;2,10;3,11;3,11;4,12;4,12; 5,13;5,13; 6,14;6,14;7,15;7,15];
        outputs = [0,3;2,1;3,0;1,2;3,0;1,2;0,3;2,1;0,3;2,1;3,0;1,2;3,0;1,2;0,3;2,1];
    case 3
        K = 1;
        N = 2;
        numStates = 16;
        nextStates = [0,8;0,8;1,9;1,9;2,10;2,10;3,11;3,11;4,12;4,12;5,13;5,13;6,14;6,14;7,15;7,15];
        outputs = [0,3;3,0;3,0;0,3;0,3;3,0;3,0;0,3;1,2;2,1;2,1;1,2;1,2;2,1;2,1;1,2];
end

%---------------State 1----------------------
L = length(y)/2+1;
lamda = zeros(numStates,numStates,L)+inf;
gamma_2 = zeros(numStates,numStates,L)+inf;
gamma_2_final = zeros(numStates,numStates,L)+inf;
gamma = zeros(numStates,L);
gamma(0 + 1, 1) = 0;
gamma(2:end, 1) = inf;
% gamma(2 + 1, 1) = inf;
% gamma(3 + 1, 1) = inf;
survivor = zeros(numStates,numStates,L);
%---------------State 2 to L----------------------
for i = 2:L
    switch encode_mod
        case 1
            if i==2
                states = [1];
            elseif i == 3
                states = [1,3];
            else
                states = [1,2,3,4];
            end
        case 2
            if i==2
                states = [1];
            elseif i == 3
                states = [1,9];
            elseif i == 4
                states = [1,5,9,13];
            elseif i == 5
                states = [1,3,5,7,9,11,13,15];
            else
                states = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
            end
        case 3
            if i==2
                states = [1];
            elseif i == 3
                states = [1,9];
            elseif i == 4
                states = [1,5,9,13];
            elseif i == 5
                states = [1,3,5,7,9,11,13,15];
            else
                states = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
            end
    end

    m_temp = y(2*(i-1)-1:2*(i-1));
    for state = states
        next_state = nextStates(state,:)+1;
        outputs_bi = fliplr(de2bi(outputs',length(m_temp)));
        output_bi = outputs_bi(state*2-1:state*2,:);
        output_bi(output_bi == 0) = -1;
%         output = outputs(state,:);
%         output_bi_0 = fliplr(de2bi(output,length(m_temp)));
        for s = 1:length(next_state)
%             op = de2bi(output(s),length(m_temp));
%             op = fliplr(op);
            err0 = sum(abs(m_temp-output_bi(s,:)));
%             hamming_input = [m_temp;output_bi(s,:)];
%             err1 = pdist(hamming_input);
%             err1 = pdist2(m_temp,output_bi(s,:),'hamming') * 2;
%             err2 = sum(bitxor(m_temp,output_bi(s,:))~=0);
            lamda(state, next_state(s), i-1) = err0;
            gamma_2(state, next_state(s), i) = gamma(state,i-1) + lamda(state, next_state(s), i-1);
            
        end
    end
    gamma(:,i) = min(gamma_2(:,:,i))';
    [p,q] = min(gamma_2(:,:,i));
    for i0=1:numStates
        gamma_2_final(q(i0),i0,i) = p(i0);
    end
end
%----------------find survivor path
gamma_2_final(:,:,1:end)=gamma_2_final(:,:,end:-1:1);
path = zeros(2,length(survivor)-1);
for i = 1:length(gamma_2_final(1,1,:))
   if i == 1
       [value1,positionx] = min(gamma_2_final(:,:,i));
       [value2,positiony] = min(value1);
       path(1,i) = positionx(positiony);
       path(2,i) = positiony;
   else
       path(1,i) = path(2,i-1);
       [value,postion] = min(gamma_2_final(:,path(1,i),i));
       path(2,i) = postion;     
   end
end
path(1:end,1:end) = path(end:-1:1,end:-1:1);
path = path(:,2:end);
y_dec = zeros(1,length(path));
message = zeros(1,length(path));
for i = 1:length(path)-1
   state = path(1,i);
   nstate = path(1,i+1);
   position = find(nextStates(state,:) == (nstate-1));
   if isempty(position)
       position = 1;
   end
   y_dec(i) = outputs(state,position);
   message(i) = position-1;   
end

y_dec_bi = fliplr(de2bi(y_dec,N));
[m,n] = size(y_dec_bi);
code = reshape(y_dec_bi',1,m*n);

end