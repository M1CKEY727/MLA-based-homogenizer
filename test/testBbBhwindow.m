% 定义窗口大小
rows = 100;
cols = 200;

% 生成一维的布莱克曼-哈里斯窗
bh1D_row = blackmanHarrisWindowGenerator(rows);
bh1D_col = blackmanHarrisWindowGenerator(cols);

% 将一维窗口应用于两个方向，得到二维窗口
bh2D = bh1D_row'* bh1D_col;

% 可视化二维布莱克曼-哈里斯窗
figure;
surf(bh2D);
title('二维布莱克曼-哈里斯窗');
xlabel('列');
ylabel('行');
zlabel('Amplitude');


function bhWindow = blackmanHarrisWindowGenerator(M)
    n = 0:M-1;
    alpha = 0.35875;
    beta = 0.48829;
    gamma = 0.14128;
    
    blackmanPart = 0.42 - 0.5 * cos(2 * pi * n / (M-1)) + 0.08 * cos(4 * pi * n / (M-1));
    harrisPart = alpha - beta * cos(2 * pi * n / (M-1)) + gamma * cos(4 * pi * n / (M-1));
    
    bhWindow = blackmanPart .* harrisPart;
end