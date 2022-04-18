%% Step Data Plot 

clear all; close all; clc;

data=load('data4.txt');

starttime = 0;
finaltime = 5;

N=953;
Fs = 200;
Ts = 1/Fs ;
Fc = 15;

Wc = Fc*2*pi;    
Ws = Fs*2*pi;
oder = 2;

t = starttime: Ts : finaltime-Ts

time=data(1:N,1);
step=data(1:N,2);
GyroW=data(1:N,3);


[NZ, DZ] = butter(oder, Wc/(Ws/2), 'high') ;
LPF = tf(NZ, DZ,Ts);

%sigW = lsim(LPF, GyroW, t);
plot(time(1:953),step(1:953)*10),
hold on,
plot(time(1:953),GyroW(1:953))



%% Step Simulation

clear all; close all; clc;

load('Stabilizationloop.mat');


num=Gcl.Numerator{1, 1} ;
den=Gcl.Denominator{1, 1} ;

Gst=tf(num*10,den)

%data=sim('Traking_step.slx');

Gtcl=feedback(Gst,1)

step(Gtcl)
RT=[0.0 0.9];
stepinfo(Gtcl,'RiseTimeLimits',RT)

figure, nyquist(Gst)
axis([-1 1 -1 1])









