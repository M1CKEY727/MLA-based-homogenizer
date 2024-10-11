function window=hann2D(M,N)
% 生成一维的汉宁窗
hann1D_row = hann(M);
hann1D_col = hann(N);
% 将一维窗口应用于两个方向，得到二维窗口
window = hann1D_row * hann1D_col';
end