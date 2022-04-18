clear all; close all; clc;

syms s; syms z;

syms zeta; syms Wn; syms k;

num=k*Wn^2;
den=s^2+2*zeta*Wn*s+Wn^2;

Gm=num/den;

syms alpha0; syms alpha1; syms beta0;

nums= beta0;
dens=s^2+alpha1*s+alpha0;
Gms=num/den;

syms a0; syms a1; syms b0;

numz= b0+2*b0*z^(-1)+b0*z^(-2);
denz=1+a0*z^(-1)+a0*z^(-2);

Gmz=numz/denz



