%% Validity Check Plot

clear all; close all; clc;

load('Motor_Model.mat')

num=MoterModeling.Numerator{1, 1};
den=MoterModeling.Denominator{1, 1};
Gm=tf(num,den)

starttime = 0
finaltime = 10
Fs = 200
Ts = 1/Fs 
Fc = 15;

N =20;
Wc = Fc*2*pi;    
Ws = Fs*2*pi;
oder = 2;

datacount = 2000;

sigR = zeros(datacount,1);
sigW = zeros(datacount,1);
dataR = zeros(datacount*N,1);
dataW = zeros(datacount*N,1);

y = zeros(datacount*N-2,1);
H = zeros(datacount*N-2,3);


time = starttime: Ts : finaltime-Ts
[NZ, DZ] = butter(oder, Wc/(Ws/2), 'low') 
LPF = tf(NZ, DZ,Ts);

for i = 1:N    %888 데이터파일 갯수만큼 돌리기
     
    f=0.1+0.1*(i-1);
    s1 = 'Gyroout';
    s2 = sprintf("%d", i);
    s3 = '.txt';
    
    str = strcat(s1, s2, s3);
    
    data = load(str);
    datain=lsim(LPF,data(1:2000,1),time)
    
    
    figure(),lsim(LPF,data(1:2000,1),time)
    hold on,
    lsim(LPF,data(1:2000,2),time)
    lsim(Gm, datain ,time)
    legend('Vcmd','MotorOutput','ModelingOutput')
    
end

%% 

Gm_cl=feedback(Gm,1);

close all; clc

figure, step (Gm)

figure, pzmap(Gm)

figure, nyquist(Gm_cl)

%%

close all;

Wm=sqrt(3855)
BW=Wm/2/pi

zetam=250.8/Wm/2
km=5.342e05/Wm^2
