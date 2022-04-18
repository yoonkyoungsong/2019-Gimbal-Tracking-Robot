%% 

clear all; close all; clc;

data=load('data_4.txt');
data1=load('Test1_7Á¶.txt');
data2=load('data.csv');

M=140;
N=30;


time2=data(1:N,1);
Vcmd=data(1:N,2);
Gyro=data(1:N,3)/2.5;


time1=data1(1:N,1);
Input=(data1(1:N,4)-1.3627)*100;

in=(data2(1:N,4)-1.3627)*100;

plot(time2, Gyro, time2, in)

%% step


 


