
function [trellis] = P2T(memory,G,n_in,n_out)

%ex :G=[0,1;1 1 ] 
numStates = 2^memory;

mem = zeros(1,size(G,2));
next_state = zeros(numStates,2);
outputs = zeros(numStates,2);

for i = 1:numStates
    %----------------------------------------
    %       Initialize Shift Register 
    %----------------------------------------
    state_dec = i-1; %decimal
   
    mem = de2bi(state_dec,memory,'left-msb'); %binary

    %----------------------------------------
    %       Determine Next States
    %----------------------------------------
   
    next_state_in0_bin = [0 mem(1:end-1)];
    next_state_in0_dec = bi2de(next_state_in0_bin,'left-msb');
    
 
    next_state_in1_bin = [1 mem(1:end-1)];
    next_state_in1_dec = bi2de(next_state_in1_bin,'left-msb');
    
    
    next_state(i,:) = [next_state_in0_dec next_state_in1_dec];

%----------------------------------------
    %       Determine Outputs
    %----------------------------------------
    A=repmat(mem,n_out,1);
    Res=and(G,A);
    
    
    output_in0_bin =mod(sum(Res,2)',2);
    output_in0_dec = bi2de(output_in0_bin,'left-msb');
    
    output_in1_bin =mod((sum(Res,2)+1)',2);
    output_in1_dec = bi2de(output_in1_bin,'left-msb');
    outputs(i,:) = [output_in0_dec output_in1_dec];
    
    
trellis = struct('numInputSymbols',2^(n_in),'numOutputSymbols',2^(n_out),...
    'numStates',numStates,'nextStates',next_state,...
     'outputs',outputs);

end
end


