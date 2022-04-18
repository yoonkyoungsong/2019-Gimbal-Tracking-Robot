clear all; close all; clc;


Vcmd=zeros(10000,1);
Gyro=zeros(10000,1);

for i=9:19
    
        s1 = 'Gyroout';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);
    
        
         Vcmd=Vcmd+data(:,1);
         Gyro=Gyro+data(:,2);
        figure(),
        plot(data(1:1190,1),data(1:1190,2)) 
        hold on
end
 
Vcmd=Vcmd/11;
Gyro=Gyro/11;

figure,plot(Vcmd(1:1190),Gyro(1:1190))


