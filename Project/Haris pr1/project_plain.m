
%% ======================================================================= %
%  [SSY125 Project] - PART 1
%  [Denis Mahmutovic]
%  [Stefan Markovic]
%  [Muhammad Haris Khan]
%  ======================================================================= %
%% Clean-up functions [Commented out in order to use our auto-run mode]
    %clc
    %clear
    %close all
%% ======================================================================= %
%  [Simulation Options] - Bits per block, Max Errs, Power effcy range. 
%  ======================================================================= %
    N = 100000;             % Simulate N bits each transmission (one block).
    maxNumErrs = 100;       % Get at least 100 bit errors (more is better).
    maxNum = 1e6;           % OR stop if maxNum bits have been simulated.
    EbN0 = -1:1:9;        % Power efficiency range.
%% ======================================================================= %
%  [Other Options] - Variable- and Test Options.
%
%   Set desired flag to true for which mode should be tested.
%  ======================================================================= % 
    AUTO_RUN = 1; % SET TO 1 AND THIS WILL AUTOMATICALLY RUN AND PLOT PART 1.
                  % SET TO 0 IF YOU WANT TO RUN INDIVIDUALLY TESTS.
%  ======================================================================= % 

    Coded_Flag = false;     % (true) for Coded || (false) for Uncoded Simulation

    BPSK = false;           % BSPK Flag
    QPSK = true;            % QPSK Flag
    AMPM = false;           % AMPM Flag
    
    PLOT_FIG = 1;           % Figure Flag
    
switch AUTO_RUN
    case 0
        Q = 1;
    case 1
        Coded_Flag = false;
        PLOT_FIG = 0;
        Q = 2;
end

for j=1:Q
%% ======================================================================= %
%  [Simulation Chain]
%  ======================================================================= %

% Pre-allocate / calculations
    switch Coded_Flag
        case true
            Coded_BER = zeros(1,length(EbN0));      % pre-allocate a vector for BER results
            %Soft_Coded_BER = zeros(1,length(EbN0));
        case false
            Uncoded_BER = zeros(1,length(EbN0));    % pre-allocate a vector for BER results
    end
    Theory_BER = qfunc(sqrt(2*10.^(EbN0/10)));      % pre-allocate a vector for BER results
    
    a = (BPSK | QPSK | AMPM);
    if (a ~= 1)
        disp('Modulation mode is not set!');
        return;
    end
    
    tic
for (i = 1:length(EbN0)) % Parfor ('help parfor') to parallelize  
    totErr = 0;             % Number of errors observed
    num = 0;                % Number of bits processed

    while((totErr < maxNumErrs) && (num < maxNum))
% ===================================================================== %
% Begin processing one block of information
%
% The labeling of the input- and output-signals are set to follow the 
% block diagram (figure 1) in the project description.
% ===================================================================== %

% [SRC] Generate a bitvector with N information bits. 
    u = randsrc(1,N,[0 1]);
   
% [ENC] Convolutional encoder (Epsillon 1)
    switch Coded_Flag
        case true
            rate = 0.5;
            c = c_encoder(1,u);         % Input arguments:
                                        % [Type of Encoder, Bitvector to be encoded]
            trellis = P2T(2,[0 1;1 1],1,2); % Used later for our general Viterbi.                                  
        case false
            rate = 1;
            c = u;
    end

%% [MOD] Symbol Mapper - Mode is based on the flags set in the beginning.
    % BPSK
    if (BPSK == true)
        modulation = 1;
    elseif (QPSK == true)
        modulation = 2;    
    elseif (AMPM == true)
        modulation = 3;
    else
        modulation = 0;
    end
    [x,const] = symbol_mapper(c,modulation);

%% [CHA] Add Gaussian Noise
    linearscale = 10^(EbN0(i)/10)*(rate*modulation);
    sigma = sqrt(1/(2*linearscale));
    noise_real = sigma*randn(1,length(x));
    noise_imag = sigma*1i*randn(1,length(x));
    y = x+noise_real+noise_imag;

%% [HR] Hard Receiver
    switch modulation
        case 1
            metric = abs(repmat(y.',1,2) - repmat(const, length(y), 1)).^2;
            [tmp m_hat] = min(metric, [], 2);
        case 2
            metric = abs(repmat(y.',1,4) - repmat(const, length(y), 1)).^2; 
            [tmp m_hat] = min(metric, [], 2); 
        case 3
            metric = abs(repmat(y.',1,8) - repmat(const, length(y), 1)).^2; 
            [tmp m_hat] = min(metric, [], 2);
    end

    m_hat = m_hat'-1;
    c_hat = m_hat;
    c_hat = de2bi(c_hat,'left-msb');
    indtmp = c_hat';
    c_hat = indtmp(:)';
    
    switch Coded_Flag
        case true
            u_hat = vit(trellis,c_hat,N);
            BitErrs = sum(abs(u_hat-u));
        case false
            BitErrs = sum(abs(c_hat(1:length(u))-u));
    end
    
%% [SR] Soft Receiver
% ...TO DO...

%% ===================================================================== %
%  End processing one block of information
%  ===================================================================== %
%%
    totErr = totErr+BitErrs;
    num = num+N; 

    disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
    num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
    num2str(totErr/num, '%10.1e') '. +++']);
    end 
    switch Coded_Flag
        case true
            Coded_BER(i) = totErr/num; 
        case false
            Uncoded_BER(i) = totErr/num;
    end
end

%% ===================================================================== %
%  Plot Figures Fcn
%  ===================================================================== %
    if (PLOT_FIG == 1)
        figure()
        semilogy(EbN0,Theory_BER,'-*');
        hold on;
        switch Coded_Flag
            case true
                semilogy(EbN0,Coded_BER,'-s');
                legend('Uncoded System (Theory)','Coded System (Hard Receiver)');
            case false
                semilogy(EbN0,Uncoded_BER,'-d');
                legend('Uncoded System (Theory)','Uncoded System (Simulation)');
        end
        xlabel('EbN0');
        ylabel('BER');
        ylim([1e-4 1]);
        grid on;
        toc
    end
    
    Coded_Flag = true;
    if (j == 2)
        figure()
        semilogy(EbN0,Theory_BER,'-*');
        hold on;
        semilogy(EbN0,Coded_BER,'-s');
        hold on;
        semilogy(EbN0,Uncoded_BER,'-d');
        hold on;
        legend('Uncoded System (Theory)','Coded System (Hard Receiver)','Uncoded System (Simulation)');
        xlabel('EbN0');
        ylabel('BER');
        ylim([1e-4 1]); 
        grid on;
    end
end
%%
% ======================================================================= %
% End
% ======================================================================= %