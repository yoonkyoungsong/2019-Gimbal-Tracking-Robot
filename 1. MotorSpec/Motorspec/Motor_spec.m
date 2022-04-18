%%



clear all; close all; clc;


Minput=zeros(10000,1);
Gyro=zeros(10000,1);

N=980;

for i=1:5
    
        s1 = 'Gyroout';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);
        
        

            Minput=Minput+data(:,1);
            Gyro=Gyro+data(:,2);

            plot(data(1:N,1),data(1:N,2))
            hold on
            %tilte(''), xlabel(''), ylabel('')

end

Minput_mean=Minput/5;
Gyro_mean=Gyro/5;

MinP=Minput_mean(1:N);
GyroP=Gyro_mean(1:N);

figure, plot(Minput_mean(1:N),Gyro_mean(1:N)),grid on


%%

data=load('Gyroout6.txt');
t=0:0.005:10-0.005;
data1=data(1:2000,1);
data2=data(1:2000,2);


plot(t,120*data1)
hold on
plot(t,data2)
