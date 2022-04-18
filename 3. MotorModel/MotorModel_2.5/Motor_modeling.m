 % LAB4. 데이터를 이용한 모터 모델링 '알고리즘'
 % 받은 데이터의 노이즈를 제거하기 위해 LPF를 걸어준다.
 % 데이터를 연속으로 저장한다.
 % z-plane, 모델링의 계수(b0, a1, a0)를 계산하기 위해서 y, H 행렬을 구한다.
 % z-plane(b0, a1, a0)에서 S - plane(beta0, arpha1, arpha0)의 계수를 구한다.
 % bode plot해서 모터의 BW구하기
clear all; close all; clc;

starttime = 0;
finaltime = 10;
Fs =200;
Ts = 1/Fs ;

N =20;
Wc = 10; 
oder = 2;

datacount = 10000;

sigR = zeros(datacount,1);
sigW = zeros(datacount,1);
dataR = zeros(datacount*N,1);
dataW = zeros(datacount*N,1);

y = zeros(datacount*N-2,1);
H = zeros(datacount*N-2,3);


time = starttime: Ts : finaltime-Ts;
[Nz, Dz] = butter(2, Wc, 'low', 's') ;
LPF = tf(Nz, Dz)
LPF = c2d(LPF,Ts,'tustin') ;

for i = 1:N    %888 데이터파일 갯수만큼 돌리기
     
    s1 = 'Gyroout';
    s2 = sprintf("%d", i) ;
    s3 = '.txt';
    
    str1 = strcat(s1, s2, s3);
    
    data1 = load(str1);
    
%     figure()
%     plot(data1)
    
    sigR = lsim(LPF, data1(1:2000,1), time); % 노이즈 거르기
    sigW = lsim(LPF, data1(1:2000,2), time);


    start = 1 + 2000*(i-1); % 저장
    finish = 2000*i;

    dataR(start:finish,1) =  sigR; 
    dataW(start:finish,1) =  sigW;

end
 

% csvwrite('dataR.txt',dataR)
% csvwrite('dataW.txt',dataW)

for k=1:  datacount*N -2    % y, H 파일 만들기
    
    y(k,1) = dataW(k+2,1);
    H(k, 1) = dataR(k,1) + 2*dataR(k+1,1) + dataR(k+2,1);
    H(k, 2) = -dataW(k+1,1);
    H(k, 3) = -dataW(k,1);
  
end


 P = H'*H;            % 모델링 계수 구하기
 X =inv(P)*H'*y;
 
 b0 = X(1,1);
 a1 = X(2,1);
 a0 = X(3,1);
 
%  [ beta0 ,  arpha1, arpha2 ] = inv( [Ts^2 -2*Ts*b0 -Ts^2*b0 ;...
% 0 -a1*2*Ts (2*Ts^2 - a1*Ts^2);...
% 0 (-2*Ts*a0-2*Ts) (Ts^2 -a0*Ts^2);] )*[4*b0; 4*a1+8; 4*a0-4] 

% X = inv( [Ts^2 -2*Ts*b0 -Ts^2*b0 ;...
% 0 -a1*2*Ts (2*Ts^2 - a1*Ts^2);...
% 0 (-2*Ts*a0-2*Ts) (Ts^2 -a0*Ts^2);] )*[4*b0; 4*a1+8; 4*a0-4] 
% 
%  
%  num = [ X(1)];
%  den = [1 X(2) X(3)];
%  MoterModeling = tf(num , den)

M = [(-Ts^2) (Ts^2*b0) (2*Ts*b0); (0) (Ts^2*a1-2*Ts^2) (2*Ts*a1); (0) (Ts^2*a0-Ts^2) (2*Ts+2*Ts*a0)];
R = [-4*b0; -8-4*a1; 4-4*a0];
M_alpha_beta = inv(M)*R;

beta_0 = M_alpha_beta(1);
alpha_0 = M_alpha_beta(2);
alpha_1 = M_alpha_beta(3);

 num = [beta_0];
 den = [1 alpha_1 alpha_0];
 MoterModeling = tf(num , den)
 
 bode(MoterModeling)
 
 %%
 
 close all;
 for i=1:15
     
     f=0.1+0.1*(i-1);
    figure(),
    plot(time,dataR((i-1)*2000+1:i*2000),'G'),
    hold on,
    plot(time,dataW((i-1)*2000+1:i*2000),'R')
    hold on,
    lsim(MoterModeling, dataR((i-1)*2000+1:i*2000) ,time)
    
 end


 
