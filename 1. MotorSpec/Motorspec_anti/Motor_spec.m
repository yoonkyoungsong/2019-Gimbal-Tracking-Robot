%%



clear all; close all; clc;


Minput=zeros(10000,1);
Gyro=zeros(10000,1);



for i=1:20
    
        s1 = 'Gyroout';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);
        
        

            Minput=Minput+data(:,1);
            Gyro=Gyro+data(:,2);

            plot(data(1:1400,1),data(1:1400,2))
            hold on
            %tilte(''), xlabel(''), ylabel('')

end

Minput_mean=Minput/20;
Gyro_mean=Gyro/20;

MinP=Minput_mean(1:1500);
GyroP=Gyro_mean(1:1500);

figure, plot(Minput_mean(1:1400),Gyro_mean(21:1420)),grid on

xlim([1.5 3.5]), ylim([-400 400])
title('Motor Characteristic'), xlabel('Vcmd[Voltage]'), ylabel('Gyro[Voltage]')
