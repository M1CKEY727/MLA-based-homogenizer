clc;
clear;
close all;

%% 添加路径
addpath('plane wave\')

%% 参数设置
lambda = 561e-6;    % 波长
beamSize=3;       %初始高斯光束腰斑直径
beamStd=beamSize/2;
beamAmp=1;
beam=GaussianBeam(beamAmp,beamStd,lambda);
N = 1500;           % 采样点数
r1=-20.89;
r2=16.73;
r3=79.8;
d = 25.4;              % 傅里叶透镜直径
D = 5;              %采样区域
t = [12,2];            % 傅里叶透镜厚度
material={'N-BAF10','N-SF6HT'};
beams=GaussianBeam.defocused(beam,10,N,D/N);
%{
r1 = -128.23;            % 傅里叶透镜的曲率半径（胶合透镜）
r2 = -45.71;
r3 = 62.75;
d = 25.4;              % 透镜直径
D=8;
t = [2.5,4];            % 透镜厚度
%n = [1.64416,1.51491];         % 透镜折射率
material={'SF5','N-BK7'};
%}
area = D;           % 光场的面积
distance = 22.12;   % 投影距离
lens=Lens([r1,r2,r3],t,d,material,lambda);
%% 生成透镜相位
%[delta_edge,delta_mid,delta_air,t_edge] = lensPhase_all([r1,r2,r3],d,D,t,N,'square');
Lens.lensThickFcnGnr(lens,D,N)
% 在透镜上添加圆形光阑
%mask = drawCircle(500, 0, 0, N, N);
origin = ones(N, N);

if canUseGPU
   Lens.lensGPUArray(lens);
   Lens.lensSingle(lens);
end
%% 光场变换
tic
F = transform(origin, area, lambda, distance, [D/N, D/N]);
%afterLens=ASMLens(F,delta_edge,delta_mid,delta_air,t_edge,lambda,n,area);
afterLens=stepASMinLens(F,lens,lambda,area,50);
Ia=abs(afterLens).^2;
F = transform(afterLens, area, lambda, distance, [D/N, D/N],1,10);
I = abs(F).^2;
toc
%% 显示结果
subplot(1, 2, 1)
imshow(Ia, [])
title('Intensity after Lens')

subplot(1, 2, 2)
imshow(I, [])
title('Intensity')
%max(max(I))
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