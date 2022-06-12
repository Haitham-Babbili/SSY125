clc;
clear all;
% Create 1x432 bits-vector
    pack = randi([0 1],1,100000);




%% Transmitter 
   
    n = length(pack);
    
%% Preamble
% 1 = 0 and -1 = 1
tic


    flag = 1; %0 = PN sequence, 1 = Barker, 2 = given sequence
    %SNR = -20;
    switch flag
        case 0        
            preamble = [0 0 0 0 0 0 1 1 0 0 1 1 1 1];   % PN sequence

        case 1
            preamble = [0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 0 1];     % Barker code, https://en.wikipedia.org/wiki/Barker_code

        case 2
            preamble = [0 0 1 1 0 0 1 1 0 0 1 1 0 0];   % given sequence
        case 3
            preamble = [0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 1 1 0 0 1 1 0 0];
        case 4
            preamble = [0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 0]; % Barker code with 1 added + barker code with 0 added
    end
   
    Tp = length(preamble);          % length of preamble
    delay = 20;       % Generate a random delay between 1 and 20
    %rx = awgn([zeros(1, delay) preamble], SNR, 'measured');     % insert the sequence after the delay
    %rx = [zeros(1, delay) preamble];    % insert the sequence after the delay



%% Bits To Message

    b_persymb = 8;                    % Size of message == 8
    msg_Tx = buffer(pack, b_persymb)';   % Group bits into bits per => 54x8
    
%%  Message To Symbols
    %%%%%%%%%%% Change const
    const = [1+(1*j), -1+(1*j),  1-(1*j),-1-(1*j)]/sqrt(2);     % Constellation 1 - QPSK/4-QAM -- Divide by sqrt(2), so E_s = 1
    
    cut_m = buffer(pack,2)';
    cut_m_idx = bi2de(cut_m, 'left-msb') +1;
    symbols_pack = const(cut_m_idx);
    
%% Message To Symbols Preamble
    BPSK = [-1,1];
    
    cut_preamble = buffer(preamble,1)';
    cut_preamble_idx = bi2de(cut_preamble,'left-msb')+1;
    symbols_preamble = BPSK(cut_preamble_idx);
    
%% Message to Symbols

    symbols = [zeros(1,delay),symbols_preamble, symbols_pack];
    
%% Symbols To Signal
    M = length(const);
    bpsymb = log2(M);           % Number of bits per Symbol
    Rb = 500;                   % bit rate [bit/sec] 
    fsymb = Rb / bpsymb;        % Symbol rate [symb/s]
    Tsymb = 1 / fsymb;          % Symbol time
    fs = 50000;                 % sampling Frequency [Hz]       
    fsfd = ceil(fs / fsymb);          % Number of samples per symbol (choose fs such that fsfd is an integer for simplicity) [samples/symb]
    Tsamp = 1/fs;               % Sampling time
    


    symbols_upsample = upsample(symbols, fsfd);     % Space the symbols fsfd apart, to enable pulse shaping using conv.
    % Create Signal
    span = 8;                                       % how many symbol times do we want of pulse (note that RC and RRC is not zero outside of symbol time!)
    [pulse, t] = rtrcpuls(0.4,1/fsymb,fs,span);        
    signal = conv(pulse,symbols_upsample);
%     x = length(symbols);
%     y = length(pulse);
%     m = x+y-1;
%     for i=1:x
%     signal(i)=0;
%     for j=1:x
%         if(i-j+1>0)
%             signal(i)=signal(i)+symbols_upsample(j)*pulse(i-j+1);
%         else
%         end
%     end
% end
    
    %% Plot Signal
    figure; 
    subplot(2,1,1); 
    plot(Tsamp*(0:(length(signal)-1)), real(signal), 'b');
    samples = signal(span*fsfd:fsfd:end-span*fsfd);
    hold on;
    t = span*fsfd:fsfd:(span*fsfd + fsfd*(length(samples)-1));
    stem(t*Tsamp, real(samples),'r')
    title('real')
    xlabel('seconds')
    subplot(2,1,2); 
    plot(Tsamp*(0:(length(signal)-1)), imag(signal), 'b');
    title('imag')
    xlabel('seconds')
    
    
%% Signal on Carrier
    fc = 4000;
   
theta = 0;

tx_signal_real = real(signal) .* cos(2*pi*fc*(0:length(signal)-1)*Tsamp + theta) .* sqrt(2);
tx_signal_imag = imag(signal) .* sin(2*pi*fc*(0:length(signal)-1)*Tsamp + theta) .* sqrt(2);
tx_signal = tx_signal_real + tx_signal_imag;

    figure(); 
    plot(tx_signal);
    title('Tx Signal')

    toc
%% Reciever 


%% Signal to Symbols
% Real Part
% Add AWGN noise to the signal
    SNRdB = 0; %decide noise level
    tx_signal = awgn(tx_signal, SNRdB, 'measured'); % add noise

%%%%%%%%%%%%%%%%% SCALING PARAMETER NEEDED?!?!?!?
    rx_real = tx_signal .* cos(2*pi*fc*(0:length(signal)-1)*Tsamp) .* sqrt(2);
    rx_imag = tx_signal .* (1*j).*sin(2*pi*fc*(0:length(signal)-1)*Tsamp) .* sqrt(2);
    
    rx_signal = rx_real + rx_imag;



