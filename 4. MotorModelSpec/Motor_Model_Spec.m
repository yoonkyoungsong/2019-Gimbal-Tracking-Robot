%%  

clear all; close all; clc;

load('Motor_Model.mat')

num=MoterModeling.Numerator{1, 1};
den=MoterModeling.Denominator{1, 1};
Gm=tf(num,den)

%%

close all;

Gm_cl=feedback(Gm,1);

figure, step (Gm)

figure, pzmap(Gm_cl),grid on

figure, nyquist(Gm)

RT=[0.0 0.9];
stepinfo(Gm,'RiseTimeLimits',RT)

%%

close all;

Wm=sqrt(1046)
BW=Wm/2/pi

zetam=34.53/Wm/2
km=1.115e05/Wm^2/120

settling=4/(zetam*Wm)
