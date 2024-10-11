clc;
clear;
lambda=647e-6;
N=500;

r1=15.81;
r2=23.02;
t=10.25;
semid1=10.7435;
semid2=15.08817;
m={'S-LAM73'};

D=semid1*2;
lens=Lens([r1,r2],t,[semid1*2,semid2*2],m,lambda);
Lens.lensThickFcn(lens,D,N);