%%

MF = fliplr(conj(pulse));        %create matched filter impulse response
MF_output = filter(MF,1,rx_signal);      % run received signal through matched filter
MF_output = MF_output(length(MF):end)/fsfd; %remove transient
%MF_output = conv(pulse, tx_signal)/fsfd;  % Another approach to MF using conv, what's the difference?
%MF_output = MF_output(length(MF):end-length(MF)+1);
rx_vec = MF_output;  %get sample points


%%
% scatterplot(rx_vec); %scatterplot of received symbols
%     title('Scattered Plot Real')
figure
subplot(2,1,1)
plot(real(rx_signal(length(MF):end)));
    title('real')
subplot(2,1,2);
plot(real(MF_output));
hold on; 
stem((1:fsfd:length(MF_output)),real(MF_output(1:fsfd:end))); 
hold off;

figure
subplot(2,1,1)
plot(imag(rx_signal(length(MF):end)));
    title('imag')
subplot(2,1,2);
plot(imag(MF_output));
hold on; 
stem((1:fsfd:length(MF_output)),imag(MF_output(1:fsfd:end))); 
hold off;
%% Frame Synchronization

% change
    [pulse, t] = rtrcpuls(0.4,1/fsymb,fs,span);        

   cut_preamble = buffer(preamble,1)';
    cut_preamble_idx = bi2de(cut_preamble,'left-msb')+1;
    symbols_preamble = BPSK(cut_preamble_idx);
%
    symbols_upsample_pre = upsample(symbols_preamble, fsfd);     % Space the symbols fsfd apart, to enable pulse shaping using conv.
    % Create Signal
    span = 6;                                       % how many symbol times do we want of pulse (note that RC and RRC is not zero outside of symbol time!)
    [pulse, t] = rtrcpuls(0.4,1/fsymb,fs,span);        
    signal_preamble = conv(pulse,symbols_upsample_pre);

    MF = fliplr(conj(pulse));        %create matched filter impulse response
MF_output = filter(MF,1,signal_preamble);      % run received signal through matched filter
MF_output = MF_output(length(MF):end)/fsfd; %remove transient


rx_preamble = MF_output(1:fsfd:end);  %get sample points

% Correlation
corr = conv(real(rx_vec), real(fliplr(rx_preamble)));   % correlate the sequence and received vector
figure; plot(1:length(corr),corr, '.-r')       % plot correlation

[tmp, Tmax] = max(corr);       %find location of max correlation
Tx_hat = Tmax - length(rx_preamble);  %find delay (it will take length(pream
fprintf('delay = %d, estimation = %d\n', delay, Tx_hat)
rx_preamble = rx_vec(Tx_hat+1:Tx_hat+length(preamble));
rx_vec = rx_vec(Tx_hat+length(rx_preamble)+1:end);
    
 
%% Find Phase Shift

rx_vec = rx_vec/max(abs(rx_vec));
rx_preamble = rx_preamble/max(abs(rx_preamble));

        for i = 1:length(rx_preamble)
    phase_shift(i) = atan(imag(rx_preamble(i))/ real(rx_preamble(i)));
        end
        phase_shift = sum(phase_shift) / length(rx_preamble);
    
        
    for i = 1:length(rx_vec)
        rx_vec_sync_angle(i) = atan2(imag(rx_vec(i)) , real(rx_vec(i))) - (phase_shift);
    end
    for i = 1:length(rx_preamble)
        rx_pre_sync_angle(i) = atan2(imag(rx_preamble(i)) , real(rx_preamble(i))) - (phase_shift);
    end
    
    for i = 1:length(rx_vec_sync_angle)
    rx_vec_sync(i) = cos(rx_vec_sync_angle(i)) + j* sin(rx_vec_sync_angle(i));
    end
    for i = 1:length(rx_pre_sync_angle)
    rx_pre_sync(i) = cos(rx_pre_sync_angle(i)) + j* sin(rx_pre_sync_angle(i));
    end
    
    
    
    scatterplot(rx_vec); %scatterplot of received symbols
    title('Scattered Plot Signal')
    scatterplot(rx_preamble); %scatterplot of received symbols
    title('Scattered Plot Preamble')
    scatterplot(rx_vec_sync); %scatterplot of received symbols
    title('Scattered Plot Signal Phase Sync')
    scatterplot(rx_pre_sync); %scatterplot of received symbols
    title('Scattered Plot Preamble Phase Sync')
    



%%
% Minimum Eucledian distance detector
% Relate the detection to Detection region
metric = abs(repmat(rx_vec_sync.',1,4) - repmat(const, length(rx_vec_sync), 1)).^2; % compute the distance to each possible symbol
[tmp m_hat] = min(metric, [], 2); % find the closest for each received symbol
m_hat = m_hat'-1;   % get the index of the symbol in the constellation

symbols = const(m_hat+1);


%%
SER = symerr(cut_m_idx'-1, m_hat); %count symbol errors
b_hat_buffer = de2bi(m_hat, 2, 'left-msb')'; %make symbols into bits
b_hat = b_hat_buffer(:)'; %write as a vector
BER = biterr(pack, b_hat); %count of bit errors
fprintf('SER = %d, BER = %d\n', SER, BER)


