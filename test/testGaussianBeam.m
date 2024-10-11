clc;
clear;
close all;
beam=GaussianBeam(5, 0.8,640e-6);
a=GaussianBeam.defocused(beam,1,500);
I=abs(a).^2;
imshow(I,[0,25])