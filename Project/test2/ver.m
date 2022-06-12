% Decoding receiving message using viterbi algorithem
 rx_QPSK_bits=[0 0 0 1 0 0 0 1 0 0];
    iter=length(rx_QPSK_bits)/2;
    survivor = zeros(4,iter); % path survivored
    accumulate = zeros(4,iter+1); % initialize cumulative metrics
    brach_metric = zeros(4,iter); % initialize brach_metric metrics between two states
    accumulate(1,1) = 0; accumulate(2:4,1) = Inf; % the trellis is initialized to the all-zero state
    symbol=zeros(4,iter);
    input=zeros(4,iter);
    
   R=[0 0; 1 1; 0 1; 1 0];
    
    for i=1:iter
        brach_metric(1,i) = sum(xor(R(1) ,[rx_QPSK_bits(2*i-1) rx_QPSK_bits(2*i)]));
        brach_metric(2,i) = sum(xor(R(2) ,[rx_QPSK_bits(2*i-1) rx_QPSK_bits(2*i)])); % 00 to 10 and 01 to 00
        brach_metric(3,i) = sum(xor(R(3) ,[rx_QPSK_bits(2*i-1) rx_QPSK_bits(2*i)])); % 10 to 01 and 11 to 11
        brach_metric(4,i) = sum(xor(R(4) ,[rx_QPSK_bits(2*i-1) rx_QPSK_bits(2*i)])); % 10 to 11 and 11 to 01
    end
    
    for i = 1:iter
  
        if (accumulate(1,i)+brach_metric(1,i) <= accumulate(2,i)+brach_metric(2,i)) % minimum distance to reach state 00 at time i
            accumulate(1,i+1) = accumulate(1,i)+brach_metric(1,i);
            survivor(1,i) = 1;
            symbol(1,i)=0;
            input(1,i)=0;
        else
            accumulate(1,i+1) = accumulate(2,i)+brach_metric(2,i);
            survivor(1,i) = 2;
            symbol(1,i)=3;
            input(1,i)=0;
        end

        if (accumulate(1,i)+brach_metric(2,i) <= accumulate(2,i)+brach_metric(1,i)) % 10
            accumulate(3,i+1) = accumulate(1,i)+brach_metric(2,i);
            survivor(3,i) = 1;
            symbol(3,i)=3;
            input(3,i)=1;
        else
            accumulate(3,i+1) = accumulate(2,i)+brach_metric(1,i);
            survivor(3,i) = 2;
            symbol(3,i)=0;
            input(3,i)=1;
        end

        if (accumulate(3,i)+brach_metric(3,i) <= accumulate(4,i)+brach_metric(4,i)) % 01
            accumulate(2,i+1) = accumulate(3,i)+brach_metric(3,i);
            survivor(2,i) = 3;
            symbol(2,i)=1;
            input(2,i)=0;
        else
            accumulate(2,i+1) = accumulate(4,i)+brach_metric(4,i);
            survivor(2,i) = 4;
            symbol(2,i)=2;
            input(2,i)=0;
        end

        if (accumulate(3,i)+brach_metric(4,i) <= accumulate(4,i)+brach_metric(3,i)) % 11
            accumulate(4,i+1) = accumulate(3,i)+brach_metric(4,i);
            survivor(4,i) = 3;
            symbol(4,i)=2;
            input(4,i)=1;
        else
            accumulate(4,i+1) = accumulate(4,i)+brach_metric(3,i);
            survivor(4,i) = 4;
            symbol(4,i)=1;
            input(4,i)=1;
        end   
    end
    
    indice = iter ;
    a=1;
    vit_code=[]
    u=zeros(1,iter)
    
    for i=1:iter 
        %vit_code = [de2bi(symbol(a,indice),2,'left-msb') vit_code];
        u(indice)=input(a,indice)
        a=survivor(a,indice);
        indice=indice-1;
    end