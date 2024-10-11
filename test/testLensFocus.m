clc;
clear;
close all;

%% 添加路径
addpath('plane wave\')

%% 参数设置
lambda = 640e-6;    % 波长
N = 500;           % 采样点数
r1 = -0.6;            % 透镜1的曲率半径
r2 = inf;           % 透镜2的曲率半径（设为无穷表示平面透镜）
d = 0.5;              % 透镜直径
t = 0.0085;            % 透镜厚度
n = 1.5144;         % 透镜折射率
m={'D-K9'};
area = d/2;           % 光场的面积
distance = 1.1664;   % 投影距离
lens=Lens([r1,r2],t,d,m);
%% 生成透镜相位
%phaseLens = lensPhase([r1, r2], d,d/2, t, n, lambda, N,'');
Lens.lensPhase(lens,d/2,lambda,N,'');
rate=d/2/N;
% 在透镜上添加圆形光阑
mask = drawCircle(N/4, 0, 0, N, N);
lens.phase = lens.phase .* mask;

origin = ones(N, N);
afterLens = origin .* lens.phase;

%% 光场变换
F = transform(afterLens, area, lambda,distance, [rate, rate]);
I = abs(F).^2;
I = gather(I);

%% 显示结果

subplot(1, 2, 1)
imshow(I, [])
title('Intensity after Lens')

phi = angle(lens.phase);
subplot(1, 2, 2)
imshow(phi, [])
title('Phase of the Lens')


% 如果需要展示透镜对光场的透射效果，可以使用以下代码
for ii = 1:N
    F = transform(afterLens, area, lambda, 2.4*ii/N, [rate, rate]);
    I = abs(F).^2;
    I = gather(I);
    I=(I-min(min(I)))./(max(max(I))-min(min(I)));
    II(:, ii) = I(:, N/2);
end
imshow(II, [])
