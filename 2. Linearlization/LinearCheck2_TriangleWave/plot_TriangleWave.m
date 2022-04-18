
clear all; close all; clc;



Minput=zeros(10000,1);
Gyro=zeros(10000,1);

t=0:0.005:5-0.005;
t=t';

for i=1:20
    
    s1 = 'Gyroout';
    s2=sprintf('%d',i);
    s3='.txt';
    s = strcat(s1,s2,s3);
    data= load(s);
        
 
    Minput=Minput+data(:,1);
    Gyro=Gyro+data(:,2);
    
    figure(),
    plot(t,data(1:1000,1)*120,t,data(1:1000,2))
    hold on
         
end
