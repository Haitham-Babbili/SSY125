%NO_PFILE
function [funs, student_id] = student_sols()
%STUDENT_SOLS Contains all student solutions to problems.

% ----------------------------------------
%               STEP 1
% ----------------------------------------
% Set to your birthdate / the birthdate of one member in the group.
% Should a numeric value of format YYYYMMDD, e.g.
% student_id = 19900101;
% This value must be correct in order to generate a valid secret key.
student_id = 19930331;


% ----------------------------------------
%               STEP 2
% ----------------------------------------
% Your task is to implement the following skeleton functions.
% You are free to use any of the utility functions located in the same
% directory as this file.

if ~ exist(fullfile(pwd,'images'),'dir'), mkdir images; end

pos = load('hip2.mat');

dt = 1;         % s
f_s   = 1/dt;   % Hz

fcut  = 0.01;%0.05;   % Hz
fstop = 0.02;%0.1;    % Hz
N = 300;

H_f = [0, fcut, fstop, f_s/2] /(f_s/2);         % *pi [rad/sample]
H_a = [0,    1,     0,     0] .*H_f*pi *f_s;    % filter amplitude
h_diff = firpm(N,H_f,H_a,'differentiator');

figure('Color','white','Position',[381.0000e+000   455.4000e+000   664.0000e+000   212.8000e+000])
stem(0:N,h_diff)
xlabel 'Samples',  ylabel 'Amplitude', grid on
xlim([0 N])
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','h_imp_resp'),'epsc')

[H,w] = freqz(h_diff,1,512);
figure('Color','white','Position',[381.0000e+000   455.4000e+000   664.0000e+000   212.8000e+000])
plot(H_f,H_a, w/pi,abs(H),'LineWidth',1.5);
legend('Ideal','firpm Design')
xlabel 'Normalized Frequency (\times\pi [rad/sample])', ylabel 'Magnitude', grid on
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','H_abs'),'epsc')

% Plot using FFT instead of freqz
% N_fft = 2e3;    %Zero-pad FFT for increased frequency resolution
% f_fft = (0:N_fft-1)/N_fft*f_s;
% H = fft(h_diff,N_fft); 
% figure('Color','white');
% subplot(2,1,1)
% plot(f_fft , abs(H), '--'); grid on; hold on;
% plot(H_f*(f_s/2), abs(H_a))
% title('Filter magnitude response');
% xlabel('f [Hz]');
% ylabel('|H|');
% subplot(2,1,2)
% plot(f_fft ,unwrap(angle(H))); grid on;
% title('Filter phase response');
% xlabel('f [Hz]');
% ylabel('arg(H)');



Nsamples = length(pos.observation);

h_euler = [1/dt , -1/dt];
vel.observation = conv(pos.observation, h_euler) *3600;
vel.observation = vel.observation(1:Nsamples) ;
vel.signal = conv(pos.signal, h_euler) *3600;
vel.signal = vel.signal(1:Nsamples);
t_euler = (0:Nsamples-1)/dt;

vel.fir_obs = conv(pos.observation, h_diff) *3600;
vel.fir_sig = conv(pos.signal, h_diff) *3600;
t_filtered   = (0:length(vel.fir_obs)-1)/dt;

lc = lines(6);

figure('Color','white','Position',[464.2000e+000   373.8000e+000   404.0000e+000   290.4000e+000]);
xlabel 'time [s]', ylabel 'velocity [km/h]', hold on, grid on
axis([0 600 0 220])
plot(t_euler,vel.signal,'-','Color',lc(1,:),'LineWidth',2);
plot(t_filtered,vel.fir_obs,'-','Color',lc(2,:),'LineWidth',2);
plot(t_filtered,vel.fir_sig,'--','Color','k','LineWidth',2);
legend({'Euler - true', 'FIR - measured','FIR - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-delayed'),'epsc')

figure('Color','white','Position',[464.2000e+000   373.8000e+000   404.0000e+000   290.4000e+000]);
xlabel 'time [s]', ylabel 'velocity [km/h]', hold on, grid on
axis([0 600 0 220])
plot(t_euler,vel.signal,'-','Color',lc(1,:),'LineWidth',2);
plot(t_filtered(N/2:end)-N/2,vel.fir_obs(N/2:end),'-','Color',lc(2,:),'LineWidth',2);
plot(t_filtered(N/2:end)-N/2,vel.fir_sig(N/2:end),'--','Color','k','LineWidth',2);
legend({'Euler - true', 'FIR - measured','FIR - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-delay-corr'),'epsc')

figure('Color','white','Position',[464.2000e+000   373.8000e+000   404.0000e+000   290.4000e+000]);
xlabel 'time [s]', ylabel 'velocity [km/h]', hold on, grid on
% axis([0 600 0 220])
plot(t_euler,vel.observation,'--','Color',lc(2,:),'LineWidth',1);
plot(t_euler,vel.signal,'Color',lc(1,:),'LineWidth',2);
legend({'Euler - measured','Euler - true'});
set(gca,'LooseInset',get(gca,'TightInset'))
saveas(gcf, fullfile(pwd,'images/','vel-noise'),'epsc')

% figure
% plot(pos.observation)

funs.gen_filter = @() h_diff;

%      function h = gen_filter()
%         h = 0;
%     end
% 
% funs.gen_filter = @gen_filter;



% This file will return a structure with handles to the functions you have
% implemented. You can call them if you wish, for example:
% funs = student_sols();
% some_output = funs.some_function(some_input);

end