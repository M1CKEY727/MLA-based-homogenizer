clc;
clear;
a=drawCircle(10,0,0,100,100);
imshow(a)
area=1;
lambda=640e-6;
z=10;
delta=[area/100,area/100];
a=transform(a,area,lambda,z,delta);
a=abs(a).^2;
imshow(a)