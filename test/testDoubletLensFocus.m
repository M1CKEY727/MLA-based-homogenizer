clc;
clear;
close all;

%% 添加路径
addpath('plane wave\')

%% 参数设置
lambda = 640e-6;    % 波长
N = 4000;           % 采样点数
r1 = -557.400;            % 透镜1的曲率半径
r2 = -137.090;           % 透镜2的曲率半径（设为无穷表示平面透镜）
r3 = 165.2;
d = 40;              % 透镜直径
D=40;
t = [2,4];            % 透镜厚度
n = [1.64416,1.51491];         % 透镜折射率
area = D;           % 光场的面积
distance = 300.178;   % 投影距离

%% 生成透镜相位
phaseLens = lensPhase([r1, r2,r3], d,D, t, n, lambda, N,'', 'PU');

% 在透镜上添加圆形光阑
mask = drawCircle(N/2-1, 0, 0, N, N);
phaseLens = phaseLens .* mask;

II = zeros(N, N);   % 存储变换后的图像
origin = ones(N, N);
afterLens = origin .* phaseLens;

%% 光场变换
F = transform(afterLens, area, lambda, distance, [D/N, D/N]);
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