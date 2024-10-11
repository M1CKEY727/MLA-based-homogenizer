% 定义窗口大小和形状参数
rows = 100;
cols = 200;
beta = 5; % 调整形状参数

% 生成一维的凯赛窗
kaiser1D_row = kaiserWindowGenerator(rows, beta);
kaiser1D_col = kaiserWindowGenerator(cols, beta);

% 将一维窗口应用于两个方向，得到二维窗口
kaiser2D = kaiser1D_row' * kaiser1D_col;

% 可视化二维凯赛窗
figure;
surf(kaiser2D);
title('二维凯赛窗');
xlabel('列');
ylabel('行');
zlabel('Amplitude');


function kaiserWindow = kaiserWindowGenerator(M, beta)
    n = 0:M-1;
    arg = beta * sqrt(1 - ((2 * n) / (M-1) - 1).^2);
    kaiserWindow = besseli(0, arg) / besseli(0, beta);
end