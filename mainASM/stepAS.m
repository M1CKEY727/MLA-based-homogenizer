%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 阶梯角谱衍射
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：长度量单位均为 mm
% Image: 输入光场图像
% area:  目标平面尺寸向量
% lambda:波长
% z:     传播距离，标量或向量
% delta: 采样单元尺寸向量
% n:     传播介质折射率，默认值1
% piece: 分割片数，大于等于1，越大计算越精细，耗费资源越多
% 输出：  阶梯角谱衍射传播后的光场
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考文献：
%[6]  Chi-Young Hwang, Seungtaik Oh, Il-Kwon Jeong, and Hwi Kim.  
% Stepwise angular spectrum method for curved surface diffraction.   
% Opt. Express, 22(10):12659–12667, May 2014.
% 代码用了一个for循环,没有找到好的方法可以去掉
function result=stepAS(Image,area,lambda,z,delta,n,piece)
level=unique(z);
if level==0
    result=Image;
    return;
end
levelMax=max(level);
ratio=floor(length(level)/piece);
level=level(1:ratio:end);
piece=length(level);

FT_ori=FT2Dc(Image);
F2_freq=gpuArray(zeros(size(z),'single'));
%逐高度进行计算传播
for ii=1:piece-1
    aa=(z<level(ii+1))&(z>=level(ii));
    prop=Propagator(delta,lambda,area,levelMax-level(ii+1),n(1));
    F=IFT2Dc(FT_ori.*prop).*aa;
    F=F.*exp(1i* 2 * pi / lambda *n(1)*((level(ii+1))-z));
    F=F.*exp(1i* 2 * pi / lambda *n(2)*((z-level(ii))));
    prop=Propagator(delta,lambda,area,level(ii),n(2));
    F_freq=FT2Dc(F).*prop;
    F2_freq=F2_freq+F_freq;
end
result=IFT2Dc(F2_freq);
end