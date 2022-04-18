%%  전달함수 불러오기

clear all; close all; clc;

load('Motor_Model.mat')

num=MoterModeling.Numerator{1, 1};
den=MoterModeling.Denominator{1, 1};
Gm=tf(num,den)

%% model 특성

close all; clc;

Gm_cl=feedback(Gm,1);

figure, step (Gm)

figure, pzmap(Gm),grid on

figure, nyquist(Gm)

RT=[0.0 0.9];
stepinfo(Gm,'RiseTimeLimits',RT)

%% model parameter

close all;

wm=sqrt(1046)
BW=wm/2/pi

zetam=34.53/wm/2
km=1.115e05/wm^2/120


%%  OS와 Tr로 kp,kd,ki 값

clear all; close all; clc;

%motor spec
wm=sqrt(1046)
zetam=34.53/wm/2
km=1.115e05/wm^2/120

%controller specification
OS=20; % %값
Tr=0.3;

%Rc
zetac=sqrt((log(100/OS))^2/(log(100/OS)^2+pi^2))
wc=pi/(Tr*sqrt(1-zetac^2))
Rc=5*zetac*wc


%% wc_bar/disturbance 고려

clear all; close all; clc;

%motor spec
wm=sqrt(1046);
zetam=34.53/wm/2;
km=1.115e05/wm^2/120;

alpha=5;

zetac=0.707;
wc=28.4664;
Rc=alpha.*wc



%% PID


Kp=(wc.^2-wm^2+2.*zetac.*wc.*Rc)/(km.*wm.^2)
Ki=(Rc.*wc.^2)/(km.*wm.^2)
Kd=(2.*zetac.*wc-2.*zetam.*wm+Rc)/(km.*wm.^2)



Gm= tf( km*wm^2 ,[ 1 2*zetam*wm wm^2 ]);
Gc=tf([Kd Kp Ki],[1 0])
%out=sim('simul.slx')


Go=Gc*Gm;

Gcl=feedback(Go,1)


figure, 
subplot(2,1,1)
step(Gcl)
subplot(2,1,2), 
nyquist(Go),
axis([-1 1 -1 1])

RT=[0.0 0.9];
stepinfo(Gcl,'RiseTimeLimits',RT)

figure, pzmap(Gcl)
hold on, pzmap(Gm), grid on




%% Wc_bar plot 해보기 

close all; clear all; clc;

%motor spec
wm=sqrt(1046)
Zm=34.53/wm/2
km=1.115e05/wm^2/120


alpha = 5; % Parameter for pole placement

% Controller Gain when (alpha=3) and Wc_bar is variable
Wc_bar = 0:0.01:1;
Kp_bar = (1+sqrt(2)*alpha)*(Wc_bar.^2)-1;
Ki_bar = alpha*(Wc_bar.^3);
Kd_bar = (sqrt(2)+alpha).*Wc_bar-(2*Zm);

% check the proper Wc_bar when alpha is fixed at 3
figure,
subplot(2,1,1),
plot(Wc_bar,Kp_bar),hold on,plot(Wc_bar,Ki_bar),hold on,plot(Wc_bar,Kd_bar)
hold on,plot(Wc_bar,0*Wc_bar)
xlabel('Wc_b_a_r'),ylabel('Control Gain')
legend('Kp_b_a_r','Ki_b_a_r','Kd_b_a_r')
title('when alpha is fixed at 5')

% Controller Gain when alpha is variable and Wc_bar=0.5
Wc_bar1 = 0.35;
alpha=0:0.01:8;
Kp_bar = (1+sqrt(2).*alpha)*(Wc_bar1^2)-1;
Ki_bar = (Wc_bar1^3).*alpha;
Kd_bar = (sqrt(2)*Wc_bar1+Wc_bar1.*alpha)-(2*Zm);

% check the proper alpha when Wc_bar is fixed at 0.5

subplot(2,1,2),
plot(alpha,Kp_bar),hold on,plot(alpha,Ki_bar),hold on,plot(alpha,Kd_bar)
hold on,plot(alpha,0*alpha)
xlabel('alpha'),ylabel('Control Gain')
legend('Kp_b_a_r','Ki_b_a_r','Kd_b_a_r')
title('when Wc_b_a_r is fixed at 0.35')



%% Disturbance 고려

clear all; close all; clc;

%motor spec
wm=sqrt(1046)
zetam=34.53/wm/2
km=1.115e05/wm^2/120

alpha=4;
zetac=0.707;

wc=0:0.01:wm;
Rc=alpha*wc;
s=j*0.5*2*pi;

d=ones(length(wc))*0.1;

Kp=(wc.^2-wm^2+2*zetac.*wc.*Rc)/(km.*wm^2);
Ki=(Rc.*wc.^2)/(km.*wm^2);
Kd=(2*zetac*wc-2*zetam*wm+Rc)/(km*wm^2);


Wh = s.^3 + 2*zetam*wm.*s.^2 + wm.^2.*s
Wb = km*wm^2*Kd.*s.^2 + km*wm^2*Kp.*s + km*wm.^2.*Ki;

Gd=Wh./Wb;

plot(wc,abs(Gd)),
hold on,
plot(wc,d),
xlabel('Wc'),ylabel('Disturbance Ratio')
legend('Disturbane Rejection')
title('Check Wc about Disturbance')
xlim([0 30])

