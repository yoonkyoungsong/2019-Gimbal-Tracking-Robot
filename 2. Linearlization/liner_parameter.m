%% CCW

clear all ; close all; clc;

%data=load('Gyroout2.txt');
data2=load('liner.csv');
data3=load('motor.mat');

Vcmd=-2.5:0.005:5-0.005;

A1=(299.9439-3.2756)/(2.24-1.74);
B1=-A1*2.24;
C1=300/(2.5-0.05);
D1=-C1*(-0.05);

a1=C1/A1
b1=(D1-B1)/A1


A2=(302.889+2.5159)/(3.405-2.745);
B2=-A2*2.745;
C2=300/(2.5-0.05);
D2=-C2*(0.05);

a2=C2/A2
b2=(D2-B2)/A2

Vss=zeros(1500,1);

for i=1:length(Vcmd)
    if (Vcmd(i) < -2.5) 
        Vss(i) = 1.785;

    elseif (Vcmd(i) < -0.05) 
        Vss(i) = a2 .* Vcmd(i) + b1+0.261;

    elseif (Vcmd(i) >= -0.05 && Vcmd(i) < 0.05) 
        Vss(i) = 2.5;

    elseif (Vcmd(i) >= 0.05 ) 
        Vss(i) = a2 .* Vcmd(i)+ b2-0.245;

    elseif ( Vcmd(i) >= 2.5) 
        Vss(i) = 3.385;


    end
end
 
%subplot(2,1,1)
plot(Vcmd,Vss)
xlabel('Vcmd[V]'),ylabel('Vss[V]')
legend('linerization')
title('linerization')
xlim([-2.5 2.5])


% subplot(2,1,2)
% plot(data2(:,1),data2(:,2)/200*300)
% xlabel('Vcmd[V]'),ylabel('Gyro[W]')
% legend('Gyro')
% title('linerization')
% xlim([-2.5 2.5])

% figure(),
% plot(data(:,1),data(:,2))
% xlabel('Vcmd[V]'),ylabel('Gyro[W]')
% legend('Gyro')
% title('linerization')
% xlim([-2.5 2.5])


%%

clear all ; close all; clc;
t = -3.0 : 0.001: 5.0
N = length(t);
out = zores(N,1);

    if t <= -2.5
        out(c) =   1.7;  

    elseif t>-2.5  && t <= -2.45
      
        out(c) = (299.4703-0.37877)/(3.385-2.785)*(t-2.5) +1.7;

    elseif(t>-2.45 && t<=2.55)
         out(c) = 2.5;
 
    elseif(t >2.55 && t<=3.3 )
         out(c) = (299.4703-0.37877)/(3.385-2.785)
         
    elseif(t >3.3)
        out(c) = 3.3;
end
        
A=(299.4703-0.37877)/(3.385-2.785);
B=-A*2.785;
C=300/(2.5-0.05);
D=-C*(0.05);

a=C/A
b=(D-B)/A

