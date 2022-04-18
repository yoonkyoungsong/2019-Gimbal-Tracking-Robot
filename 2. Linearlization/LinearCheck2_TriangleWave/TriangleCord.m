clear all; close all; clc;


f=0.1;
t=0:0.005:20;
direction=1;
y=zeros(200,1);
k=1;
b=0;
count=-1;

for i=0:0.005:20
    
    if mod(i,1/f)==0
        count=count+1;
    end
    
     y(k)=direction*10*f*i+b;
     
    if y(k)==2.5000
        direction=-1;
        b=5 +10*count;
    elseif y(k)==-2.5000
        direction=1;
        b=-10-10*count; 
    end
    
    k=k+1;
    
 
end


plot(t,y)