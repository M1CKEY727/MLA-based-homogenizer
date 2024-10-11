%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 二维逆傅里叶变换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：1D,2D,3D光场频谱（角谱）
% 输出：1D,2D,3D光场分布
function [out] = IFT2Dc(in)
sizeOfin=size(in);
%输入为单个横向光场分布
if numel(sizeOfin)==2
    IFT=fftshift(in);
    IFT=ifft2(IFT);
    out=fftshift(IFT);
%输入为多张横向光场分布（三维张量形式）
else
    IFT=fftshift(in,1);
    IFT=fftshift(IFT,2);

    IFT=ifft2(IFT);

    IFT=fftshift(IFT,1);
    out=fftshift(IFT,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%