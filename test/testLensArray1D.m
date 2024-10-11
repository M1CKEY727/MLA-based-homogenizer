clc;
clear;
close all;

%% 添加路径
addpath('plane wave\')
addpath('holography spherical waves\')

%% 参数设置
lambda = 561e-6;    % 波长
N =400;           % 采样点数
r1 = -1.944;            % 透镜1的曲率半径
r2 = inf;           % 透镜2的曲率半径（设为无穷表示平面透镜）
d = 0.185;              % 透镜直径
t = 1;            % 透镜厚度
material={'D-K9'};
n=calMaterialRI(material,lambda);
%n = 1.45706;         % 透镜折射率
num=5;
distance = 3.095;   % 投影距离
rate=[d/N,d/N];
area = [1*rate(1) d*num];           % 光场的面积
lensArray=Lens([r1,r2],t,d,material,lambda);
%% 生成透镜相位
%[delta_edge,delta_mid,delta_air,t_edge]=lensArray_all([r1,r2],d,t,N,num,'hexagon',0,0.175);
Lens.lensArrayThickFcn(lensArray,N,num,'square',0,0.175);
lensArray.thick_edge=lensArray.thick_edge(N/2+1,:,:);
lensArray.thick_air=lensArray.thick_air(N/2+1,:,:);
subplot(2,2,1)
%imshow(lensArray.thick_edge(:,:,1),[])
plot(lensArray.thick_edge(:,:,1))
subplot(2,2,2)
%imshow(lensArray.thick_edge(:,:,2),[])
plot(lensArray.thick_edge(:,:,2))
subplot(2,2,3)
%imshow(lensArray.thick_air(:,:,1),[])
plot(lensArray.thick_air(:,:,1))
subplot(2,2,4)
%imshow(lensArray.thick_air(:,:,2),[])
plot(lensArray.thick_air(:,:,2))

% 在透镜上添加圆形光阑
%mask = drawCircle(N/2, 0, 0, N, N);
%phaseLens = phaseLens .* mask;

origin = ones(1,(num)*N);
%% 光场变换
tic
%afterLens=ASMLens(origin,delta_edge,delta_mid,delta_air,t_edge,lambda,n,area);
afterLens=ASMinLens(origin,lensArray,lambda,area);
F = transform(afterLens, area, lambda, distance, rate);
Ia=abs(afterLens).^2;
Ia=gather(Ia);
I = abs(F).^2;
I = gather(I);
toc
%% 显示结果
figure
subplot(1,2,1)
%imshow(delta_edge(:,:,1),[])
plot(Ia)
title('Intensity after Lens')
subplot(1,2,2)
plot(I)
title('Intensity after propagation')



% 如果需要展示透镜对光场的透射效果，可以使用以下代码
%{
for ii = 1:N
    F = transform(afterLens, area, lambda, distance*2*ii/N, [rate, rate]);
    I = abs(F).^2;
    I = gather(I);
    II(:, ii) = I(:, N/2);
end
imshow(II, [])
%}