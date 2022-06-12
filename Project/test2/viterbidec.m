% Decoding receiving message using viterbi algorithem
 bits=[0 0 0 1 0 0 0 1 0 0];
    N=length(bits)/2;
    survivor = zeros(4,N); % path survivored
    cumulation = zeros(4,N+1); % initialize cumulative metrics
    branch = zeros(4,N); % initialize branch metrics between two states
    cumulation(1,1) = 0; cumulation(2:4,1) = Inf; % the trellis is initialized to the all-zero state
    symb=zeros(4,N);
    input=zeros(4,N);
    
   
    
    for i=1:N
        branch(1,i) = sum(xor([0 0] ,[bits(2*i-1) bits(2*i)]));
        branch(2,i) = sum(xor([1 1] ,[bits(2*i-1) bits(2*i)])); % 00 to 10 and 01 to 00
        branch(3,i) = sum(xor([0 1] ,[bits(2*i-1) bits(2*i)])); % 10 to 01 and 11 to 11
        branch(4,i) = sum(xor([1 0] ,[bits(2*i-1) bits(2*i)])); % 10 to 11 and 11 to 01
    end
    
    for i = 1:N
        % mertic for transition from state 00 to 00 and 01 to 10
        % compute the cumulative metrics for the paths extending from one state
        % to another, and choose the minimum ones as the survivors
        if (cumulation(1,i)+branch(1,i) <= cumulation(2,i)+branch(2,i)) % minimum distance to reach state 00 at time i
            cumulation(1,i+1) = cumulation(1,i)+branch(1,i);
            survivor(1,i) = 1;
            symb(1,i)=0;
            input(1,i)=0;
        else
            cumulation(1,i+1) = cumulation(2,i)+branch(2,i);
            survivor(1,i) = 2;
            symb(1,i)=3;
            input(1,i)=0;
        end

        if (cumulation(1,i)+branch(2,i) <= cumulation(2,i)+branch(1,i)) % 10
            cumulation(3,i+1) = cumulation(1,i)+branch(2,i);
            survivor(3,i) = 1;
            symb(3,i)=3;
            input(3,i)=1;
        else
            cumulation(3,i+1) = cumulation(2,i)+branch(1,i);
            survivor(3,i) = 2;
            symb(3,i)=0;
            input(3,i)=1;
        end

        if (cumulation(3,i)+branch(3,i) <= cumulation(4,i)+branch(4,i)) % 01
            cumulation(2,i+1) = cumulation(3,i)+branch(3,i);
            survivor(2,i) = 3;
            symb(2,i)=1;
            input(2,i)=0;
        else
            cumulation(2,i+1) = cumulation(4,i)+branch(4,i);
            survivor(2,i) = 4;
            symb(2,i)=2;
            input(2,i)=0;
        end

        if (cumulation(3,i)+branch(4,i) <= cumulation(4,i)+branch(3,i)) % 11
            cumulation(4,i+1) = cumulation(3,i)+branch(4,i);
            survivor(4,i) = 3;
            symb(4,i)=2;
            input(4,i)=1;
        else
            cumulation(4,i+1) = cumulation(4,i)+branch(3,i);
            survivor(4,i) = 4;
            symb(4,i)=1;
            input(4,i)=1;
        end   
    end
    
    indice = N ;
    a=1;
    vit_code=[]
    u=zeros(1,N)
    
    for i=1:N 
        %vit_code = [de2bi(symb(a,indice),2,'left-msb') vit_code];
        u(indice)=input(a,indice);
        a=survivor(a,indice)
        indice=indice-1;
    end