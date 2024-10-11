clc;
clear;
close all;
r1=-5;
r2=inf;
d=0.2;
t=2;
n=1.5;
lambda=640e-6;
N=1000;
tic
phase=lensPhase(([r1,r2]),d,1,t,n,lambda,N,'',[0,0]);
toc
phi=angle(phase);
gray=(phi+pi)/2/pi;
imshow(gray)