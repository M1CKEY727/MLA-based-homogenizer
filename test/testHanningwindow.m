% 定义窗口大小
rows = 100;
cols = 200;

window=hann2D(rows,cols);
% 可视化二维汉宁窗
figure;
surf(window);
title('二维汉宁窗');
xlabel('列');
ylabel('行');
zlabel('Amplitude');
N=100;
n=-N/2:1:0;
w=0.5*(1+cos(2*pi*n/(N-1)));
plot(w)