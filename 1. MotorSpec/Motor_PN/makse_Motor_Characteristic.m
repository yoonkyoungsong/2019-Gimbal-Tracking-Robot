%%  0-2.5V

clear all; close all; clc;


Minput=zeros(10000,1);
Gyro=zeros(10000,1);

for i=1:25
    
        s1 = 'Gyroout_P';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);
        
        
        if s2==int2str(2)
            continue;
        else
            Minput=Minput+data(:,1);
            Gyro=Gyro+data(:,2);

            plot(data(1:200,1),data(1:200,2))
            hold on
        end
end

Minput_mean=Minput/23;
Gyro_mean=Gyro/23;

MinP=Minput_mean(1:200);
GyroP=Gyro_mean(1:200);

figure, plot(Minput_mean(1:200),Gyro_mean(1:200))
xlim([0 4])

%%

 close all; clc;


Minput=zeros(10000,1);
Gyro=zeros(10000,1);

for i=1:25
    
    
        s1 = 'Gyroout_N';
        s2=sprintf('%d',i);
        s3='.txt';
        s = strcat(s1,s2,s3);
        data= load(s);

        Minput=Minput+data(:,1);
        Gyro=Gyro+data(:,2);

       plot(data(1:200,1),data(1:200,2))
        hold on
 
end

Minput_mean=Minput/25;
Gyro_mean=Gyro/25;

MinN1=Minput_mean(1:200);
MinN=zeros(200,1);

GyroN1=Gyro_mean(1:200);
GyroN=zeros(200,1);

for i=0:199 
    GyroN(i+1)=GyroN1(200-i);
    MinN(i+1)=MinN1(200-i);
end
figure,plot(MinN,GyroN(:,1))
xlim([0 4])


%%

Gyro_M=zeros(400,1);
Gyro_M(201:400,1)=GyroP;
Gyro_M(1:200,1)=GyroN;
GyroM=Gyro_M';

Volt1=MinP;
Volt2=MinN;
Volt=zeros(1,400);
Volt(1:200)=Volt2;
Volt(201:400)=Volt1;

plot(Volt,GyroM)
xlim([-2.4 2.4])

csvwrite('GyroMean1.csv',GyroM);
csvwrite('InputVoltage1.csv',Volt);

%%

clear all; close all; clc;

load('Motor_Characteristic.mat');
dc0=zeros(400,1)

plot(Volt,GyroM)
xlim([-2.4 2.4])

csvwrite('GyroMean.csv',GyroM);
csvwrite('InputVoltage.csv',Volt);

%%
clear all; close all; clc;

load('Motor_Characteristic.mat');
%dc0=zeros(1,399);

plot(Vcmd,out)
hold on,
%plot(Vcmd,dc0)
xlim([1.7 3.2])


%%
clear all; close all; clc;

Vcmd=load('InputVoltage.csv');
out=load('GyroMean.csv');

plot(Vcmd,out)

%%

Vcmd=Vcmd';
out=out';

csvwrite('Gyro.csv',out);
csvwrite('Vss.csv',Vcmd);

%%

clear all; close all; clc;

Vss=load('Vss.csv');
out=load('Gyro.csv');

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

            plot(data(1:1000,1),data(1:1000,2))
            hold on

end

Minput_mean=Minput/20;
Gyro_mean=Gyro/20;

MinP=Minput_mean(1:1000);
GyroP=Gyro_mean(1:1000);

figure, plot(Minput_mean(1:1000),Gyro_mean(1:1000))


