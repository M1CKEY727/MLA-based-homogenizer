%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 带限角谱衍射传递函数计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：长度量单位均为 mm
% delta: 采样单元尺寸向量
% lambda:波长
% area:  目标平面尺寸向量
% z:     传播距离，标量或向量
% n:     传播介质折射率，默认值1
% coor： 离轴中心点坐标向量，默认值[0,0]
% 输出： 带限角谱衍射传递函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考文献：Kyoji Matsushima and Tomoyoshi Shimobaba.  
% Band-limited angular spectrum method for numerical simulation of free-space propagation in far and near fields.   
% Opt. Express, 17(22):19662–19673, Oct 2009.
% 传递函数请参考《傅里叶光学导论》
function p = Propagator(delta,lambda,area,z,n,coor)
%计算图像尺寸
imsize=round(area./delta);
if size(area)==ones(1,2)
    area=[area area];
end
if ~exist('coor','var')
    coor=[0,0];
end
%计算带限矩形，用来防止频谱混叠
rect=limitedBand(imsize,lambda, area,z,coor);
%计算系数
alpha=linspace(1,imsize(1),imsize(1));
beta=linspace(1,imsize(2),imsize(2));
alpha=(alpha-imsize(1)/2-1)/(area(1)*n);
beta=(beta-imsize(2)/2-1)/(area(2)*n);
%1D光场情况
if length(alpha)~=1
    [fX,fY]=meshgrid(alpha,beta);
else
    fX=0;
    fY=beta;
end
Alpha=lambda*fX;
Beta=lambda*fY;
%离轴情况计算频移
freq_shift=exp(-1i*2*pi*(fX.*coor(1)+fY.*coor(2)));
%计算传递函数
p=exp(2*pi*1i*n*z*sqrt(complex(1 - Alpha.^2 - Beta.^2))/lambda);
p=p.*freq_shift;
p=p.*rect;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%