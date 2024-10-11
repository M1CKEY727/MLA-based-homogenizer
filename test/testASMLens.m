clc;
clear;
close all;
%% 添加路径
addpath('plane wave\')
addpath('holography spherical waves\')

%% 参数设置
lambda = 640e-6;    % 波长
color=wavelength2color(lambda*10^6, 'gammaVal', 2.2, 'maxIntensity', 255, 'colorSpace', 'rgb');
N =1000;           % 采样点数
r1 = -308.2;            % 透镜1的曲率半径
r2 = 308.2;           % 透镜2的曲率半径（设为无穷表示平面透镜）
d = 50.8;              % 透镜直径
D=10;
t = 5.1;            % 透镜厚度
material={'N-BK7'};
area1 = D;           % 光场的面积
area2 = 10;
distance1=150.*ones(N,N);
distance2=(0:D/N:10)';
%distance=cat(3,distance1,distance);
beam=GaussianBeam(1,D/2,lambda);
lens=Lens([r1,r2],t,d,material,lambda);
%% 生成透镜相位
%[delta_edge,delta_mid,delta_air,t_edge] = lensPhase_all([r1,r2],d,D,t,[N,N],'','');
%{
distance = (280:D/N:320)';   % 投影距离
Lens.lensThickFcn(lens,D,[1,N],'');

%origin=GaussianBeam.defocused(beam,20,N,D/N);
rate=area1./[N,N];
area1=rate.*[1,N];
%origin=drawCircle(D,0,0,N,N);
origin=ones(1,N);
%}
distance = 200;   % 投影距离
Lens.lensThickFcnGnr(lens,D,[N,N],'');

%origin=GaussianBeam.defocused(beam,20,N,D/N);
rate=area1./[N,N];

area1=rate.*[N,N];
%origin=drawCircle(D,0,0,N,N);
origin=ones(N,N);
%% 光场变换
tic
%afterLens=ASMLens(origin,delta_edge,delta_mid,delta_air,t_edge,lambda,n,area);
afterLens=ASMinLens(origin,lens,lambda,area1);
F = transform(afterLens, area1, lambda, distance, rate,1,1,[0,0]);
%F1 = transform(F(end,:), area1, lambda, distance2, rate,0.5,1,[0,0]);
%F=[F;F1];
Ia=abs(afterLens).^2;
Ia=gather(Ia);
imshow(angle(afterLens),[])
%
I = abs(F).^2;
I = gather(I);
I=(I-min(min(I)))./(max(max(I))-min(min(I)));
phase=angle(F);
imshow(I',[])
%II=gray2rgb(I,color);
%imshow(II)
%plot(I)
%
toc
%% 显示结果
%subplot(1,2,1)
%{
subplot(1,2,2)
imshow(I(:,:,2), [])
title('Intensity after propagation')
%}

%{
% 如果需要展示透镜对光场的透射效果，可以使用以下代码
for ii = 1:N
    F = transform(afterLens, area, lambda, 80*ii/N, [d/N, d/N]);
    I = abs(F).^2;
    I = gather(I);
    II(:, ii) = I(:, N/2);
end
imshow(II, [])
%}