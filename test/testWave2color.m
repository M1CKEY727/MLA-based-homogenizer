clc;
clear;
N=400;
a=ones(N,N,3);
b=wavelength2color(640, 'gammaVal', 1, 'maxIntensity', 255, 'colorSpace', 'rgb')
for ii=1:3
    a(:,:,ii)=a(:,:,ii)*b(ii);
end
a=uint8(a);
imshow(a)