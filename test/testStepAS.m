clc;
clear;

%% 添加路径
addpath('plane wave\')
addpath('holography spherical waves\')

%% 参数设置
lambda = 640e-6;    % 波长
color=wavelength2color(lambda*10^6, 'gammaVal', 2.2, 'maxIntensity', 255, 'colorSpace', 'rgb');
N =500;           % 采样点数
r1 = -120;            % 透镜1的曲率半径
r2 = 120;           % 透镜2的曲率半径（设为无穷表示平面透镜）
r=[r1,r2];
d = 50.8;              % 透镜直径
D=5;
t = 10;            % 透镜厚度
material={'N-BK7'};
area1 = D;           % 光场的面积
area2 = D;
distance = 114.86;   % 投影距离
beam=GaussianBeam(1,D/6,lambda);
lens=Lens(r,t,d,material,lambda);
%% 生成透镜相位
Lens.lensThickFcn(lens,D,[N,N],'');
Lens.lensSingle(lens)%使用单精度变量
Lens.lensGPUArray(lens)%使用GPU
origin=drawCircle(N/2,0,0,N,N);
rate=area1./ size(origin,[1,2]);
%origin=origin.*GaussianBeam.waistProfile(beam,N,rate);%生成高斯光束
%% 光场变换
edge1=gather(lens.thick_edge(:,:,1));
%把透镜厚度函数分割成nn份
nn=100;
level=unique(edge1);
ratio=floor(length(level)/nn);
level=level(1:ratio:end);
%{
level=linspace(min(min(edge1)),max(max(edge1)),nn);
FF=gpuArray(zeros(size(edge1),'single'));
FF2_freq=gpuArray(zeros(size(edge1),'single'));
%从透镜前平面衍射到透镜前表面
FT_ori=FT2Dc(origin);
%for jj=1:length(r)*2
levelMax=gpuArray(max(level));
%}
%F=stepAS(origin,area1,lambda,lens.thick_edge(:,:,1),rate,[1,lens.n_curwl],nn);
%F=transform(F,area1,lambda,lens.thick_mid,rate,lens.n_curwl);
%FF2=stepAS(F,area1,lambda,lens.thick_edge_max(2)-lens.thick_edge(:,:,2),rate,[lens.n_curwl,1],nn);
tic
FF2=stepASMinLens(origin,lens,lambda,area1,nn);
toc
%{
for ii=1:nn-1
    aa=(edge1<level(ii+1))&(edge1>level(ii));
    prop=Propagator(rate,lambda,area1,levelMax-level(ii),1);
    F=IFT2Dc(FT_ori.*prop).*aa;
    FF=FF+F;
end
%透镜前表面衍射到透镜中一个平面
for ii=1:nn-1
    aa=(edge1<level(ii+1))&(edge1>level(ii));
    prop=Propagator(rate,lambda,area1,level(ii),lens.n_curwl);
    F_freq=FT2Dc(FF.*aa).*prop;
    FF2_freq=FF2_freq+F_freq;
end
%透镜中平面衍射到透镜后表面
FF2=IFT2Dc(FF2_freq);
FF=gpuArray(zeros(size(edge1),'single'));
FT_FF2=FT2Dc(FF2);
for ii=1:nn-1
    aa=(edge1<level(ii+1))&(edge1>level(ii));
    prop=Propagator(rate,lambda,area1,level(ii)+lens.thick_mid,lens.n_curwl);
    F=IFT2Dc(FT_FF2.*prop).*aa;
    FF=FF+F;
end
%透镜后表面衍射到透镜后平面
FF2_freq=gpuArray(zeros(size(edge1),'single'));
for ii=1:nn-1
    aa=(edge1<level(ii+1))&(edge1>level(ii));
    prop=Propagator(rate,lambda,area1,lens.thick_edge_max(1)-level(ii),1);
    F_freq=FT2Dc(FF.*aa).*prop;
    FF2_freq=FF2_freq+F_freq;
end
FF2=IFT2Dc(FF2_freq);
%}
%end
%透镜后平面衍射到焦点
FF=transform(FF2,area1,lambda,distance,rate,1);
I1=abs(FF).^2;
I1=(I1-min(min(I1)))/(max(max(I1))-min(min(I1)));
afterLens=ASMinLens(origin,lens,lambda,area1);
F=transform(afterLens,area1,lambda,distance,rate,1);
I2=abs(F).^2;
I2=(I2-min(min(I2)))/(max(max(I2))-min(min(I2)));
subplot(2,2,1)
imshow(I1,[])
subplot(2,2,2)
imshow(I2,[])
subplot(2,2,3.5)
plot(I1(N/2,:))
hold on
plot(I2(N/2,:))