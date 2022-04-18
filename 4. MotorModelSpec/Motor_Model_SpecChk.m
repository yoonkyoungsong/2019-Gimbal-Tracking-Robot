%%  

clear all; close all; clc;

load('Motor_Model.mat')

num=MoterModeling.Numerator{1, 1};
den=MoterModeling.Denominator{1, 1};
Gm=tf(num,den)

%%

close all; clc;

Gm_cl=feedback(Gm,1);

figure, step (Gm)

figure, pzmap(Gm),grid on

figure, nyquist(Gm)

bode(Gm)

RT=[0.0 0.9];
stepinfo(Gm,'RiseTimeLimits',RT)

%%

close all;

Wm=sqrt(3855)
BW=Wm/2/pi

zetam=250.8/Wm/2
km=5.342e05/Wm^2
