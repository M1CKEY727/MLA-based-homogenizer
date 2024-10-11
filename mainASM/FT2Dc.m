%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 二维傅里叶变换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 作者：米远
% 时间：2023
% 平台：MATLAB R2022b
% 输入：1D,2D,3D光场分布
% 输出：1D,2D,3D光场频谱（角谱）
function out = FT2Dc(in)
sizeOfin=size(in);
%输入为单个横向光场分布
if numel(sizeOfin)==2
    FT=fftshift(in);
    FT=fft2(FT);
    out=fftshift(FT);
%输入为多张横向光场分布（三维张量形式）
else
    FT=fftshift(in,1);
    FT=fftshift(FT,2);

    FT=fft2(FT);

    FT=fftshift(FT,1);
    out=fftshift(FT,2);
end

