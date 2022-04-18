%%  

clear all; close all; clc;

load('Stabilizationloop.mat')
data=load('disturbance_step.txt');

num=Gcl.Numerator{1, 1};
den=Gcl.Denominator{1, 1};
Gm=tf(num,den);

starttime = 0;
finaltime = 3;
Fs = 200;
Ts = 1/Fs ;
Fc = 15;

Wc = Fc*2*pi;    
Ws = Fs*2*pi;
oder = 2;
time = starttime: Ts : finaltime-Ts;
time=time';


[NZ, DZ] = butter(oder, Wc/(Ws/2), 'low') ;
LPF = tf(NZ, DZ,Ts);
%F =lsim(LPF, data(1:600,3)/150*100, time)

Gm_cl=feedback(Gm,1);
ss=data(401:1000,3)/150*100;

figure,
subplot(2,1,1)
plot(data(401:1000,1)-2,ss,'r')
hold on,step (Gm*100),
legend('simul data','actual data')
%hold on,lsim(LPF, ss, time)
subplot(2,1,2),
plot(data(401:1000,1)-2,ss,'r')
hold on,step (Gm*100),
xlim([0 2])
legend('actual data','simul data')


figure,lsim(LPF, ss, time)
xlim([0 2])

figure,plot(data(401:1000,1)-2,ss,'r')
hold on,step (Gm*100),
xlim([0 2])
legend('actual data','simul data')


%figure, step (Gm_cl)
%figure, pzmap(Gm),grid on
% 
% figure, nyquist(Gm)
% 
% RT=[0.0 0.9];
% stepinfo(Gm,'RiseTimeLimits',RT)

%%

close all;

Wm=sqrt(3855)
BW=Wm/2/pi

zetam=250.8/Wm/2
km=5.342e05/Wm^2