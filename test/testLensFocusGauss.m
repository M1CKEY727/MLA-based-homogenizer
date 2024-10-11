clc;
clear;
close all;

%% 添加路径
addpath('plane wave\')

%% 参数设置
lambda = 640e-6;    % 波长
N = 150;           % 采样点数
r1 = -0.7;            % 透镜1的曲率半径
r2 = inf;           % 透镜2的曲率半径（设为无穷表示平面透镜）
d = 0.145;              % 透镜直径
t = 1;            % 透镜厚度
n = 1.5144;         % 透镜折射率
num=12;             %透镜阵列数量
area = num*d;           % 光场的面积
distance = 0.506;   % 投影距离

%% 生成透镜相位
%phaseLens = lensPhase([r1, r2], d, t, n, lambda, N, 'GPU');
phaseLens=lensArrayPhase(r1,d,t, n, lambda, N,num);
% 在透镜上添加圆形光阑
mask = drawCircle(N/2, 0, 0, N, N);
%phaseLens = phaseLens .* mask;

II = zeros(N, N);   % 存储变换后的图像
beam=GaussianBeam(1.6,num*N,d/N);

origin=beam;
afterLens = origin .* phaseLens;

%% 光场变换
F = transform(afterLens, area, lambda, distance, [d/N, d/N]);
I = abs(F).^2;
I = gather(I);

%% 显示结果
subplot(1, 2, 1)
imshow(I, [])
title('Intensity after Lens')

phi = angle(phaseLens);
subplot(1, 2, 2)
imshow(phi, [])
title('Phase of the Lens')

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