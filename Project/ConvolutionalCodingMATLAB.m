%How can I Implement a convolution function in MATLAB and perform it on the following signals and %plot the results ?
%Asked by Vaban Dust on 14 Mar 2018
%Latest activity Commented on by Vaban Dust on 16 Mar 2018
%Accepted Answer by Abraham Boayue
%679 views (last 30 days)

%Hi guys,
%I have the following function:
impulse_response = zeros(1, length(input) + length(delta) - 1 );
for t_samp = 1:length(input)
for c_samp = 1:length(delta)
   index = t_samp + c_samp - 1;
value = delta(c_samp) * input(t_samp);
impulse_response(index) = impulse_response(index) + value;
end
end
%I am new to Matlab and I want to understand how to Implement a convolution function in MATLAB and %perform it on the following signals and plot the results ?
%Task (1):
%x[n] = [1,1,1,1] h[m] = [1,0,−1] x[n] = sin(n) h[m] = [−1,−2,8,−2,−1] 20 ≤ n < 20
%Task (2): Given the input signal x[n]=0.3∗sin(n/5)+sin(n/50) : -Create your own delta signal h[m] %that removes the higher frequency sinusoidal component to get yl[n].
%Thanks in advance for your kind explanation.







%Hey Vaban, you already got a code that implements convolution in matlab, all you need to do is to 
%use it to solve your exercises: Alternatively, you could use matlab built in function called 
%conv(), but it seems like your teacher wants you to learn how to code in matlab. Here is how you 
%can use the code you have. Ex. Task 1.

%% This is just a cleaner code, same as the one you posted
clear variables
close all
n = -20:20;
x = sin(n);            
h = [-1,-2,8,-2,-1];  
N = length(x);
M = length(h);
Ny = N + M -1;
y = zeros(1,Ny);
for i = 1:N
      for k = 1:M
       y(i+k-1) = y(i+k-1) + h(k)*x(i);
      end
end
m = 0: Ny-1;
% Make plot
figure
stem(m,y,'linewidth',3,'color','m')
grid;
a = title('Output of an LTI System y(n)');
set(a,'fontsize',14);
a = ylabel('y(n)');
set(a,'Fontsize',14);
a = xlabel('n');
set(a,'Fontsize',14);
% Using matlab built in function (you get the same results)
figure
y2 = conv(x,h);
stem(m,y2,'linewidth',3,'color','r')
grid;
a = title('Output y(n) using conv(x,h)');
set(a,'fontsize',14);
a = ylabel('y(n)');
set(a,'Fontsize',14);
a = xlabel('n ');
set(a,'Fontsize',14);
%% % input = [1 1 1 1]; % input = x (n) = [1 1 1 1]
% % delta = [1 0 -1];  % h(m) = [-1 0 1]
% impulse_response = zeros(1, length(input) + length(delta) - 1 );
% for t_samp = 1:length(input)
% for c_samp = 1:length(delta)
%      index = t_samp + c_samp - 1;
%      value = delta(c_samp) * input(t_samp);
%      impulse_response(index) = impulse_response(index) + value;
% end
% end
% Ny = length(input) + length(delta)-1;
% y =  impulse_response;
% m = 0:Ny-1;
% % plot
% stem(m,y,'linewidth',3,'color','b')
% grid;
% a = title('Output of an LTI System y(n)');
% set(a,'fontsize',14);
% a = ylabel('y(n)');
% set(a,'Fontsize',14);
% a = xlabel('n [1 4]');
% set(a,'Fontsize',14);





%%%another exampel

Try replacing the conv line with this:

N = length(vs);
M = length(h);   
lout=N+M-1;
vc=zeros(1,lout); 
for i = 1:N
    for k = 1:M
      vc(i+k-1) = vc(i+k-1) + h(k)*vs(i);
    end
end




%%
close all
clearvars
%x=input('Enter x:     ')
x=sin(2*pi*0.1.*(1:1:11)); 
%h=input('Enter h:   ')
h=[1 2 3 4 5 3 1 -1];
% convolution
m=length(x);
n=length(h);
X=[x,zeros(1,n)];
H=[h,zeros(1,m)];
for i=1:n+m-1
    Y(i)=0;
    for j=1:m
        if(i-j+1>0)
            Y(i)=Y(i)+X(j)*H(i-j+1);
        else
        end
    end
end
% plot results
figure;
subplot(3,1,1); 
stem(x, '-b^'); 
xlabel('n');
ylabel('x[n]'); 
grid on;
subplot(3,1,2); 
stem(h, '-ms');
xlabel('n'); 
ylabel('h[n]'); 
grid on;
subplot(3,1,3); 
stem(Y, '-ro');
ylabel('Y[n]'); 
xlabel('----->n'); 
grid on;
title('Convolution of Two Signals without conv function');
