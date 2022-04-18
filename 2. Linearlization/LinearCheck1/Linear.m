clear all; close all; clc;


Vcmd=zeros(10000,1);
Gyro=zeros(10000,1);
t=0:0.005:10-0.005;
t=t';

for i=9:19
    
        s1 = 'Gyroout';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);
    
        
         Vcmd=Vcmd+data(:,1);
         Gyro=Gyro+data(:,2);
        figure(),
        plot(t,data(1:2000,1),t,data(1:2000,2)) 
        hold on
end
 
Vcmd=Vcmd/18;
Gyro=Gyro/18;

figure,plot(Vcmd(1:1990),Gyro(1:1990))

liner=zeros(2,2000);
liner(1,:)=Vcmd(1:2000);
liner(2,:)=Gyro(1:2000);
liner=liner';
csvwrite('liner.csv',liner)


